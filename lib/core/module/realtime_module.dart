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

  /// Builds the config from the raw --dart-define strings.
  ///
  /// [host] may be a bare host (`reverb.trakli.app`), a host and port
  /// (`reverb.trakli.app:443`) or a full URL (`wss://reverb.trakli.app`), so
  /// a value pasted straight from the server settings still works. A scheme
  /// or port written into [host] wins over [scheme] and [port]. Without a
  /// port anywhere, TLS connections use 443 and plain ones 80. TLS is on
  /// unless the scheme is `http` or `ws`. An empty [host] falls back to the
  /// API host.
  factory ReverbConfig.fromDefines({
    required String appKey,
    required String host,
    required String port,
    required String scheme,
    required String apiUrl,
  }) {
    final api = Uri.parse(apiUrl);
    final rawHost = host.trim();
    // '//' makes Uri read a scheme-less value as an authority (host[:port]).
    final hostUri =
        Uri.tryParse(rawHost.contains('://') ? rawHost : '//$rawHost');

    final hostScheme = hostUri?.scheme ?? '';
    final resolvedScheme = hostScheme.isNotEmpty ? hostScheme : scheme.trim();
    final useTls = !const {'http', 'ws'}.contains(resolvedScheme.toLowerCase());

    final resolvedHost = hostUri?.host ?? '';
    final resolvedPort = hostUri != null && hostUri.hasPort
        ? hostUri.port
        : int.tryParse(port.trim()) ?? (useTls ? 443 : 80);

    return ReverbConfig(
      appKey: appKey.trim(),
      host: resolvedHost.isNotEmpty ? resolvedHost : api.host,
      port: resolvedPort,
      useTls: useTls,
      authUrl: api.replace(path: '/broadcasting/auth').toString(),
    );
  }

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
  ReverbConfig reverbConfig(@Named('HttpUrl') String apiUrl) =>
      ReverbConfig.fromDefines(
        appKey: const String.fromEnvironment('REVERB_APP_KEY'),
        host: const String.fromEnvironment('REVERB_HOST'),
        port: const String.fromEnvironment('REVERB_PORT'),
        scheme: const String.fromEnvironment('REVERB_SCHEME'),
        apiUrl: apiUrl,
      );
}
