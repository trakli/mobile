import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/transactions.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TransactionSyncHandler extends SyncTypeHandler<Transaction, String, int>
    with RestSyncTypeHandler<Transaction, String, int> {
  TransactionSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final TransactionRemoteDataSource remoteDataSource;

  TableInfo<Transactions, Transaction> get table => db.transactions;

  @override
  String get entityType => 'transaction';

  // @override
  // String getId(Transaction entity) => entity.clientId;

  @override
  String getRev(Transaction entity) => entity.rev ?? '1';

  // @override
  // Future<Transaction> getLocal(String id) async {
  //   final row = await (db.select(table)..where((t) => t.clientId.equals(id)))
  //       .getSingle();
  //   return Transaction(
  //       id: row.id,
  //       amount: row.amount,
  //       description: row.description,
  //       rev: row.rev,
  //       clientId: row.clientId,
  //       type: row.type,
  //       datetime: row.datetime,
  //       createdAt: row.createdAt);
  // }

  @override
  Transaction unmarshal(Map<String, dynamic> entityJson) {
    return Transaction.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Transaction entity) {
    return entity.toJson();
  }

  @override
  Future<List<Transaction>> restGetAllRemote() async {
    return remoteDataSource.getAllTransactions();
  }

  @override
  Future<Transaction> restPutRemote(Transaction entity) async {
    if (entity.id == null) {
      return remoteDataSource.insertTransaction(entity);
    } else {
      return await remoteDataSource.updateTransaction(entity);
    }
  }

  @override
  Future<Transaction?> restGetRemote(int id) async {
    return await remoteDataSource.getTransaction(id);
  }

  @override
  Future<void> restDeleteRemote(Transaction entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteTransaction(entity.id!);
    }
  }

  // Implementing the required methods from SyncTypeHandler
  @override
  Future<void> deleteLocal(Transaction entity) async {
    await table.deleteOne(entity);
  }

  @override
  Future<void> upsertLocal(Transaction entity) async {
    await table.insertOne(entity, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Transaction> list) async {
    await table.insertAll(list, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  String getClientId(Transaction entity) {
    return entity.clientId;
  }

  @override
  Future<Transaction> getLocalByClientId(String clientId) async {
    final result = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .get();
    return result.first;
  }

  @override
  Future<Transaction?> getLocalByServerId(int serverId) async {
    final result =
        await (db.select(table)..where((t) => t.id.equals(serverId))).get();
    return result.first;
  }

  @override
  int getServerId(Transaction entity) {
    return entity.id!;
  }

  // // Example of using the sync methods
  // Future<void> syncTransaction(Transaction transaction) async {
  //   await upsertLocal(transaction);
  // }

  // Future<void> deleteTransaction(Transaction transaction) async {
  //   await deleteLocal(transaction);
  // }

  // Future<void> syncAllTransactions(List<Transaction> transactions) async {
  //   await upsertAllLocal(transactions);
  // }

  // Future<void> clearAllTransactions() async {
  //   await deleteAllLocal();
  // }
}
