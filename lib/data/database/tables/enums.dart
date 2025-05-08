import 'package:freezed_annotation/freezed_annotation.dart';

enum CategoryType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense,
  @JsonValue('invoice')
  invoice
}

enum WalletType { bank, cash, creditCard, mobile }

enum TransactionType { income, expense, transfer }

enum SyncStatus {
  pending, // Record needs to be synced
  syncing, // Record is currently being synced
  synced, // Record has been successfully synced
  failed, // Sync failed, needs retry
  deleted // Record has been deleted locally
}
