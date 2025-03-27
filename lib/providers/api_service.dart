import 'dart:convert';
import 'package:dio/dio.dart' show Dio, Options;
import 'package:trakli/models/transaction_model.dart';

class ApiService {
  final String baseUrl = 'https://your-api.com';

  Future<void> createTransaction(TransactionModel tx) async {
    final dio = Dio();
    final response = await dio.post(
      '$baseUrl/transactions',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode(tx.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction');
    }
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    final dio = Dio();
    final response = await dio.put(
      '$baseUrl/transactions/${tx.id}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: json.encode(tx.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final dio = Dio();
    final response = await dio.delete(
      '$baseUrl/transactions/$id',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete transaction');
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    final dio = Dio();
    final response = await dio.get(
      '$baseUrl/transactions',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.data);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

// Add update, delete, getAll methods similarly...
}
