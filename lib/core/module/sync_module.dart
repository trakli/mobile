import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';

@module
abstract class SyncModule {
  @lazySingleton
  Set<SyncTypeHandler<dynamic, dynamic, dynamic>> provideSyncTypeHandlers(
    TransactionSyncHandler transactionTypeHandler,
    CategorySyncHandler categoryTypeHandler,
  ) {
    return {
      categoryTypeHandler,
      transactionTypeHandler,
    };
  }
}


