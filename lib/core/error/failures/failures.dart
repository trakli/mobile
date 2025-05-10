import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError(String message) = ServerFailure;
  const factory Failure.networkError() = NetworkFailure;
  const factory Failure.cacheError(String message) = CacheFailure;
  const factory Failure.syncError(String message) = SyncFailure;
  const factory Failure.validationError(String message) = ValidationFailure;
  const factory Failure.unauthorizedError() = UnauthorizedFailure;
  const factory Failure.unknownError() = UnknownFailure;
  const factory Failure.badRequest({
    List<String>? errors,
    String? error,
  }) = _BadRequest;
  const factory Failure.none() = NoneFailure;
  const factory Failure.notFound() = NotFoundFailure;

  const Failure._();

  bool get hasError => this != const Failure.none();

  // Getter for message
  String get message =>
      whenOrNull(
        serverError: (message) => message,
        cacheError: (message) => message,
        syncError: (message) => message,
      ) ??
      '';
}
