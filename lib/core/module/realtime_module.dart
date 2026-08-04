import 'package:injectable/injectable.dart';

/// Connection settings for the Reverb websocket that pushes AI chat turn
/// events. Values come from --dart-define (REVERB_APP_KEY, REVERB_HOST,
/// REVERB_PORT, REVERB_SCHEME); without a key the socket is disabled and
/// chat runs on polling alone.
class ReverbConfig {
  const ReverbConfig({
    required this.appKey,
    required this.host,
    required this.port,
    required this.useTls,
    required this.authUrl,
  });

  final String appKey;
  final String host;
  final int port;
  final bool useTls;

  /// Laravel broadcasting auth endpoint (API origin + /broadcasting/auth).
  final String authUrl;

  bool get enabled => appKey.isNotEmpty && host.isNotEmpty;

  Uri get socketUri => Uri(
        scheme: useTls ? 'wss' : 'ws',
        host: host,
        port: port,
        path: '/app/$appKey',
        queryParameters: const {
          'protocol': '7',
          'client': 'trakli-flutter',
          'version': '1.0',
        },
      );
}

@module
abstract class RealtimeModule {
  @lazySingleton
  ReverbConfig reverbConfig(@Named('HttpUrl') String apiUrl) {
    const appKey = String.fromEnvironment('REVERB_APP_KEY');
    const host = String.fromEnvironment('REVERB_HOST');
    const port = int.fromEnvironment('REVERB_PORT', defaultValue: 443);
    const scheme =
        String.fromEnvironment('REVERB_SCHEME', defaultValue: 'https');

    final api = Uri.parse(apiUrl);
    return ReverbConfig(
      appKey: appKey,
      host: host.isNotEmpty ? host : api.host,
      port: port,
      useTls: scheme == 'https',
      authUrl: api.replace(path: '/broadcasting/auth').toString(),
    );
  }
}
