import 'package:dio/dio.dart';

Exception handleDioError(DioException e, String fallbackMessage) {
  if (e.response != null) {
    return Exception(
        '${e.response?.statusCode}: ${e.response?.data ?? fallbackMessage}');
  }
  return Exception(fallbackMessage);
}
