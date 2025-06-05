import 'dart:async';
import 'package:trakli/presentation/utils/enums.dart';
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
    String walletClientId,
  ) async {
    return _simulateDelay(() async {
      final transaction = TransactionEntity(
        clientId: const Uuid().v4(),
        amount: amount,
        description: description,
        datetime: DateTime.now(),
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        walletClientId: walletClientId,
      );
      _transactions.add(transaction);
      _notifyListeners();
      return transaction;
    });
  }

  // Update a transaction
  Future<TransactionEntity> updateTransaction(
    String clientId,
    double? amount,
    String? description,
    String? category,
  ) async {
    return _simulateDelay(() async {
      final index = _transactions.indexWhere((t) => t.clientId == clientId);
      if (index == -1) {
        throw Exception('Transaction not found');
      }

      final oldTransaction = _transactions[index];
      final updatedTransaction = oldTransaction.copyWith(
        amount: amount ?? oldTransaction.amount,
        description: description ?? oldTransaction.description,
        datetime: DateTime.now(),
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        // category: category ?? oldTransaction.category,
        // updatedAtLocal: DateTime.now(),
      );

      _transactions[index] = updatedTransaction;
      _notifyListeners();
      return updatedTransaction;
    });
  }

  // Delete a transaction
  Future<void> deleteTransaction(String clientId) async {
    await _simulateDelay(() async {
      _transactions.removeWhere((t) => t.clientId == clientId);
      _notifyListeners();
    });
  }

  // Get a single transaction
  Future<TransactionEntity> getTransaction(String clientId) async {
    return _simulateDelay(() async {
      final transaction = _transactions.firstWhere(
        (t) => t.clientId == clientId,
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
