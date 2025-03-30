import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/sync/transaction_type_handler.dart';

@module
abstract class SyncModule {
  @lazySingleton
  Set<SyncTypeHandler<dynamic, dynamic>> provideSyncTypeHandlers(
    TransactionTypeHandler transactionTypeHandler,
  ) {
    return {transactionTypeHandler};
  }
}
