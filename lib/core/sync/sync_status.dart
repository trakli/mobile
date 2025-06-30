import 'package:drift_sync_core/drift_sync_core.dart';

/// Type-safe sync status for tracking synchronization state
enum SyncStatus {
  pending, // Waiting for dependencies to be satisfied
  ready, // Dependencies satisfied, ready to sync
  syncing, // Currently being synchronized
  synced, // Successfully synchronized
  failed, // Synchronization failed
  skipped, // Skipped due to dependency issues
}

/// Type-safe sync state for a specific handler
class HandlerSyncState<T extends SyncTypeHandler> {
  final T handler;
  final SyncStatus status;
  final Set<Type> dependencies;
  final Set<Type> satisfiedDependencies;
  final String? errorMessage;
  final DateTime? lastSyncAttempt;
  final DateTime? lastSuccessfulSync;

  const HandlerSyncState({
    required this.handler,
    required this.status,
    required this.dependencies,
    required this.satisfiedDependencies,
    this.errorMessage,
    this.lastSyncAttempt,
    this.lastSuccessfulSync,
  });

  /// Check if all dependencies are satisfied
  bool get allDependenciesSatisfied =>
      dependencies.isEmpty ||
      dependencies.every((dep) => satisfiedDependencies.contains(dep));

  /// Check if the handler is ready to sync
  bool get isReadyToSync =>
      status == SyncStatus.ready && allDependenciesSatisfied;

  /// Create a copy with updated status
  HandlerSyncState<T> copyWith({
    SyncStatus? status,
    Set<Type>? satisfiedDependencies,
    String? errorMessage,
    DateTime? lastSyncAttempt,
    DateTime? lastSuccessfulSync,
  }) {
    return HandlerSyncState<T>(
      handler: handler,
      status: status ?? this.status,
      dependencies: dependencies,
      satisfiedDependencies:
          satisfiedDependencies ?? this.satisfiedDependencies,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
    );
  }

  @override
  String toString() {
    return 'HandlerSyncState(${handler.runtimeType}, status: $status, dependencies: ${dependencies.length}, satisfied: ${satisfiedDependencies.length})';
  }
}

/// Type-safe sync progress tracking
class SyncProgress {
  final Map<Type, HandlerSyncState> handlerStates;
  final int totalHandlers;
  final int completedHandlers;
  final int failedHandlers;
  final int pendingHandlers;
  final DateTime startTime;
  final DateTime? endTime;

  const SyncProgress({
    required this.handlerStates,
    required this.totalHandlers,
    required this.completedHandlers,
    required this.failedHandlers,
    required this.pendingHandlers,
    required this.startTime,
    this.endTime,
  });

  /// Get completion percentage
  double get completionPercentage =>
      totalHandlers > 0 ? (completedHandlers / totalHandlers) * 100 : 0.0;

  /// Check if sync is complete
  bool get isComplete => completedHandlers + failedHandlers >= totalHandlers;

  /// Get duration of sync
  Duration get duration =>
      endTime?.difference(startTime) ?? DateTime.now().difference(startTime);

  /// Get handlers that are ready to sync
  List<HandlerSyncState> get readyHandlers =>
      handlerStates.values.where((state) => state.isReadyToSync).toList();

  /// Get handlers that have failed
  List<HandlerSyncState> get failedHandlerStates => handlerStates.values
      .where((state) => state.status == SyncStatus.failed)
      .toList();

  /// Get handlers that are still pending
  List<HandlerSyncState> get pendingHandlerStates => handlerStates.values
      .where((state) => state.status == SyncStatus.pending)
      .toList();

  @override
  String toString() {
    return 'SyncProgress(completed: $completedHandlers/$totalHandlers, failed: $failedHandlers, pending: $pendingHandlers)';
  }
}
