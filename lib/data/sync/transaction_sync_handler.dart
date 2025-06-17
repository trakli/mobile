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

    Party? party;
    if (transactionCompleteModel.transaction.partyClientId != null) {
      party = await db.getPartyForTransaction(
          transactionCompleteModel.transaction.clientId);
    }

    Group? group;
    if (transactionCompleteModel.transaction.groupClientId != null) {
      group = await db.getGroupForTransaction(
          transactionCompleteModel.transaction.clientId);
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: transactionCompleteModel.transaction,
      categories: categories,
      wallet: wallet,
      party: party,
      group: group,
    );
  }

  @override
  Map<String, dynamic> marshal(TransactionCompleteDto entity) {
    return entity.toJson();
  }

  @override
  bool shouldPersistRemote(TransactionCompleteDto entity) {
    // Check if any of the categories is null or wallet is null
    final hasNullCategory = entity.categories.map((c) => c.id).contains(null);
    final hasNullWalletId = entity.wallet.id == null;
    final hasNullPartyId = entity.party != null && entity.party!.id == null;
    final hasNullGroupId = entity.group != null && entity.group!.id == null;

    // Return false if either has null values
    if (hasNullCategory ||
        hasNullWalletId ||
        hasNullPartyId ||
        hasNullGroupId) {
      return false;
    }
    return true;
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
        partyClientId: Value(entity.party?.clientId),
        groupClientId: Value(entity.group?.clientId),
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

      await db.wallets
          .insertOne(entity.wallet, mode: InsertMode.insertOrReplace);

      if (entity.party != null) {
        await db.parties
            .insertOne(entity.party!, mode: InsertMode.insertOrReplace);
      }

      if (entity.group != null) {
        await db.groups
            .insertOne(entity.group!, mode: InsertMode.insertOrReplace);
      }
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

    Party? party;
    if (result.first.partyClientId != null) {
      party = await db.getPartyForTransaction(clientId);
    }

    Group? group;
    if (result.first.groupClientId != null) {
      group = await db.getGroupForTransaction(clientId);
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: result.first,
      categories: await db.getCategoriesForTransaction(
        result.first.clientId,
        CategorizableType.transaction,
      ),
      wallet: wallet,
      party: party,
      group: group,
    );
  }

  @override
  Future<TransactionCompleteDto?> getLocalByServerId(int serverId) async {
    final result =
        await (db.select(table)..where((t) => t.id.equals(serverId))).get();

    if (result.isEmpty) {
      return null;
    }

    final wallet = await db.getWalletForTransaction(result.first.clientId);

    if (wallet == null) {
      throw Exception('Wallet ${result.first.clientId} not found');
    }

    Party? party;
    if (result.first.partyClientId != null) {
      party = await db.getPartyForTransaction(result.first.clientId);
    }

    Group? group;
    if (result.first.groupClientId != null) {
      group = await db.getGroupForTransaction(result.first.clientId);
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: result.first,
      categories: await db.getCategoriesForTransaction(
        result.first.clientId,
        CategorizableType.transaction,
      ),
      wallet: wallet,
      party: party,
      group: group,
    );
  }

  @override
  int? getServerId(TransactionCompleteDto entity) {
    return entity.transaction.id;
  }
}
