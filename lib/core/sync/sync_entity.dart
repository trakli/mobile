/// The entity kinds the sync layer names.
///
/// The wire and storage boundaries speak plain strings — `drift_sync_core`
/// types `SyncTypeHandler.entityType` as `String`, and `local_changes.entityType`
/// is a text column holding values already written to users' databases — so
/// [key] is what crosses them, and it must keep matching the `entity` constant
/// on each handler. `sync_entity_test` asserts that it does.
enum SyncEntity {
  wallet('wallet'),
  category('category'),
  group('group'),
  party('party'),
  transaction('transaction'),
  transfer('transfer'),
  budget('budget'),
  budgetPeriodState('budget_period_state'),
  reminder('reminder'),
  notification('notification'),
  config('config'),
  media('media'),

  /// Read-through cache rather than a synced type: it has no handler, and
  /// appears here only so its paged reads can name themselves.
  holding('holding');

  const SyncEntity(this.key);

  final String key;
}
