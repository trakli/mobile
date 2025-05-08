import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class TokenManager {
  /// Gets the current auth token (nullable)
  Future<String?> get token;

  /// Persists a new auth token
  Future<void> persistToken(String token);

  /// Persists a new auth token
  Future<void> persistRefreshToken(String token);

  /// Clears the stored token
  Future<void> clearToken();

  /// Checks if a token exists
  Future<bool> get hasToken;
}

@Injectable(as: TokenManager)
class TokenManagerImpl implements TokenManager {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  static const _storage = FlutterSecureStorage();

  // final SharedPrefs prefs;

  const TokenManagerImpl();

  // @override

  @override
  Future<String?> get token => _storage.read(key: 'access_token');

  // static Future<String?> getAccessToken() async {
  //   return await _storage.read(key: 'access_token');
  // }

  @override
  Future<void> persistToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _refreshTokenKey, value: token);
    // await prefs.putString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    // await prefs.clearKey(_tokenKey);
    // await prefs.clearKey(_refreshTokenKey);
  }

  @override
  Future<void> persistRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
    // await prefs.putString(_refreshTokenKey, token);
  }

  @override
  Future<bool> get hasToken => _storage.containsKey(key: _tokenKey);
}
