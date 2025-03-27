import 'dart:convert';
import 'package:trakli/models/transaction_model.dart';
import 'package:trakli/providers/api_service.dart';
import 'package:trakli/providers/database_helper.dart';

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

    if (op == "delete") {
      //todo also delete from local storage db
      // await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    }
  }

  //process other models

  Future<void> fetchAndSyncTransactions() async {
    final db = await dbHelper.db;

    try {
      // 1. Get transactions from the API
      List<TransactionModel> remoteTransactions =
          await apiService.getTransactions();

      for (var remoteTx in remoteTransactions) {
        // 2. Check if transaction exists locally
        final localTxList = await db.query(
          'transactions',
          where: 'id = ?',
          whereArgs: [remoteTx.id],
        );

        if (localTxList.isEmpty) {
          // 3a. Insert if not found
          await db.insert('transactions', remoteTx.toMap());
        } else {
          final localTx = TransactionModel.fromMap(localTxList.first);

          // 3b. Compare updatedAt to decide if update is needed
          if (remoteTx.updatedAt != null &&
              (localTx.updatedAt == null ||
                  remoteTx.updatedAt!.isAfter(localTx.updatedAt!))) {
            // Only update if remote updatedAt is after the local one or if local updatedAt is null
            await db.update(
              'transactions',
              remoteTx.toMap(),
              where: 'id = ?',
              whereArgs: [remoteTx.id],
            );
          }
        }
      }

      // print('Transactions synced from server ✅');
    } catch (e) {
      // print('Error fetching transactions from server: $e');
      // Handle retry, logging, etc.
    }
  }
}
