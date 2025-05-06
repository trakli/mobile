import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

mixin RestSyncTypeHandler<TEntity, TKey, TServerKey>
    on SyncTypeHandler<TEntity, TKey, TServerKey> {
  Future<List<TEntity>> restGetAllRemote();
  Future<TEntity?> restGetRemote(TServerKey id);
  Future<TEntity> restPutRemote(TEntity entity);
  Future<void> restDeleteRemote(TEntity entity);

  @override
  Future<TEntity?> getRemote(TServerKey id) async {
    try {
      final e = await restGetRemote(id);
      return e;
    } on DioException catch (ex) {
      if (isUnavailable(ex)) {
        throw UnavailableException(innerException: ex);
      }
      if (isNotFound(ex)) {
        throw NotFoundException(innerException: ex);
      }
      rethrow;
    }
  }

  @override
  Future<List<TEntity>> getAllRemote() async {
    try {
      final entities = await restGetAllRemote();
      return entities;
    } on DioException catch (exception) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      rethrow;
    }
  }

  @override
  Future<TEntity> putRemote(TEntity entity) async {
    try {
      final updated = await restPutRemote(entity);
      return updated;
    } on DioException catch (exception) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      if (exception.response?.statusCode == 409 || // Conflict
          exception.response?.statusCode == 404) {
        // Not Found
        throw ConflictException(innerException: exception);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteRemote(TEntity entity) async {
    try {
      await restDeleteRemote(entity);
    } on DioException catch (exception) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      if (exception.response?.statusCode == 409 || // Conflict
          exception.response?.statusCode == 404) {
        // Not Found
        throw ConflictException(innerException: exception);
      }
      rethrow;
    }
  }

  @protected
  bool isUnavailable(DioException exception) {
    return exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        (exception.response?.statusCode ?? 0) >= 500;
  }

  @protected
  bool isNotFound(DioException exception) {
    return exception.response?.statusCode == 404;
  }
}
