// Abstract Data Source
import 'package:dio/dio.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class TransactionRemoteDataSource {
  Future<List<Transaction>> getAllTransactions();
  Future<Transaction> getTransaction(String id);
  Future<Transaction> insertTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  // Future<List<TransactionEntity>> syncTransactions(
  //     List<TransactionEntity> localTransactions);
}

// @Injectable(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final response = await dio.get('transactions');
    return (response.data as List)
        .map((json) => Transaction.fromJson(json))
        .toList();

  }

  @override
  Future<Transaction> insertTransaction(Transaction transaction) async {
    //try {
    var response = await dio.post(
      'transactions',
      data: transaction.toJson(),
    );

    final data = response.data;
    return Transaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    var response = await dio.put(
      'transactions/${transaction.id}',
      data: transaction.toJson(),
    );

    final data = response.data;
    return Transaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await dio.delete('transactions/$id');
  }

  @override
  Future<Transaction> getTransaction(String id) async {
    final response = await dio.get('transactions/$id');
    return Transaction.fromJson(response.data);
  }
}
