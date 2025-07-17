import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/sync/sync_dependency_manager.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';

@module
abstract class SyncModule {
  @lazySingleton
  Set<SyncTypeHandler<dynamic, dynamic, dynamic>> provideSyncTypeHandlers(
    CategorySyncHandler categoryTypeHandler,
    WalletSyncHandler walletTypeHandler,
    PartySyncHandler partyTypeHandler,
    GroupSyncHandler groupTypeHandler,
    TransactionSyncHandler transactionTypeHandler,
  ) {
    return {
      categoryTypeHandler,
      walletTypeHandler,
      partyTypeHandler,
      groupTypeHandler,
      transactionTypeHandler,
    };
  }

  @lazySingleton
  SyncDependencyManagerBase provideSyncDependencyManager() =>
      SyncDependencyManager();
}
