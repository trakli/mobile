import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:uuid/uuid.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionCompleteDto>> getAllTransactions();
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
  );
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
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
        database.transactionCategories,
        database.transactionCategories.transactionClientId
            .equalsExp(database.transactions.clientId),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.transactionCategories.categoryClientId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(database.transactions.createdAt)]);

    final rows = await query.get();
    return mapTransactionAndComplete(rows);
  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
    double amount,
    String? description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
  ) async {
    for (var categoryId in categoryIds) {
      final categoryModel = await (database.select(database.categories)
            ..where((c) => c.clientId.equals(categoryId)))
          .getSingleOrNull();

      if (categoryModel == null) {
        throw Exception('Category $categoryId not found');
      }
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
              createdAt: Value(now)),
        );

    for (var categoryId in categoryIds) {
      await database.into(database.transactionCategories).insert(
            TransactionCategoriesCompanion.insert(
              transactionClientId: model.clientId,
              categoryClientId: categoryId,
            ),
          );
    }

    final categories =
        await database.getCategoriesForTransaction(model.clientId);

    return TransactionCompleteDto.fromTransaction(
      transaction: model,
      categories: categories,
    );
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
  ) async {
    final model = await (database.update(database.transactions)
          ..where((t) => t.clientId.equals(id)))
        .writeReturning(
      TransactionsCompanion(
        amount: amount != null ? Value(amount) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        // category: category != null ? Value(category) : const Value.absent(),
      ),
    );

    final categories =
        await database.getCategoriesForTransaction(model.first.clientId);

    if (categoryIds == null) {
      return TransactionCompleteDto.fromTransaction(
        transaction: model.first,
        categories: categories,
      );
    }

    final categoriesToRemove =
        categories.where((c) => !categoryIds.contains(c.clientId)).toList();

    for (var category in categoriesToRemove) {
      await database.delete(database.transactionCategories).delete(
            TransactionCategoriesCompanion.insert(
              transactionClientId: model.first.clientId,
              categoryClientId: category.clientId,
            ),
          );
    }

    final categoriesToAdd = categoryIds
        .where((c) => !categories.any((cc) => cc.clientId == c))
        .toList();

    for (var categoryId in categoriesToAdd) {
      await database.into(database.transactionCategories).insert(
            TransactionCategoriesCompanion.insert(
              transactionClientId: model.first.clientId,
              categoryClientId: categoryId,
            ),
          );
    }

    final finalCategories =
        await database.getCategoriesForTransaction(model.first.clientId);

    return TransactionCompleteDto.fromTransaction(
      transaction: model.first,
      categories: finalCategories,
    );
  }

  @override
  Future<TransactionCompleteDto> deleteTransaction(String id) async {
    final model = await (database.select(database.transactions)
          ..where((t) => t.clientId.equals(id)))
        .getSingle();

    await database.delete(database.transactions).delete(model);

    return TransactionCompleteDto.fromTransaction(
      transaction: model,
    );
  }

  @override
  Stream<List<TransactionCompleteDto>> listenToTransaction() {
    // Create a query that joins transactions with their categories
    final query = database.select(database.transactions).join([
      leftOuterJoin(
        database.transactionCategories,
        database.transactionCategories.transactionClientId
            .equalsExp(database.transactions.clientId),
      ),
      leftOuterJoin(
        database.categories,
        database.categories.clientId
            .equalsExp(database.transactionCategories.categoryClientId),
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

      // Initialize the transaction entry if not exists
      transactionMap.putIfAbsent(
          transaction.clientId,
          () => TransactionCompleteDto.fromTransaction(
                transaction: transaction,
                categories: [],
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
          );
        }
      }
    }

    // The data is already ordered from the database query, so we can just return the values
    return transactionMap.values.toList();
  }
}
