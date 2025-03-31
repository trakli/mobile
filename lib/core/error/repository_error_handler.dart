import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';

class RepositoryErrorHandler {
  static Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() apiCall, {
    bool forceSync = false,
  }) async {
    try {
      // if (!await _networkInfo.isConnected) {
      //   return const Left(NetworkFailure());
      // }

      final result = await apiCall();
      return right(result);
    } on UnauthorizedException {
      return left(const UnauthorizedFailure());
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message));
    } on BadRequestException catch (e) {
      return left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on NetworkException {
      if (forceSync) {
        // If forceSync is true, try to execute the operation anyway
        try {
          final result = await apiCall();
          return right(result);
        } catch (e) {
          return left(UnknownFailure(e.toString()));
        }
      }
      return left(const NetworkFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
