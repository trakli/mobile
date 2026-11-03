import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/module/realtime_module.dart';
import 'package:trakli/core/realtime/pusher_protocol.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Live transport for AI chat turn events (Laravel Reverb, Pusher protocol
/// 7). Mirrors what the web client gets from Laravel Echo, hand-rolled
/// since there's no Echo-equivalent package for Dart: connect, capture
/// `socket_id`, authorize the session's private channel via
/// `/broadcasting/auth` (Sanctum token attached by the existing Dio
/// interceptor), subscribe, and surface `turn` events on a broadcast
/// stream. Reconnects with backoff and re-subscribes automatically.
///
/// A no-op when [ReverbConfig.enabled] is false — callers should keep
/// polling as the fallback transport regardless of [enabled].
@lazySingleton
class ReverbSocketClient {
  ReverbSocketClient(this._config, this._dio);

  final ReverbConfig _config;
  final Dio _dio;

  /// Test seam. Deliberately not a constructor parameter: injectable's
  /// codegen scans every constructor parameter for injection regardless of
  /// default values, and would otherwise try (and fail) to inject
  /// [WebSocketChannelFactory], which has no DI registration.
  @visibleForTesting
  WebSocketChannelFactory connectOverride = WebSocketChannel.connect;

  static const _reconnectBackoff = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
  ];

  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;
  String? _socketId;
  String? _subscribedChannel;
  int? _targetSessionId;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  bool _disposed = false;

  final _turnEventsController = StreamController<ChatTurnFrame>.broadcast();

  bool get enabled => _config.enabled;

  /// Turn events for whichever session is currently subscribed. Callers
  /// should filter by session/message id — a race between switching
  /// sessions and an in-flight event is possible and harmless to ignore.
  Stream<ChatTurnFrame> get turnEvents => _turnEventsController.stream;

  /// Connects (if needed) and subscribes to [sessionId]'s private channel,
  /// unsubscribing from any previously-subscribed session first. Safe to
  /// call repeatedly, including before the socket has finished connecting.
  Future<void> subscribeToSession(int sessionId) async {
    if (!enabled || _disposed) return;
    _targetSessionId = sessionId;

    if (_channel == null) {
      // Subscription happens once connection_established arrives.
      _connectSocket();
      return;
    }
    if (_socketId != null) {
      await _subscribeToTarget();
    }
  }

  /// Unsubscribes from the current channel without closing the socket, so
  /// re-subscribing (e.g. reopening the same session) is instant. Also
  /// cancels any pending reconnect: with no target session there is
  /// nothing to reconnect for.
  void unsubscribe() {
    _targetSessionId = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    final channel = _subscribedChannel;
    if (channel != null && _channel != null) {
      _channel!.sink.add(encodeUnsubscribe(channel));
    }
    _subscribedChannel = null;
  }

  /// Opens a socket unless one is already open. Every callback is bound to
  /// the channel it was registered for and ignored once that channel has
  /// been replaced, so a late error or close from an old socket can't tear
  /// down the current one.
  void _connectSocket() {
    if (_disposed || _channel != null) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    final channel = connectOverride(_config.socketUri);
    _channel = channel;
    _channelSub = channel.stream.listen(
      (raw) {
        if (identical(_channel, channel)) _onMessage(raw);
      },
      onError: (Object e, StackTrace st) {
        logger.w('Reverb socket error: $e');
        _dropAndReconnect(channel);
      },
      onDone: () => _dropAndReconnect(channel),
      cancelOnError: true,
    );
    unawaited(channel.ready.then((_) {}, onError: (Object e) {
      logger.w('Reverb socket failed to connect: $e');
      _dropAndReconnect(channel);
    }));
  }

  void _onMessage(dynamic raw) {
    if (raw is! String) return;
    final frame = parsePusherFrame(raw);
    switch (frame) {
      case ConnectionEstablished(:final socketId):
        logger.d('Reverb connected to ${_config.host} (socket $socketId)');
        _socketId = socketId;
        _reconnectAttempt = 0;
        unawaited(_subscribeToTarget());
      case PusherPing():
        _channel?.sink.add(encodePong());
      case PusherError(:final message):
        logger.w('Reverb protocol error: $message');
      case ChatTurnFrame(:final messageId, :final kind, :final label):
        logger.d('Reverb turn $kind for message $messageId: ${label ?? ''}');
        _turnEventsController.add(frame);
      case SubscriptionSucceeded(:final channel):
        logger.d('Reverb subscribed to $channel');
      case UnknownFrame():
        break;
    }
  }

  Future<void> _subscribeToTarget() async {
    final sessionId = _targetSessionId;
    final socketId = _socketId;
    final ws = _channel;
    if (sessionId == null || socketId == null || ws == null) return;

    final channel = chatSessionChannel(sessionId);
    if (channel == _subscribedChannel) return;

    final previous = _subscribedChannel;
    if (previous != null) {
      ws.sink.add(encodeUnsubscribe(previous));
      _subscribedChannel = null;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _config.authUrl,
        data: {'socket_id': socketId, 'channel_name': channel},
      );
      final auth = response.data?['auth'] as String?;
      if (auth == null) {
        logger.w('Reverb auth response missing "auth" for $channel');
        return;
      }
      // Anything may have changed while the auth request was in flight:
      // the target session, or the socket itself. The signature is bound
      // to [socketId], so it's useless on a reconnected socket, and that
      // socket subscribes on its own connection_established.
      if (_targetSessionId != sessionId) return;
      if (!identical(_channel, ws) || _socketId != socketId) return;
      if (_subscribedChannel == channel) return;
      ws.sink.add(encodeSubscribe(channel: channel, auth: auth));
      _subscribedChannel = channel;
    } on DioException catch (e) {
      logger.w('Reverb channel auth failed for $channel: $e');
    }
  }

  /// Tears down [channel] and schedules a reconnect with backoff. A no-op
  /// if [channel] has already been replaced (a stale callback). Both the
  /// stream and `ready` report a failed connect, so this runs at most once
  /// per channel.
  void _dropAndReconnect(WebSocketChannel channel) {
    if (!identical(_channel, channel)) return;
    _channelSub?.cancel();
    _channelSub = null;
    _channel = null;
    _socketId = null;
    _subscribedChannel = null;
    unawaited(channel.sink.close().catchError((_) {}));
    if (_disposed || _targetSessionId == null) return;

    _reconnectTimer?.cancel();
    final i = _reconnectAttempt < _reconnectBackoff.length
        ? _reconnectAttempt
        : _reconnectBackoff.length - 1;
    _reconnectAttempt++;
    _reconnectTimer = Timer(_reconnectBackoff[i], () {
      _reconnectTimer = null;
      // The session may have been closed, or a new socket opened by
      // subscribeToSession, while this timer was pending.
      if (_disposed || _targetSessionId == null || _channel != null) return;
      _connectSocket();
    });
  }

  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _channelSub?.cancel();
    unawaited(_channel?.sink.close());
    unawaited(_turnEventsController.close());
  }
}

typedef WebSocketChannelFactory = WebSocketChannel Function(Uri uri);
