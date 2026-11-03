import 'dart:convert';

/// A parsed frame from the Pusher/Reverb websocket protocol. Pusher wraps
/// every message as `{"event": ..., "channel": ..., "data": ...}` where
/// `data` is itself a JSON-encoded string (not a nested object) for
/// system events, and encoded per-broadcast for channel events.
sealed class PusherFrame {
  const PusherFrame();
}

class ConnectionEstablished extends PusherFrame {
  const ConnectionEstablished(this.socketId);
  final String socketId;
}

class SubscriptionSucceeded extends PusherFrame {
  const SubscriptionSucceeded(this.channel);
  final String channel;
}

class PusherPing extends PusherFrame {
  const PusherPing();
}

class PusherError extends PusherFrame {
  const PusherError(this.message);
  final String? message;
}

/// A chat turn update, mirroring the server's `ChatTurnEvent` broadcast
/// payload: `{message_id, kind, label}` where kind is `progress` (a tool
/// step, with a label) or `settled` (the answer was saved).
class ChatTurnFrame extends PusherFrame {
  const ChatTurnFrame({required this.messageId, required this.kind, this.label});
  final int messageId;
  final String kind;
  final String? label;

  bool get isProgress => kind == 'progress';
  bool get isSettled => kind == 'settled';
}

class UnknownFrame extends PusherFrame {
  const UnknownFrame(this.event);
  final String? event;
}

String chatSessionChannel(int sessionId) => 'private-chat-session.$sessionId';

/// Parses a raw text frame received from the socket. Returns [UnknownFrame]
/// (never throws) for anything unrecognized, so a malformed or future
/// server message can't crash the connection.
PusherFrame parsePusherFrame(String raw) {
  try {
    final envelope = jsonDecode(raw);
    if (envelope is! Map) return const UnknownFrame(null);
    final event = envelope['event'] as String?;
    final rawData = envelope['data'];
    // System events encode `data` as a JSON string; channel events (ours)
    // are sent the same way by Reverb.
    final data = rawData is String
        ? (jsonDecode(rawData) is Map ? jsonDecode(rawData) as Map : null)
        : (rawData is Map ? rawData : null);

    switch (event) {
      case 'pusher:connection_established':
        final socketId = data?['socket_id'] as String?;
        if (socketId == null) return UnknownFrame(event);
        return ConnectionEstablished(socketId);
      case 'pusher:ping':
        return const PusherPing();
      case 'pusher:error':
        return PusherError(data?['message'] as String?);
      case 'pusher_internal:subscription_succeeded':
        final channel = envelope['channel'] as String?;
        return channel == null
            ? UnknownFrame(event)
            : SubscriptionSucceeded(channel);
      case 'turn':
        final messageId = data?['message_id'];
        final kind = data?['kind'] as String?;
        if (messageId is! int || kind == null) return UnknownFrame(event);
        return ChatTurnFrame(
          messageId: messageId,
          kind: kind,
          label: data?['label'] as String?,
        );
      default:
        return UnknownFrame(event);
    }
  } catch (_) {
    return const UnknownFrame(null);
  }
}

String encodeSubscribe({required String channel, required String auth}) =>
    jsonEncode({
      'event': 'pusher:subscribe',
      'data': {'channel': channel, 'auth': auth},
    });

String encodeUnsubscribe(String channel) => jsonEncode({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channel},
    });

String encodePong() => jsonEncode({'event': 'pusher:pong', 'data': {}});
