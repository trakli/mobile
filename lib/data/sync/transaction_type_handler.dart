// lib/data/sync/transaction_type_handler.dart
import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:injectable/injectable.dart';

// @Injectable(as: SyncTypeHandler<Transaction, String>)
// @Injectable(as: TransactionTypeHandler)
@lazySingleton
class TransactionTypeHandler extends SyncTypeHandler<Transaction, String>
    with RestSyncTypeHandler<Transaction, String> {
  TransactionTypeHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final TransactionRemoteDataSource remoteDataSource;

  $TransactionsTable get table => db.transactions;
  // final TransactionLocalDataSource localDataSource;
  // final ApiService apiService;

  @override
  String get entityType => 'transaction';

  // @override
  // TableInfo<Transactions, Transaction> get table => db.transactions;

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

  @override
  Future<void> deleteAllLocal() {
    return db.delete(db.transactions).go();
  }

  @override
  Future<void> deleteLocal(Transaction entity) async {
    db.delete(db.transactions)
      ..where((t) => t.id.equals(entity.id))
      ..goAndReturn();
  }

  @override
  Future<void> upsertAllLocal(List<Transaction> list) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.transactions,
        list
            .map((entity) => TransactionsCompanion(
                  id: Value(entity.id),
                  amount: Value(entity.amount),
                  category: Value(entity.category),
                  description: Value(entity.description),
                  serverId: Value(entity.serverId),
                  rev: Value(entity.rev),
                  createdAtLocal: Value(entity.createdAtLocal),
                  updatedAtLocal: Value(DateTime.now()),
                ))
            .toList(),
      );
    });
  }

  @override
  Future<void> upsertLocal(Transaction entity) async {
    await db.into(db.transactions).insertOnConflictUpdate(
          TransactionsCompanion(
            id: Value(entity.id),
            amount: Value(entity.amount),
            category: Value(entity.category),
            description: Value(entity.description),
            rev: Value(entity.rev),
            createdAtLocal: Value(entity.createdAtLocal),
            updatedAtLocal: Value(DateTime.now()),
          ),
        );
  }
}
