import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: TransactionRemoteDataSource)
class MockTransactionRemoteDataSource implements TransactionRemoteDataSource {
  // Simulated database
  final List<Transaction> _transactions = [];
  final _controller = StreamController<List<Transaction>>.broadcast();

  // Simulate network delay
  Future<T> _simulateDelay<T>(Future<T> Function() action) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return action();
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return _simulateDelay(() async => _transactions);
  }

  @override
  Future<Transaction> insertTransaction(Transaction transaction) async {
    return _simulateDelay(() async {
      final requestOptions = RequestOptions(path: 'transactions');
      const reason = 'Connection error';

      // throw DioException.connectionError(
      //   requestOptions: requestOptions,
      //   reason: reason,
      // );

      final updated = transaction.copyWith(
        serverId: Value(
          const Uuid().v8(),
        ),
        lastSyncedAt: Value(
          DateTime.now(),
        ),
      );

      _transactions.add(updated);

      _notifyListeners();
      return updated;
    });
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    return _simulateDelay(() async {
      final requestOptions = RequestOptions(path: 'transactions');
      const reason = 'Connection error';

      // throw DioException.connectionError(
      //     requestOptions: requestOptions, reason: reason);

      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index == -1) {
        throw Exception('Transaction not found');
      }
      _transactions[index] = transaction
        ..copyWith(
          lastSyncedAt: Value(
            DateTime.now(),
          ),
        );
      _notifyListeners();
      return transaction;
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _simulateDelay(() async {
      _transactions.removeWhere((t) => t.id == id);
      _notifyListeners();
    });
  }

  @override
  Future<Transaction> getTransaction(String id) async {
    return _simulateDelay(() async {
      final transaction = _transactions.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Transaction not found'),
      );
      return transaction;
    });
  }

  Stream<List<Transaction>> get transactionsStream => _controller.stream;

  // Notify listeners of changes
  void _notifyListeners() {
    _controller.add(_transactions);
  }

  // Dispose the stream controller
  void dispose() {
    _controller.close();
  }

  // Helper methods for testing
  void addMockTransactions(List<Transaction> transactions) {
    _transactions.addAll(transactions);
    _notifyListeners();
  }

  void clearTransactions() {
    _transactions.clear();
    _notifyListeners();
  }

  // Simulate network error
}
