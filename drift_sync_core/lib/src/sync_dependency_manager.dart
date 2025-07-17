import 'package:drift_sync_core/src/sync_type_handler.dart';

/// Abstract base class for type-safe dependency tracking for SyncTypeHandler entities
abstract class SyncDependencyManagerBase {
  /// Get dependencies for a specific handler type
  Set<String> getDependencies<T extends SyncTypeHandler>(T handler);

  /// Check if a handler type can be synced (all dependencies met)
  bool canSync<T extends SyncTypeHandler>(T handler);

  /// Mark a handler type as successfully synced
  void markSuccessfullySynced<T extends SyncTypeHandler>(T handler);

  /// Check if a handler type has been successfully synced
  bool isSuccessfullySynced<T extends SyncTypeHandler>(T handler);

  /// Reset sync state (for full resync)
  void resetSyncState();

  /// Get all dependency configurations
  Map<String, Set<String>> get dependencies;
}

/// Default implementation of SyncDependencyManagerBase with no dependencies
class DefaultSyncDependencyManager extends SyncDependencyManagerBase {
  final Set<String> _successfullySynced = {};

  @override
  Map<String, Set<String>> get dependencies => const {};

  @override
  Set<String> getDependencies<T extends SyncTypeHandler>(T handler) {
    return dependencies[handler.entityType] ?? {};
  }

  @override
  bool canSync<T extends SyncTypeHandler>(T handler) {
    final deps = dependencies[handler.entityType];
    if (deps == null || deps.isEmpty) {
      return true;
    }
    for (final dependency in deps) {
      if (!_successfullySynced.contains(dependency)) {
        return false;
      }
    }
    return true;
  }

  @override
  void markSuccessfullySynced<T extends SyncTypeHandler>(T handler) {
    _successfullySynced.add(handler.entityType);
  }

  @override
  bool isSuccessfullySynced<T extends SyncTypeHandler>(T handler) {
    return _successfullySynced.contains(handler.entityType);
  }

  @override
  void resetSyncState() {
    _successfullySynced.clear();
  }
}
 