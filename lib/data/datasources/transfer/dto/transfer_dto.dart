import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/core/util.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';

part 'transfer_dto.freezed.dart';
part 'transfer_dto.g.dart';

@freezed
class TransferDto with _$TransferDto {
  @JsonSerializable(explicitToJson: true)
  const factory TransferDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
    required String clientId,
    String? rev,
    @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
    DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'last_synced_at') DateTime? lastSyncedAt,
    @JsonKey(fromJson: parseAmount) required double amount,
    @JsonKey(name: 'from_wallet_id') int? fromWalletId,
    @JsonKey(name: 'to_wallet_id') int? toWalletId,
    @JsonKey(name: 'source_wallet') WalletDto? sourceWallet,
    @JsonKey(name: 'destination_wallet') WalletDto? destinationWallet,
    @JsonKey(name: 'from_wallet_client_id') String? fromWalletClientId,
    @JsonKey(name: 'to_wallet_client_id') String? toWalletClientId,
    @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
    double? exchangeRate,
    @JsonKey(fromJson: safeParseDateTime) DateTime? datetime,
    @JsonKey(name: 'expense_transaction_client_id')
    String? expenseTransactionClientId,
    @JsonKey(name: 'income_transaction_client_id')
    String? incomeTransactionClientId,
  }) = _TransferDto;

  const TransferDto._();

  factory TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);

  factory TransferDto.fromTransfer(Transfer transfer) => TransferDto(
        id: transfer.id,
        userId: transfer.userId,
        clientId: transfer.clientId,
        rev: transfer.rev,
        createdAt: transfer.createdAt,
        updatedAt: transfer.updatedAt,
        deletedAt: transfer.deletedAt,
        lastSyncedAt: transfer.lastSyncedAt,
        amount: transfer.amount,
        fromWalletId: transfer.fromWalletId,
        toWalletId: transfer.toWalletId,
        fromWalletClientId: transfer.fromWalletClientId,
        toWalletClientId: transfer.toWalletClientId,
        exchangeRate: transfer.exchangeRate,
        datetime: transfer.datetime,
        expenseTransactionClientId: transfer.expenseTransactionClientId,
        incomeTransactionClientId: transfer.incomeTransactionClientId,
      );

  /// The server's `transfers.datetime` column is nullable and was only
  /// populated from the 2026-02-23 backend change onwards, so transfers
  /// created before then arrive as `null`. The date columns are all
  /// non-nullable locally, and a single unparseable row used to throw out of
  /// the page parse and fail the whole transfer down-sync, so resolve them
  /// here instead of casting in the generated parser.
  DateTime get _createdAt => createdAt ?? updatedAt ?? datetime ?? _epoch;

  DateTime get _updatedAt => updatedAt ?? _createdAt;

  DateTime get _datetime => datetime ?? _createdAt;

  static final DateTime _epoch =
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  Transfer toTransfer() => Transfer(
        id: id,
        userId: userId,
        clientId: clientId,
        rev: rev,
        createdAt: _createdAt,
        updatedAt: _updatedAt,
        deletedAt: deletedAt,
        lastSyncedAt: lastSyncedAt,
        amount: amount,
        fromWalletId: fromWalletId,
        toWalletId: toWalletId,
        fromWalletClientId: sourceWallet?.clientId ?? fromWalletClientId,
        toWalletClientId: destinationWallet?.clientId ?? toWalletClientId,
        exchangeRate: exchangeRate,
        datetime: _datetime,
        expenseTransactionClientId: expenseTransactionClientId,
        incomeTransactionClientId: incomeTransactionClientId,
      );
}

double? parseAmountNullable(dynamic value) {
  if (value == null) return null;
  return parseAmount(value);
}
