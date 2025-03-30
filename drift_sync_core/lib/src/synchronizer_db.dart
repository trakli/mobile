import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:drift/drift.dart';

mixin SynchronizerDb on GeneratedDatabase {
  Future<List<PendingLocalChange>> getPendingLocalChanges();
  Future<void> cancelAllLocalChanges();
  Future<void> concludeLocalChange(
    PendingLocalChange localChange, {
    Object? error,
  });
  Future<String?> getLastChangeId();
  Future<void> setLastReceivedChangeId(String? id);
  Future<void> insertLocalChange(PendingLocalChange localChange);
  Future<void> concludeEntityLocalChanges(String entityType, String entityId);
}
