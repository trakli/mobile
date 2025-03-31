import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/transaction_table.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TransactionSyncHandler extends SyncTypeHandler<Transaction, String>
    with RestSyncTypeHandler<Transaction, String> {
  TransactionSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final TransactionRemoteDataSource remoteDataSource;

  TableInfo<Transactions, Transaction> get table => db.transactions;

  @override
  String get entityType => 'transaction';

  @override
  String getId(Transaction entity) => entity.id;

  @override
  String getRev(Transaction entity) => entity.rev;

  @override
  Future<Transaction> getLocal(String id) async {
    final row =
        await (db.select(table)..where((t) => t.id.equals(id))).getSingle();
    return Transaction(
      id: row.id,
      amount: row.amount,
      category: row.category,
      description: row.description,
      rev: row.rev,
      createdAtLocal: DateTime.now(),
      updatedAtLocal: DateTime.now(),
    );
  }

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
  Future<Transaction?> restGetRemote(String id) async {
    return await remoteDataSource.getTransaction(id);
  }

  @override
  Future<Transaction> restPutRemote(Transaction entity) async {
    if (entity.serverId == null) {
      return remoteDataSource.insertTransaction(entity);
    } else {
      return await remoteDataSource.updateTransaction(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Transaction entity) async {
    await remoteDataSource.deleteTransaction(entity.id);
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
