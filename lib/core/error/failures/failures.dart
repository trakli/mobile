import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/error/utils/field_error.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError(String message) = ServerFailure;
  const factory Failure.networkError() = NetworkFailure;
  const factory Failure.cacheError(String message) = CacheFailure;
  const factory Failure.syncError(String message) = SyncFailure;
  const factory Failure.validationError(String message,
      {required List<FieldError> errors}) = ValidationFailure;
  const factory Failure.unauthorizedError() = UnauthorizedFailure;
  const factory Failure.unknownError() = UnknownFailure;
  const factory Failure.badRequest({
    List<FieldError>? errors,
    String? error,
  }) = _BadRequest;
  const factory Failure.none() = NoneFailure;
  const factory Failure.notFound() = NotFoundFailure;

  const Failure._();

  bool get hasError => this != const Failure.none();

  // Getter for message
  String get customMessage =>
      whenOrNull(
        serverError: (message) => message,
        cacheError: (message) => message,
        syncError: (message) => message,
        validationError: (message, errors) {
          return errors.first.messages.join(', ');
        },
        // errors.map((e) => e.messages).join(', '),
        unauthorizedError: () => 'Unauthorized',
        unknownError: () => 'Unknown error',
        badRequest: (errors, error) => error ?? errors?.join(', '),
        none: () => '',
        notFound: () => 'Not found',
      ) ??
      '';
}
