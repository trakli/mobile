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
  Completer<void>? _connecting;

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
      await _connectSocket();
      return; // subscription happens once connection_established arrives
    }
    if (_socketId != null) {
      await _subscribeToTarget();
    }
  }

  /// Unsubscribes from the current channel without closing the socket, so
  /// re-subscribing (e.g. reopening the same session) is instant.
  void unsubscribe() {
    _targetSessionId = null;
    final channel = _subscribedChannel;
    if (channel != null && _channel != null) {
      _channel!.sink.add(encodeUnsubscribe(channel));
    }
    _subscribedChannel = null;
  }

  Future<void> _connectSocket() async {
    if (_connecting != null) return _connecting!.future;
    final completer = Completer<void>();
    _connecting = completer;
    try {
      final channel = connectOverride(_config.socketUri);
      _channel = channel;
      _channelSub = channel.stream.listen(
        _onMessage,
        onError: (Object e, StackTrace st) {
          logger.w('Reverb socket error: $e');
          _scheduleReconnect();
        },
        onDone: () {
          if (!_disposed) _scheduleReconnect();
        },
        cancelOnError: true,
      );
      // connection_established arrives asynchronously via _onMessage; this
      // completer just tracks that a connection attempt is in flight.
      unawaited(channel.ready.then((_) {}, onError: (_) {
        _scheduleReconnect();
      }));
    } finally {
      completer.complete();
      _connecting = null;
    }
  }

  void _onMessage(dynamic raw) {
    if (raw is! String) return;
    final frame = parsePusherFrame(raw);
    switch (frame) {
      case ConnectionEstablished(:final socketId):
        _socketId = socketId;
        _reconnectAttempt = 0;
        unawaited(_subscribeToTarget());
      case PusherPing():
        _channel?.sink.add(encodePong());
      case PusherError(:final message):
        logger.w('Reverb protocol error: $message');
      case ChatTurnFrame():
        _turnEventsController.add(frame);
      case SubscriptionSucceeded():
      case UnknownFrame():
        break;
    }
  }

  Future<void> _subscribeToTarget() async {
    final sessionId = _targetSessionId;
    final socketId = _socketId;
    if (sessionId == null || socketId == null || _channel == null) return;

    final channel = chatSessionChannel(sessionId);
    if (channel == _subscribedChannel) return;

    final previous = _subscribedChannel;
    if (previous != null) {
      _channel!.sink.add(encodeUnsubscribe(previous));
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
      // The target may have changed while the auth request was in flight.
      if (_targetSessionId != sessionId) return;
      _channel?.sink.add(encodeSubscribe(channel: channel, auth: auth));
      _subscribedChannel = channel;
    } on DioException catch (e) {
      logger.w('Reverb channel auth failed for $channel: $e');
    }
  }

  void _scheduleReconnect() {
    _channelSub?.cancel();
    _channelSub = null;
    _channel = null;
    _socketId = null;
    _subscribedChannel = null;
    if (_disposed || _targetSessionId == null) return;

    _reconnectTimer?.cancel();
    final i = _reconnectAttempt < _reconnectBackoff.length
        ? _reconnectAttempt
        : _reconnectBackoff.length - 1;
    _reconnectAttempt++;
    _reconnectTimer = Timer(_reconnectBackoff[i], () {
      if (!_disposed) unawaited(_connectSocket());
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
