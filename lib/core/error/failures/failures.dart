import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/error/utils/field_error.dart';
import 'package:trakli/generated/locale_keys.g.dart';

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
  String get customMessage => map(
        serverError: (ServerFailure failure) => failure.message,
        cacheError: (CacheFailure failure) => failure.message,
        syncError: (SyncFailure failure) => failure.message,
        validationError: (ValidationFailure failure) {
          if (failure.errors.isEmpty) return failure.message;
          final errorMessage = failure.errors.first.messages.join(', ');
          return errorMessage.isNotEmpty ? errorMessage : failure.message;
        },
        unauthorizedError: (UnauthorizedFailure _) =>
            LocaleKeys.invalidUserCredentials.tr(),
        unknownError: (UnknownFailure _) =>
            'An unexpected error occurred. Please try again.',
        badRequest: (_BadRequest failure) {
          if (failure.error != null) return failure.error!;
          if (failure.errors != null && failure.errors!.isNotEmpty) {
            return failure.errors!.map((e) => e.messages.join(', ')).join('; ');
          }
          return 'Invalid request. Please check your input and try again.';
        },
        none: (NoneFailure _) => 'No error',
        notFound: (NotFoundFailure _) =>
            'The requested resource was not found.',
        networkError: (NetworkFailure _) =>
            'Please check your internet connection and try again.',
      );
}
