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
  const factory Failure.unknownError(String message) = UnknownFailure;
}

// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
//   const Failure(this.message);

//   final String message;

//   @override
//   List<Object?> get props => [message];
// }

// // General failures
// class ServerFailure extends Failure {
//   const ServerFailure(super.message);

//   @override
//   List<Object?> get props => [message];
// }
