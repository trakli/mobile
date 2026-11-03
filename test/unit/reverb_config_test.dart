import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/module/realtime_module.dart';

void main() {
  const apiUrl = 'https://api.trakli.app/api/v1/';

  ReverbConfig build({
    String appKey = 'key',
    String host = '',
    String port = '',
    String scheme = '',
  }) =>
      ReverbConfig.fromDefines(
        appKey: appKey,
        host: host,
        port: port,
        scheme: scheme,
        apiUrl: apiUrl,
      );

  group('ReverbConfig.fromDefines', () {
    test('a bare host connects over TLS on 443', () {
      final config = build(host: 'reverb.trakli.app');

      expect(
        config.socketUri.toString(),
        startsWith('wss://reverb.trakli.app:443/app/key?'),
      );
      expect(config.authUrl, 'https://api.trakli.app/broadcasting/auth');
      expect(config.enabled, isTrue);
    });

    for (final pasted in [
      'wss://reverb.trakli.app',
      'wss://reverb.trakli.app/',
      'wss://reverb.trakli.app:443',
      'https://reverb.trakli.app',
      ' wss://reverb.trakli.app ',
    ]) {
      test('a pasted URL "$pasted" resolves to the bare host', () {
        final config = build(host: pasted);

        expect(config.host, 'reverb.trakli.app');
        expect(config.port, 443);
        expect(config.useTls, isTrue);
      });
    }

    test('host:port without a scheme keeps the port', () {
      final config = build(host: 'reverb.trakli.app:6001');

      expect(config.host, 'reverb.trakli.app');
      expect(config.port, 6001);
      expect(config.useTls, isTrue);
    });

    test('a scheme and port in the host win over the separate values', () {
      final config =
          build(host: 'ws://localhost:8080', port: '443', scheme: 'https');

      expect(config.host, 'localhost');
      expect(config.port, 8080);
      expect(config.useTls, isFalse);
    });

    test('REVERB_PORT and REVERB_SCHEME apply when the host has neither', () {
      final config =
          build(host: 'reverb.trakli.app', port: '8443', scheme: 'https');

      expect(config.port, 8443);
      expect(config.useTls, isTrue);
    });

    test('a plain scheme without a port defaults to 80', () {
      expect(build(host: 'localhost', scheme: 'http').port, 80);
      expect(build(host: 'ws://localhost').port, 80);
      expect(build(host: 'ws://localhost').useTls, isFalse);
    });

    test('a non-numeric port falls back to the default', () {
      expect(build(host: 'reverb.trakli.app', port: 'abc').port, 443);
    });

    test('an empty host falls back to the API host', () {
      expect(build().host, 'api.trakli.app');
    });

    test('no app key disables the socket', () {
      expect(build(appKey: '', host: 'reverb.trakli.app').enabled, isFalse);
    });
  });
}
