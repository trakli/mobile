import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:drift/drift.dart';

mixin SynchronizerDb on GeneratedDatabase {
  Future<List<PendingLocalChange>> getPendingLocalChanges();
  Future<void> cancelAllLocalChanges();
  Future<void> concludeLocalChange(
    PendingLocalChange localChange, {
    Object? error,
    bool persistedToRemote = false,
  });
  Future<List<LocalSyncMetadata>> getLocalSyncMetadataList();
  Future<LocalSyncMetadata?> getLocalSyncMetadata(String id);
  // Future<LocalSyncMetadata?> updateLocalSyncMetadata(String id, DateTime time);
  Future<void> insertLocalChange(PendingLocalChange localChange);

  Future<void> concludeEntityLocalChanges(
    String entityType,
    int? entityId,
    Operation operation,
  );

  Future<void> updateEnityLocalSyncMetadata({
    required String entityType,
    DateTime? lastSyncedAt,
  });
}
