import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/sync/sync_entity.dart';
import 'package:trakli/data/sync/budget_period_state_sync_handler.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/config_sync_handler.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/data/sync/media_sync_handler.dart';
import 'package:trakli/data/sync/notification_sync_handler.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/data/sync/reminder_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';

/// The handlers must keep their `entity` as a `const String`, because
/// `sync_database`'s `reconciledEntities` is a const map keyed by them. So the
/// spelling lives in two places, and these tests are what stops them drifting:
/// `local_changes.entityType` already holds these strings in users' databases,
/// and a key that stopped matching its handler would orphan every queued
/// change of that type.
void main() {
  test('every key matches the handler that owns it', () {
    expect(SyncEntity.wallet.key, WalletSyncHandler.entity);
    expect(SyncEntity.category.key, CategorySyncHandler.entity);
    expect(SyncEntity.group.key, GroupSyncHandler.entity);
    expect(SyncEntity.party.key, PartySyncHandler.entity);
    expect(SyncEntity.transaction.key, TransactionSyncHandler.entity);
    expect(SyncEntity.transfer.key, TransferSyncHandler.entity);
    expect(SyncEntity.budget.key, BudgetSyncHandler.entity);
    expect(
      SyncEntity.budgetPeriodState.key,
      BudgetPeriodStateSyncHandler.entity,
    );
    expect(SyncEntity.reminder.key, ReminderSyncHandler.entity);
    expect(SyncEntity.notification.key, NotificationSyncHandler.entity);
    expect(SyncEntity.config.key, ConfigSyncHandler.entity);
    expect(SyncEntity.media.key, MediaSyncHandler.entity);
  });

  test('every handler has an entry', () {
    // holding is the one value without a handler: it is a read-through cache.
    expect(SyncEntity.values, hasLength(13));
  });

  test('keys are unique', () {
    final keys = SyncEntity.values.map((e) => e.key).toList();
    expect(keys.toSet(), hasLength(keys.length));
  });
}
