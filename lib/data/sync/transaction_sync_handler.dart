import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/transactions.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/presentation/utils/enums.dart';

@lazySingleton
class TransactionSyncHandler
    extends SyncTypeHandler<TransactionCompleteDto, String, int>
    with RestSyncTypeHandler<TransactionCompleteDto, String, int> {
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
  String getRev(TransactionCompleteDto entity) => entity.transaction.rev ?? '1';

  @override
  Future<TransactionCompleteDto> unmarshal(
      Map<String, dynamic> entityJson) async {
    final transactionCompleteModel =
        TransactionCompleteDto.fromJson(entityJson);

    final categories = await db.getCategoriesForTransaction(
      transactionCompleteModel.transaction.clientId,
      SourceType.transaction,
    );

    return TransactionCompleteDto.fromTransaction(
      transaction: transactionCompleteModel.transaction,
      categories: categories,
    );
  }

  @override
  Map<String, dynamic> marshal(TransactionCompleteDto entity) {
    return entity.toJson();
  }

  @override
  bool shouldPersistRemote(TransactionCompleteDto entity) {
    return entity.categories.contains(null);
  }

  @override
  Future<List<TransactionCompleteDto>> restGetAllRemote() async {
    return remoteDataSource.getAllTransactions();
  }

  @override
  Future<TransactionCompleteDto> restPutRemote(
      TransactionCompleteDto entity) async {
    if (entity.transaction.id == null) {
      return remoteDataSource.insertTransaction(entity);
    } else {
      return await remoteDataSource.updateTransaction(entity);
    }
  }

  @override
  Future<TransactionCompleteDto?> restGetRemote(int id) async {
    return await remoteDataSource.getTransaction(id);
  }

  @override
  Future<void> restDeleteRemote(TransactionCompleteDto entity) async {
    if (entity.transaction.id != null) {
      await remoteDataSource.deleteTransaction(entity.transaction.id!);
    }
  }

  // Implementing the required methods from SyncTypeHandler
  @override
  Future<void> deleteLocal(TransactionCompleteDto entity) async {
    await table.deleteOne(entity.transaction);
  }

  @override
  Future<void> upsertLocal(TransactionCompleteDto entity) async {
    final transaction = TransactionsCompanion(
      id: Value(entity.transaction.id),
      amount: Value(entity.transaction.amount),
      description: Value(entity.transaction.description),
      clientId: Value(entity.transaction.clientId),
      type: Value(entity.transaction.type),
      datetime: Value(entity.transaction.datetime),
      createdAt: Value(entity.transaction.createdAt),
      lastSyncedAt: Value(entity.transaction.lastSyncedAt),
      updatedAt: Value(entity.transaction.updatedAt),
    );

    await table.insertOne(transaction, mode: InsertMode.insertOrReplace);

    final categories = await db.getCategoriesForTransaction(
      entity.transaction.clientId,
      SourceType.transaction,
    );

    final categoriesToRemove = categories
        .where((c) => !entity.categories.any((cc) => cc.clientId == c.clientId))
        .toList();

    //Removes stale category links
    for (var category in categoriesToRemove) {
      await db.sourceCategories.deleteWhere((row) =>
          row.sourceId.equals(entity.transaction.clientId) &
          row.sourceType.equals(SourceType.transaction.name) &
          row.categoryClientId.equals(category.clientId));
    }

    for (var category in entity.categories) {
      await db.sourceCategories.insertOne(
          SourceCategoriesCompanion.insert(
            sourceId: entity.transaction.clientId,
            sourceType: SourceType.transaction,
            categoryClientId: category.clientId,
          ),
          mode: InsertMode.insertOrReplace);
    }
  }

  @override
  Future<void> upsertAllLocal(List<TransactionCompleteDto> list) async {
    for (var entity in list) {
      await upsertLocal(entity);
    }
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  String getClientId(TransactionCompleteDto entity) {
    return entity.transaction.clientId;
  }

  @override
  Future<TransactionCompleteDto> getLocalByClientId(String clientId) async {
    final result = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .get();
    return TransactionCompleteDto.fromTransaction(
        transaction: result.first,
        categories: await db.getCategoriesForTransaction(
          result.first.clientId,
          SourceType.transaction,
        ));
  }

  @override
  Future<TransactionCompleteDto?> getLocalByServerId(int serverId) async {
    final result =
        await (db.select(table)..where((t) => t.id.equals(serverId))).get();
    return TransactionCompleteDto.fromTransaction(
        transaction: result.first,
        categories: await db.getCategoriesForTransaction(
          result.first.clientId,
          SourceType.transaction,
        ));
  }

  @override
  int? getServerId(TransactionCompleteDto entity) {
    return entity.transaction.id;
  }
}
