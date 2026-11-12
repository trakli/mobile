import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/realtime/pusher_protocol.dart';

String _envelope(String event, Object? data, {String? channel}) => jsonEncode({
      'event': event,
      if (channel != null) 'channel': channel,
      'data': data is String ? data : jsonEncode(data),
    });

void main() {
  group('parsePusherFrame', () {
    test('parses connection_established', () {
      final raw = _envelope('pusher:connection_established',
          {'socket_id': '123.456', 'activity_timeout': 30});
      final frame = parsePusherFrame(raw);
      expect(frame, isA<ConnectionEstablished>());
      expect((frame as ConnectionEstablished).socketId, '123.456');
    });

    test('parses ping', () {
      expect(parsePusherFrame(_envelope('pusher:ping', {})), isA<PusherPing>());
    });

    test('parses error with message', () {
      final frame =
          parsePusherFrame(_envelope('pusher:error', {'message': 'nope'}));
      expect(frame, isA<PusherError>());
      expect((frame as PusherError).message, 'nope');
    });

    test('parses subscription_succeeded', () {
      final frame = parsePusherFrame(_envelope(
        'pusher_internal:subscription_succeeded',
        {},
        channel: 'private-chat-session.7',
      ));
      expect(frame, isA<SubscriptionSucceeded>());
      expect((frame as SubscriptionSucceeded).channel, 'private-chat-session.7');
    });

    test('parses a progress turn event', () {
      final frame = parsePusherFrame(_envelope('turn', {
        'message_id': 42,
        'kind': 'progress',
        'label': 'Checking your budgets…',
      }));
      expect(frame, isA<ChatTurnFrame>());
      final turn = frame as ChatTurnFrame;
      expect(turn.messageId, 42);
      expect(turn.isProgress, isTrue);
      expect(turn.isSettled, isFalse);
      expect(turn.label, 'Checking your budgets…');
    });

    test('parses a settled turn event with no label', () {
      final frame = parsePusherFrame(
          _envelope('turn', {'message_id': 42, 'kind': 'settled'}));
      final turn = frame as ChatTurnFrame;
      expect(turn.isSettled, isTrue);
      expect(turn.label, isNull);
    });

    test('unknown event name yields UnknownFrame, not a crash', () {
      final frame = parsePusherFrame(_envelope('something:else', {}));
      expect(frame, isA<UnknownFrame>());
      expect((frame as UnknownFrame).event, 'something:else');
    });

    test('turn event missing message_id yields UnknownFrame', () {
      final frame =
          parsePusherFrame(_envelope('turn', {'kind': 'progress'}));
      expect(frame, isA<UnknownFrame>());
    });

    test('malformed JSON never throws', () {
      expect(() => parsePusherFrame('not json at all'), returnsNormally);
      expect(parsePusherFrame('not json at all'), isA<UnknownFrame>());
    });

    test('non-object top level never throws', () {
      expect(parsePusherFrame('[1,2,3]'), isA<UnknownFrame>());
    });

    test('data as a plain (non-string) map is still parsed', () {
      // Some servers send `data` as a nested object rather than a JSON
      // string; the parser should accept either shape.
      final raw = jsonEncode({
        'event': 'turn',
        'data': {'message_id': 1, 'kind': 'settled'},
      });
      final frame = parsePusherFrame(raw);
      expect(frame, isA<ChatTurnFrame>());
    });
  });

  group('chatSessionChannel', () {
    test('formats the private channel name', () {
      expect(chatSessionChannel(7), 'private-chat-session.7');
    });
  });

  group('wire encoders', () {
    test('encodeSubscribe includes channel and auth', () {
      final decoded = jsonDecode(
          encodeSubscribe(channel: 'private-chat-session.7', auth: 'k:sig'));
      expect(decoded['event'], 'pusher:subscribe');
      expect(decoded['data']['channel'], 'private-chat-session.7');
      expect(decoded['data']['auth'], 'k:sig');
    });

    test('encodeUnsubscribe includes channel', () {
      final decoded = jsonDecode(encodeUnsubscribe('private-chat-session.7'));
      expect(decoded['event'], 'pusher:unsubscribe');
      expect(decoded['data']['channel'], 'private-chat-session.7');
    });

    test('encodePong has the expected event name', () {
      final decoded = jsonDecode(encodePong());
      expect(decoded['event'], 'pusher:pong');
    });
  });
}
