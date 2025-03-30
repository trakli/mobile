import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'Amount',
              value: '\$${transaction.amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Description',
              value: transaction.description,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Category',
              value: transaction.category,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Date',
              value: transaction.createdAtLocal.toString().split(' ')[0],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required String value}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
