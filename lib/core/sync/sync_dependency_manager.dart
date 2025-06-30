import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';

/// Provides the dependency map for sync handlers
// @Injectable(as: SyncDependencyManagerBase)
class SyncDependencyManager extends DefaultSyncDependencyManager {
  @override
  Map<String, Set<String>> get dependencies => {
        TransactionSyncHandler.entity: {
          CategorySyncHandler.entity,
          WalletSyncHandler.entity,
          PartySyncHandler.entity,
          GroupSyncHandler.entity,
        },
        CategorySyncHandler.entity: {},
        WalletSyncHandler.entity: {},
        PartySyncHandler.entity: {},
        GroupSyncHandler.entity: {},
      };
}
