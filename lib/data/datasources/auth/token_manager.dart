import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenManager {
  /// Gets the current auth token (nullable)
  Future<String?> get token;

  /// Persists a new auth token
  Future<void> persistToken(String token);

  /// Persists a new refresh token
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

  SharedPreferences? _prefsInstance;

  TokenManagerImpl();

  Future<SharedPreferences> get _sharedPrefs async {
    _prefsInstance ??= await SharedPreferences.getInstance();
    return _prefsInstance!;
  }

  @override
  Future<String?> get token async {
    final prefs = await _sharedPrefs;
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> persistToken(String token) async {
    final prefs = await _sharedPrefs;
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await _sharedPrefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  @override
  Future<void> persistRefreshToken(String token) async {
    final prefs = await _sharedPrefs;
    await prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<bool> get hasToken async {
    final prefs = await _sharedPrefs;
    return prefs.containsKey(_tokenKey);
  }
}
