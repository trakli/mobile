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
      throw _handleDioException(err);
    } catch (error, stacktrace) {
      throw _handleUnknownException(error, stacktrace);
    }
  }

  static ApiException _handleDioException(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      return NetworkException('No internet connection');
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

  static List<String> _extractValidationErrors(dynamic data) {
    if (data == null) return [];

    final errors = FieldError.getErrors(data);

    if (errors.isNotEmpty) {
      return errors.map((e) => e.messages).expand((x) => x).toList();
    }

    return [];
  }

  static ApiException _handleUnknownException(
    Object error,
    StackTrace stacktrace,
  ) {
    logger.e('Unknown error: $error');
    logger.e('Stack trace: $stacktrace');
    return ServerException(error.toString());
  }
}
