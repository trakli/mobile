//Defines the SyncState class, which represents the current state of the synchronization process.
class SyncState {
  final bool isSynchronizing;
  final bool cancelRequested;

  const SyncState({
    required this.isSynchronizing,
    required this.cancelRequested,
  });

  const SyncState.initial()
      : isSynchronizing = false,
        cancelRequested = false;

  SyncState copyWith({
    bool? isSynchronizing,
    bool? cancelRequested,
  }) {
    return SyncState(
      isSynchronizing: isSynchronizing ?? this.isSynchronizing,
      cancelRequested: cancelRequested ?? this.cancelRequested,
    );
  }

  SyncState start() {
    return copyWith(isSynchronizing: true, cancelRequested: false);
  }

  SyncState stop() {
    return copyWith(isSynchronizing: false, cancelRequested: false);
  }

  SyncState cancel() {
    return copyWith(cancelRequested: true);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncState &&
          runtimeType == other.runtimeType &&
          isSynchronizing == other.isSynchronizing &&
          cancelRequested == other.cancelRequested;

  @override
  int get hashCode => isSynchronizing.hashCode ^ cancelRequested.hashCode;

  @override
  String toString() =>
      'SyncState(isSynchronizing: $isSynchronizing, cancelRequested: $cancelRequested)';
}
