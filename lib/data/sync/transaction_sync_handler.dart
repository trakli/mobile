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
      CategorizableType.transaction,
    );

    final wallet = await (db.select(db.wallets)
          ..where((w) => w.clientId
              .equals(transactionCompleteModel.transaction.walletClientId)))
        .getSingleOrNull();

    if (wallet == null) {
      throw Exception(
          'Wallet ${transactionCompleteModel.transaction.walletClientId} not found');
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: transactionCompleteModel.transaction,
      categories: categories,
      wallet: wallet,
    );
  }

  @override
  Map<String, dynamic> marshal(TransactionCompleteDto entity) {
    return entity.toJson();
  }

  @override
  bool shouldPersistRemote(TransactionCompleteDto entity) {
    return !entity.categories.map((c) => c.id).contains(null);
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
    return db.transaction(() async {
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
        walletClientId: Value(entity.wallet.clientId),
      );

      await table.insertOne(transaction, mode: InsertMode.insertOrReplace);

      final categories = await db.getCategoriesForTransaction(
        entity.transaction.clientId,
        CategorizableType.transaction,
      );

      final categoriesToRemove = categories
          .where(
              (c) => !entity.categories.any((cc) => cc.clientId == c.clientId))
          .toList();

      //Removes stale category links
      for (var category in categoriesToRemove) {
        await db.categorizables.deleteWhere((row) =>
            row.categorizableId.equals(entity.transaction.clientId) &
            row.categorizableType.equals(CategorizableType.transaction.name) &
            row.categoryClientId.equals(category.clientId));
      }

      for (var category in entity.categories) {
        await db.categorizables.insertOne(
            CategorizablesCompanion.insert(
              categorizableId: entity.transaction.clientId,
              categorizableType: CategorizableType.transaction,
              categoryClientId: category.clientId,
            ),
            mode: InsertMode.insertOrReplace);
      }

      // final wallet = WalletsCompanion(
      //   id: Value(entity.wallet.id),
      //   rev: Value(entity.wallet.rev),
      //   name: Value(entity.wallet.name),
      //   type: Value(entity.wallet.type),
      //   currency: Value(entity.wallet.currency),
      //   clientId: Value(entity.wallet.clientId),
      //   balance: Value(entity.wallet.balance),
      //   lastSyncedAt: Value(entity.wallet.lastSyncedAt),
      //   updatedAt: Value(entity.wallet.updatedAt),
      //   createdAt: Value(entity.wallet.createdAt),
      // );

      await db.wallets
          .insertOne(entity.wallet, mode: InsertMode.insertOrReplace);
    });
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

    final wallet = await db.getWalletForTransaction(clientId);

    if (wallet == null) {
      throw Exception('Wallet $clientId not found');
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: result.first,
      categories: await db.getCategoriesForTransaction(
        result.first.clientId,
        CategorizableType.transaction,
      ),
      wallet: wallet,
    );
  }

  @override
  Future<TransactionCompleteDto?> getLocalByServerId(int serverId) async {
    final result =
        await (db.select(table)..where((t) => t.id.equals(serverId))).get();

    final wallet = await db.getWalletForTransaction(result.first.clientId);

    if (wallet == null) {
      throw Exception('Wallet ${result.first.clientId} not found');
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: result.first,
      categories: await db.getCategoriesForTransaction(
        result.first.clientId,
        CategorizableType.transaction,
      ),
      wallet: wallet,
    );
  }

  @override
  int? getServerId(TransactionCompleteDto entity) {
    return entity.transaction.id;
  }
}
