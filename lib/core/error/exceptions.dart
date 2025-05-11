import 'package:trakli/core/error/utils/field_error.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 403);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 404);
}

class ServerException extends ApiException {
  ServerException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 500);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ValidationException extends ApiException {
  final List<FieldError> errors;

  ValidationException(super.message, {required this.errors})
      : super(statusCode: 422);
}
