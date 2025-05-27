import 'package:dio/dio.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/utils/field_error.dart';
import 'package:trakli/core/utils/services/logger.dart';

class ErrorHandler {
  static Future<T> handleApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (err) {
      throw handleDioException(err);
    } catch (error, stacktrace) {
      throw handleUnknownException(error, stacktrace);
    }
  }

  static ApiException handleDioException(DioException err) {
    if (err.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    }

    if (err.type == DioExceptionType.unknown) {
      return UnknownException('Unknown error');
    }
    final statusCode = err.response?.statusCode;
    final message = err.response?.data['message'] as String? ?? 'Unknown error';
    final data = err.response?.data;

    switch (statusCode) {
      case 400:
        return BadRequestException(message, statusCode: statusCode, data: data);
      case 401:
        return UnauthorizedException(message,
            statusCode: statusCode, data: data);
      case 403:
        return ForbiddenException(message, statusCode: statusCode, data: data);
      case 404:
        return NotFoundException(message, statusCode: statusCode, data: data);
      case 422:
        final errors = _extractValidationErrors(data);
        return ValidationException(message, errors: errors);
      case 500:
        logger.e('Server error: ${err.response}');
        logger.e('Stack trace: ${err.stackTrace}');
        return ServerException('Internal server error',
            statusCode: statusCode, data: data);
      default:
        if (err.type == DioExceptionType.badResponse) {
          return BadRequestException(message,
              statusCode: statusCode, data: data);
        }
        return ServerException(message, statusCode: statusCode, data: data);
    }
  }

  static List<FieldError> _extractValidationErrors(dynamic data) {
    if (data == null) return [];

    return FieldError.getErrors(data);

    // if (errors.isNotEmpty) {
    //   return errors.map((e) => e.messages).expand((x) => x).toList();
    // }
  }

  static ApiException handleUnknownException(
    Object error,
    StackTrace stacktrace,
  ) {
    logger.e('Unknown error: $error');
    logger.e('Stack trace: $stacktrace');
    return ServerException(error.toString());
  }
}
