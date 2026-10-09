import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:trakli/core/module/realtime_module.dart';
import 'package:trakli/core/realtime/pusher_protocol.dart';
import 'package:trakli/core/realtime/reverb_socket_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _MockDio extends Mock implements Dio {}

/// A controllable fake channel: [emit] pushes a frame as if received from
/// the server, [sent] records every frame the client wrote to the sink.
class _FakeChannel with StreamChannelMixin implements WebSocketChannel {
  final _incoming = StreamController<dynamic>.broadcast();
  final List<String> sent = [];
  bool closed = false;

  void emit(String raw) => _incoming.add(raw);
  void emitFrame(String event, Object data, {String? channel}) => emit(
        jsonEncode({
          'event': event,
          if (channel != null) 'channel': channel,
          'data': jsonEncode(data),
        }),
      );

  @override
  Stream get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _FakeSink(this);

  @override
  Future<void> get ready => Future.value();

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;
}

class _FakeSink implements WebSocketSink {
  _FakeSink(this._owner);
  final _FakeChannel _owner;

  @override
  void add(dynamic data) => _owner.sent.add(data as String);

  @override
  Future close([int? closeCode, String? closeReason]) async {
    _owner.closed = true;
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream stream) async {}

  @override
  Future get done => Future.value();
}

Map<String, dynamic> _decode(String raw) =>
    jsonDecode(raw) as Map<String, dynamic>;

void main() {
  late _FakeChannel channel;
  late ReverbSocketClient client;
  late _MockDio dio;

  const config = ReverbConfig(
    appKey: 'app-key',
    host: 'reverb.test',
    port: 443,
    useTls: true,
    authUrl: 'https://api.test/broadcasting/auth',
  );

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  Response<Map<String, dynamic>> authResponse(Map<String, dynamic> data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: config.authUrl),
        data: data,
        statusCode: 200,
      );

  void stubAuth(Map<String, dynamic> response) {
    when(() => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        )).thenAnswer((_) async => authResponse(response));
  }

  setUp(() {
    channel = _FakeChannel();
    dio = _MockDio();
    client = ReverbSocketClient(config, dio)..connectOverride = (_) => channel;
  });

  tearDown(() => client.dispose());

  test('enabled reflects ReverbConfig.enabled', () {
    expect(client.enabled, isTrue);
    final disabled = ReverbSocketClient(
      const ReverbConfig(
        appKey: '',
        host: '',
        port: 443,
        useTls: true,
        authUrl: '',
      ),
      dio,
    );
    expect(disabled.enabled, isFalse);
  });

  test('subscribeToSession is a no-op when disabled', () async {
    final disabled = ReverbSocketClient(
      const ReverbConfig(
          appKey: '', host: '', port: 443, useTls: true, authUrl: ''),
      dio,
    )..connectOverride = (_) => channel;
    await disabled.subscribeToSession(1);
    expect(channel.sent, isEmpty);
    disabled.dispose();
  });

  test('connects, authorizes, and subscribes once connection is established',
      () async {
    stubAuth({'auth': 'app-key:signature'});

    final future = client.subscribeToSession(7);
    channel.emitFrame(
        'pusher:connection_established', {'socket_id': '111.222'});
    await future;
    await Future<void>.delayed(Duration.zero); // let the auth POST settle

    final captured = verify(() => dio.post<Map<String, dynamic>>(
          captureAny(),
          data: captureAny(named: 'data'),
        )).captured;
    expect(captured[0], config.authUrl);
    expect(captured[1], {
      'socket_id': '111.222',
      'channel_name': 'private-chat-session.7',
    });

    final subscribeMsg = channel.sent
        .map(_decode)
        .firstWhere((m) => m['event'] == 'pusher:subscribe');
    expect(subscribeMsg['data']['channel'], 'private-chat-session.7');
    expect(subscribeMsg['data']['auth'], 'app-key:signature');
  });

  test('turn events are surfaced on turnEvents', () async {
    stubAuth({'auth': 'k:sig'});
    final events = <ChatTurnFrame>[];
    client.turnEvents.listen(events.add);

    final future = client.subscribeToSession(3);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);

    channel.emitFrame(
        'turn', {'message_id': 42, 'kind': 'progress', 'label': 'Thinking…'});
    channel.emitFrame('turn', {'message_id': 42, 'kind': 'settled'});
    await Future<void>.delayed(Duration.zero);

    expect(events, hasLength(2));
    expect(events[0].isProgress, isTrue);
    expect(events[0].label, 'Thinking…');
    expect(events[1].isSettled, isTrue);
  });

  test('responds to a ping with a pong', () async {
    stubAuth({'auth': 'k:sig'});
    final future = client.subscribeToSession(1);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);
    channel.sent.clear();

    channel.emitFrame('pusher:ping', {});
    await Future<void>.delayed(Duration.zero);

    expect(channel.sent, hasLength(1));
    expect(_decode(channel.sent.single)['event'], 'pusher:pong');
  });

  test('switching sessions unsubscribes the old channel before subscribing '
      'the new one', () async {
    stubAuth({'auth': 'k:sig'});
    final future = client.subscribeToSession(1);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);
    channel.sent.clear();

    await client.subscribeToSession(2);
    await Future<void>.delayed(Duration.zero);

    final events = channel.sent.map(_decode).toList();
    expect(events[0]['event'], 'pusher:unsubscribe');
    expect(events[0]['data']['channel'], 'private-chat-session.1');
    expect(events.last['event'], 'pusher:subscribe');
    expect(events.last['data']['channel'], 'private-chat-session.2');
  });

  test('unsubscribe sends pusher:unsubscribe without closing the socket',
      () async {
    stubAuth({'auth': 'k:sig'});
    final future = client.subscribeToSession(5);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);
    channel.sent.clear();

    client.unsubscribe();

    expect(channel.closed, isFalse);
    final msg = _decode(channel.sent.single);
    expect(msg['event'], 'pusher:unsubscribe');
    expect(msg['data']['channel'], 'private-chat-session.5');
  });

  test('a missing "auth" field in the response is handled without throwing',
      () async {
    stubAuth({});
    final future = client.subscribeToSession(9);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);

    final events = channel.sent.map(_decode).toList();
    expect(events.where((m) => m['event'] == 'pusher:subscribe'), isEmpty);
  });

  test('an auth request failure is handled without throwing', () async {
    when(() => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

    final future = client.subscribeToSession(1);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await expectLater(future, completes);
    await Future<void>.delayed(Duration.zero);

    final events = channel.sent.map(_decode).toList();
    expect(events.where((m) => m['event'] == 'pusher:subscribe'), isEmpty);
  });

  test('dispose closes the channel and the turnEvents stream', () async {
    stubAuth({'auth': 'k:sig'});
    final future = client.subscribeToSession(1);
    channel.emitFrame('pusher:connection_established', {'socket_id': 's1'});
    await future;
    await Future<void>.delayed(Duration.zero);

    client.dispose();
    await Future<void>.delayed(Duration.zero);

    expect(channel.closed, isTrue);
    await expectLater(client.turnEvents, emitsDone);
  });
}
