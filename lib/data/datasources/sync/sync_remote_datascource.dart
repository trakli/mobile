// lib/data/repositories/sync_remote_repository.dart
import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/core/error/dio_error_handler.dart';

abstract class SyncRemoteRepository {
  Future<String?> getLatestServerChangeId();
  Future<List<ServerChange>> getServerPendingChanges(String? lastChangeId);
}

class SyncRemoteRepositoryImpl implements SyncRemoteRepository {
  final Dio _dio;

  SyncRemoteRepositoryImpl(this._dio);

  @override
  Future<String?> getLatestServerChangeId() async {
    try {
      final response = await _dio.get('transactions');
      return response.data['lastChangeId'];
    } on DioException catch (e) {
      throw handleDioError(e, 'Failed to update transaction');
    }
  }

  @override
  Future<List<ServerChange>> getServerPendingChanges(
      String? lastChangeId) async {
    try {
      final response = await _dio.get('transactions', queryParameters: {
        'lastChangeId': lastChangeId,
      });

      final changes = response.data['changes'] as List;
      return changes.map((change) {
        return ServerChange(
          id: change['id'],
          moment: DateTime.parse(change['moment']),
          entityType: change['entity_type'],
          changedId: change['changed_id'],
          deleted: change['deleted'] ?? false,
          entity: change['entity'],
        );
      }).toList();
    } on DioException catch (e) {
      throw handleDioError(e, 'Failed to update transaction');
    }
  }
}
