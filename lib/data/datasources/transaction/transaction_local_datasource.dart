import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/models/wallet_stats.dart';
import 'package:uuid/uuid.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionCompleteDto>> getAllTransactions();
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId,
  );
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId,
  );
  Future<TransactionCompleteDto> deleteTransaction(String id);

  Stream<List<TransactionCompleteDto>> listenToTransaction();
}

@Injectable(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<TransactionCompleteDto>> getAllTransactions() async {
    // Create a query that joins transactions with their categories
    final query = database.select(database.transactions).join([
      leftOuterJoin(
        database.categorizables,
        database.categorizables.categorizableId
                .equalsExp(database.transactions.clientId) &
            database.categorizables.categorizableType
                .equals(CategorizableType.transaction.name),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.categorizables.categoryClientId),
      ),
      leftOuterJoin(
        database.wallets,
        database.wallets.clientId
            .equalsExp(database.transactions.walletClientId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(database.transactions.createdAt)]);

    final rows = await query.get();
    return mapTransactionAndComplete(rows);
  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId,
  ) async {
    // Verify that all categories exist
    for (var categoryId in categoryIds) {
      final categoryModel = await (database.select(database.categories)
            ..where((c) => c.clientId.equals(categoryId)))
          .getSingleOrNull();

      if (categoryModel == null) {
        throw Exception('Category $categoryId not found');
      }
    }

    // Verify that the wallet exists
    final wallet = await (database.select(database.wallets)
          ..where((w) => w.clientId.equals(walletClientId)))
        .getSingleOrNull();

    if (wallet == null) {
      throw Exception('Wallet $walletClientId not found');
    }

    // Ensure UTC time and format for server compatibility
    final now = formatServerIsoDateTime(DateTime.now());
    final utcDatetime = formatServerIsoDateTime(datetime);

    final model = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            clientId: const Uuid().v4(),
            amount: amount,
            description: Value(description),
            type: type,
            datetime: utcDatetime,
            createdAt: Value(now),
            walletClientId: walletClientId,
          ),
        );

    // Calculate new stats
    final currentStats =
        wallet.stats ?? WalletStats(totalIncome: 0, totalExpense: 0);
    final newStats = WalletStats(
      totalIncome: type == TransactionType.income
          ? currentStats.totalIncome + amount
          : currentStats.totalIncome,
      totalExpense: type == TransactionType.expense
          ? currentStats.totalExpense + amount
          : currentStats.totalExpense,
    );

    // Update wallet balance and stats
    await (database.update(database.wallets)
          ..where((w) => w.clientId.equals(walletClientId)))
        .write(
      WalletsCompanion(
        balance: Value(
          type == TransactionType.income
              ? wallet.balance + amount
              : wallet.balance - amount,
        ),
        stats: Value(newStats),
      ),
    );

    for (var categoryId in categoryIds) {
      await database.into(database.categorizables).insert(
            CategorizablesCompanion.insert(
              categorizableId: model.clientId,
              categorizableType: CategorizableType.transaction,
              categoryClientId: categoryId,
            ),
          );
    }

    final categories = await database.getCategoriesForTransaction(
      model.clientId,
      CategorizableType.transaction,
    );

    final updatedWallet = await (database.select(database.wallets)
          ..where((w) => w.clientId.equals(walletClientId)))
        .getSingleOrNull();

    if (updatedWallet == null) {
      throw Exception('Wallet $walletClientId not found');
    }

    return TransactionCompleteDto.fromTransaction(
      transaction: model,
      categories: categories,
      wallet: updatedWallet,
    );
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId,
  ) async {
    return database.transaction(() async {
      // Get the original transaction
      final originalTransaction = await (database.select(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .getSingle();

      // If wallet is being changed or amount is being updated, handle wallet balances
      if (walletClientId != null || amount != null) {
        // Get the original wallet
        final originalWallet = await (database.select(database.wallets)
              ..where(
                  (w) => w.clientId.equals(originalTransaction.walletClientId)))
            .getSingleOrNull();

        if (originalWallet != null) {
          // Calculate new stats for original wallet
          final currentStats = originalWallet.stats ??
              WalletStats(totalIncome: 0, totalExpense: 0);
          final newStats = WalletStats(
            totalIncome: originalTransaction.type == TransactionType.income
                ? currentStats.totalIncome -
                    originalTransaction.amount +
                    (amount ?? originalTransaction.amount)
                : currentStats.totalIncome,
            totalExpense: originalTransaction.type == TransactionType.expense
                ? currentStats.totalExpense -
                    originalTransaction.amount +
                    (amount ?? originalTransaction.amount)
                : currentStats.totalExpense,
          );

          // First revert the original transaction's effect on balance, then apply the new amount
          // var balance = originalWallet.balance;

          final newAmount = amount!;

          final balanceAfterRevert =
              originalTransaction.type == TransactionType.income
                  ? originalWallet.balance -
                      originalTransaction.amount // Revert income by subtracting
                  : originalWallet.balance +
                      originalTransaction.amount; // Revert expense by adding

          final newBalance = originalTransaction.type == TransactionType.income
              ? balanceAfterRevert + newAmount // Apply new income by adding
              : balanceAfterRevert -
                  newAmount; // Apply new expense by subtracting

          await database.update(database.wallets).write(
                WalletsCompanion(
                  balance: Value(newBalance),
                  stats: Value(newStats),
                ),
              );
        }

        // If wallet is being changed, update the new wallet's balance
        if (walletClientId != null) {
          final newWallet = await (database.select(database.wallets)
                ..where((w) => w.clientId.equals(walletClientId)))
              .getSingleOrNull();

          if (newWallet == null) {
            throw Exception('New wallet $walletClientId not found');
          }

          // Calculate new stats for new wallet
          final currentStats =
              newWallet.stats ?? WalletStats(totalIncome: 0, totalExpense: 0);
          final newAmount = amount ?? originalTransaction.amount;
          final newStats = WalletStats(
            totalIncome: originalTransaction.type == TransactionType.income
                ? (currentStats.totalIncome) + newAmount
                : currentStats.totalIncome,
            totalExpense: originalTransaction.type == TransactionType.expense
                ? (currentStats.totalExpense) + newAmount
                : currentStats.totalExpense,
          );

          await database.update(database.wallets).write(
                WalletsCompanion(
                  balance: Value(
                    originalTransaction.type == TransactionType.income
                        ? newWallet.balance + newAmount
                        : newWallet.balance - newAmount,
                  ),
                  stats: Value(newStats),
                ),
              );
        }
      }

      final model = await (database.update(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .writeReturning(
        TransactionsCompanion(
          amount: amount != null ? Value(amount) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          datetime: datetime != null
              ? Value(formatServerIsoDateTime(datetime))
              : const Value.absent(),
          walletClientId: walletClientId != null
              ? Value(walletClientId)
              : const Value.absent(),
        ),
      );

      final categories = await database.getCategoriesForTransaction(
        model.first.clientId,
        CategorizableType.transaction,
      );

      final wallet = await (database.select(database.wallets)
            ..where((w) => w.clientId.equals(model.first.walletClientId)))
          .getSingleOrNull();

      if (wallet == null) {
        throw Exception('Wallet ${model.first.walletClientId} not found');
      }

      if (categoryIds == null) {
        return TransactionCompleteDto.fromTransaction(
          transaction: model.first,
          categories: categories,
          wallet: wallet,
        );
      }

      final categoriesToRemove =
          categories.where((c) => !categoryIds.contains(c.clientId)).toList();

      for (var category in categoriesToRemove) {
        await database.categorizables.deleteWhere(
          (row) =>
              row.categorizableId.equals(model.first.clientId) &
              row.categorizableType.equals(CategorizableType.transaction.name) &
              row.categoryClientId.equals(category.clientId),
        );
      }

      final categoriesToAdd = categoryIds
          .where((c) => !categories.any((cc) => cc.clientId == c))
          .toList();

      for (var categoryId in categoriesToAdd) {
        await database.into(database.categorizables).insert(
              CategorizablesCompanion.insert(
                categorizableId: model.first.clientId,
                categorizableType: CategorizableType.transaction,
                categoryClientId: categoryId,
              ),
            );
      }

      final finalCategories = await database.getCategoriesForTransaction(
        model.first.clientId,
        CategorizableType.transaction,
      );

      return TransactionCompleteDto.fromTransaction(
        transaction: model.first,
        categories: finalCategories,
        wallet: wallet,
      );
    });
  }

  @override
  Future<TransactionCompleteDto> deleteTransaction(String id) async {
    return database.transaction(() async {
      final transaction = await (database.select(database.transactions)
            ..where((t) => t.clientId.equals(id)))
          .getSingle();

      // Update wallet balance if transaction has a wallet
      final wallet = await (database.select(database.wallets)
            ..where((w) => w.clientId.equals(transaction.walletClientId)))
          .getSingleOrNull();

      if (wallet == null) {
        throw Exception('Wallet ${transaction.walletClientId} not found');
      }

      // Calculate new stats
      final currentStats =
          wallet.stats ?? WalletStats(totalIncome: 0, totalExpense: 0);
      final newStats = WalletStats(
        totalIncome: transaction.type == TransactionType.income
            ? (currentStats.totalIncome) + transaction.amount
            : currentStats.totalIncome,
        totalExpense: transaction.type == TransactionType.expense
            ? (currentStats.totalExpense) + transaction.amount
            : currentStats.totalExpense,
      );

      // Update balance and stats
      await database.update(database.wallets).write(
            WalletsCompanion(
              balance: Value(
                transaction.type == TransactionType.income
                    ? wallet.balance - transaction.amount
                    : wallet.balance + transaction.amount,
              ),
              stats: Value(newStats),
            ),
          );

      await database.delete(database.transactions).delete(transaction);

      return TransactionCompleteDto.fromTransaction(
        transaction: transaction,
        wallet: wallet,
      );
    });
  }

  @override
  Stream<List<TransactionCompleteDto>> listenToTransaction() {
    // Create a query that joins transactions with their categories and wallets
    final query = database.select(database.transactions).join([
      leftOuterJoin(
        database.categorizables,
        database.categorizables.categorizableId
                .equalsExp(database.transactions.clientId) &
            database.categorizables.categorizableType
                .equals(CategorizableType.transaction.name),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.categorizables.categoryClientId),
      ),
      leftOuterJoin(
        database.wallets,
        database.wallets.clientId
            .equalsExp(database.transactions.walletClientId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(database.transactions.createdAt)]);

    // Map the results to a structured format
    return query.watch().map((rows) {
      return mapTransactionAndComplete(rows);
    });
  }

  List<TransactionCompleteDto> mapTransactionAndComplete(
      List<TypedResult> rows) {
    final transactionMap = <String, TransactionCompleteDto>{};

    for (final row in rows) {
      final transaction = row.readTable(database.transactions);
      final category = row.readTableOrNull(database.categories);
      final wallet = row.readTableOrNull(database.wallets);

      if (wallet == null) {
        throw Exception('Wallet ${transaction.walletClientId} not found');
      }

      // Initialize the transaction entry if not exists
      transactionMap.putIfAbsent(
          transaction.clientId,
          () => TransactionCompleteDto.fromTransaction(
                transaction: transaction,
                categories: [],
                wallet: wallet,
              ));

      // Add the category if it exists (leftOuterJoin may return null)
      if (category != null) {
        final currentCategories = List<Category>.from(
            transactionMap[transaction.clientId]?.categories ?? []);
        if (!currentCategories.any((c) => c.clientId == category.clientId)) {
          currentCategories.add(category);
          // Create a new TransactionCompleteModel with the updated categories
          transactionMap[transaction.clientId] =
              TransactionCompleteDto.fromTransaction(
            transaction: transaction,
            categories: currentCategories,
            wallet: wallet,
          );
        }
      }
    }

    // The data is already ordered from the database query, so we can just return the values
    return transactionMap.values.toList();
  }
}

// DateTime (2025-05-16 04:29:30.000Z)

// DateTime (2025-05-16 03:13:49.000Z)
