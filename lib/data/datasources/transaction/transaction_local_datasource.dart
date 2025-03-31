import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:uuid/uuid.dart';

abstract class TransactionLocalDataSource {
  Future<List<Transaction>> getAllTransactions();
  Future<Transaction> insertTransaction(
    double amount,
    String description,
    String category,
  );
  Future<Transaction> updateTransaction(
    String id,
    double? amount,
    String? description,
    String? category,
  );
  Future<Transaction> deleteTransaction(String id);

  Stream<List<Transaction>> listenToTransaction();
}

@Injectable(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final results = await database.select(database.transactions).get();
    return results;
    // return results.map((row) => TransactionMapper.toDomain(row)).toList();
  }

  @override
  Future<Transaction> insertTransaction(
    double amount,
    String? description,
    String category,
  ) async {
    final model = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            id: const Uuid().v4(),
            amount: amount,
            description: Value(description),
            category: category,
          ),
        );

    return model;
  }

  @override
  Future<Transaction> updateTransaction(
    String id,
    double? amount,
    String? description,
    String? category,
  ) async {
    final model = await (database.update(database.transactions)
          ..where((t) => t.id.equals(id)))
        .writeReturning(
      TransactionsCompanion(
        amount: amount != null ? Value(amount) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        category: category != null ? Value(category) : const Value.absent(),
      ),
    );

    return model.first;
  }

  @override
  Future<Transaction> deleteTransaction(String id) async {
    final model = await (database.select(database.transactions)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    await database.delete(database.transactions).delete(model);
    return model;
  }

  @override
  Stream<List<Transaction>> listenToTransaction() {
    return database.select(database.transactions).watch();
  }
}
