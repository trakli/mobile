import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

mixin RestSyncTypeHandler<TEntity, TKey, TServerKey>
    on SyncTypeHandler<TEntity, TKey, TServerKey> {
  Future<List<TEntity>> restGetAllRemote(
      {DateTime? syncedSince, bool? noClientId});
  Future<TEntity?> restGetRemote(TServerKey id);
  Future<TEntity> restPutRemote(TEntity entity);
  Future<void> restDeleteRemote(TEntity entity);

  @override
  Future<TEntity?> getRemote(TServerKey serverId) async {
    try {
      final e = await restGetRemote(serverId);
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
  Future<List<TEntity>> getAllRemote(
      {DateTime? syncedSince, bool? noClientId}) async {
    try {
      final entities = await restGetAllRemote(
        syncedSince: syncedSince,
        noClientId: noClientId,
      );
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
