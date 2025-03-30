import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_entity.dart';

class MockTransactionService {
  // Simulated database
  final List<TransactionEntity> _transactions = [];
  final _controller = StreamController<List<TransactionEntity>>.broadcast();

  // Simulate network delay
  Future<T> _simulateDelay<T>(Future<T> Function() action) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return action();
  }

  // Get all transactions
  Future<List<TransactionEntity>> getAllTransactions() async {
    return _simulateDelay(() async => _transactions);
  }

  // Create a new transaction
  Future<TransactionEntity> createTransaction(
    double amount,
    String description,
    String title,
    String category,
  ) async {
    return _simulateDelay(() async {
      final transaction = TransactionEntity(
        id: const Uuid().v4(),
        amount: amount,
        description: description,
        category: category,
        createdAtLocal: DateTime.now(),
        updatedAtLocal: DateTime.now(),
      );
      _transactions.add(transaction);
      _notifyListeners();
      return transaction;
    });
  }

  // Update a transaction
  Future<TransactionEntity> updateTransaction(
    String id,
    double? amount,
    String? description,
    String? category,
  ) async {
    return _simulateDelay(() async {
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index == -1) {
        throw Exception('Transaction not found');
      }

      final oldTransaction = _transactions[index];
      final updatedTransaction = oldTransaction.copyWith(
        amount: amount ?? oldTransaction.amount,
        description: description ?? oldTransaction.description,
        category: category ?? oldTransaction.category,
        updatedAtLocal: DateTime.now(),
      );

      _transactions[index] = updatedTransaction;
      _notifyListeners();
      return updatedTransaction;
    });
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _simulateDelay(() async {
      _transactions.removeWhere((t) => t.id == id);
      _notifyListeners();
    });
  }

  // Get a single transaction
  Future<TransactionEntity> getTransaction(String id) async {
    return _simulateDelay(() async {
      final transaction = _transactions.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Transaction not found'),
      );
      return transaction;
    });
  }

  // Stream of transactions
  Stream<List<TransactionEntity>> get transactionsStream => _controller.stream;

  // Notify listeners of changes
  void _notifyListeners() {
    _controller.add(_transactions);
  }

  // Dispose the stream controller
  void dispose() {
    _controller.close();
  }
}
