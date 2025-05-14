enum SyncStatus {
  pending, // Record needs to be synced
  syncing, // Record is currently being synced
  synced, // Record has been successfully synced
  failed, // Sync failed, needs retry
  deleted // Record has been deleted locally
}
