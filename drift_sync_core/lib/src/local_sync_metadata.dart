class LocalSyncMetadata {
  final String entityType;
  final DateTime? lastSyncedAt;

  LocalSyncMetadata({
    required this.entityType,
    this.lastSyncedAt,
  });
}
