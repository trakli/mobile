import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/utils/services/logger.dart';

class RepositoryErrorHandler {
  static Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      // if (!await _networkInfo.isConnected) {
      //   return const Left(NetworkFailure());
      // }

      final result = await apiCall();
      return right(result);
    } on UnauthorizedException {
      return left(const UnauthorizedFailure());
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message, errors: e.errors));
    } on BadRequestException catch (e) {
      return left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on NetworkException {
      return left(const NetworkFailure());
    } on UnknownException {
      return left(const UnknownFailure());
    } on DuplicateException catch (e) {
      return left(DuplicateFailure(e.message));
    } on NotFoundException {
      return left(const NotFoundFailure());
    } catch (e, stackTrace) {
      logger.e('UnknownFailure', error: e, stackTrace: stackTrace);
      return left(const UnknownFailure());
    }
  }
}
