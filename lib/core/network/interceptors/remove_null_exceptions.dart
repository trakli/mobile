import 'package:dio/dio.dart';

class RemoveNullValuesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Remove null values from the request data
    // ignore: inference_failure_on_untyped_parameter, avoid_dynamic_calls
    options.data?.removeWhere((key, value) => value == null);
    super.onRequest(options, handler);
  }
}
