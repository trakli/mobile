import 'package:dio/dio.dart';
import '../../../data/datasources/auth/token_manager.dart';

class TokenInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  TokenInterceptor(this._tokenManager);

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
      // Token expired or invalid
      // await _tokenManager.deleteToken();
      // You might want to trigger a logout or token refresh here
    }

    return handler.next(err);
  }
}
