import 'dart:convert';
import 'package:trakli/domain/models/transaction_model.dart';
import 'package:trakli/domain/providers/api_service.dart';
import 'package:trakli/domain/providers/database_helper.dart';

class SyncService {
  final dbHelper = DatabaseHelper();
  final apiService = ApiService();

  Future<void> processQueue() async {
    final db = await dbHelper.db;
    final List<Map<String, dynamic>> queue =
        await db.query('sync_queue', orderBy: 'createdAt');

    for (final item in queue) {
      final model = item['modelName'];
      final operation = item['operation'];
      final data = jsonDecode(item['data']);
      final id = item['id'];

      try {
        if (model == 'Transaction') {
          await _processTransaction(operation, data);
        }

        await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
      } catch (e) {
        // print('Sync failed for item $id: $e');
        // Retry logic or mark as failed
      }
    }
  }

  Future<void> _processTransaction(String op, Map<String, dynamic> data) async {
    final tx = TransactionModel.fromJson(data);
    switch (op) {
      case 'create':
        await apiService.createTransaction(tx);
        break;
      case 'update':
        await apiService.updateTransaction(tx);
        break;
      case 'delete':
        await apiService.deleteTransaction(tx.id);
        break;
    }

    // Update lastSyncedAt
    final db = await dbHelper.db;
    await db.update(
      'transactions',
      {'lastSyncedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  //process other models
}
