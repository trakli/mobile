import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if the error has a response
    if (err.response != null) {
      // Print the response data
      // print('Error response data: ${err.response?.data}');
    }
    // Continue with the error
    handler.next(err);
  }
}
