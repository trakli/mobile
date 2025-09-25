import 'package:dio/dio.dart';
import '../../../data/datasources/auth/token_manager.dart';
import '../../../core/services/auth_service.dart';

class TokenInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final AuthService _authService; // Used in onError method

  TokenInterceptor(this._tokenManager, this._authService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenManager.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Check if this is a login attempt or an authenticated request
      final hasAuthHeader =
          err.requestOptions.headers.containsKey('Authorization');
      final requestPath = err.requestOptions.path.toLowerCase();

      // Specific login/register endpoints that should not trigger logout
      final isAuthEndpoint = requestPath == '/login' ||
          requestPath == '/auth/login' ||
          requestPath == '/register' ||
          requestPath.contains('/password-reset') ||
          requestPath.contains('/otp') ||
          requestPath.contains('/verify');

      // Only handle unauthorized for authenticated requests (with auth header), not auth endpoints
      if (hasAuthHeader && !isAuthEndpoint) {
        // Token expired or invalid - handle unauthorized access
        await _authService.handleUnauthorized();
      }
    }

    return handler.next(err);
  }
}
