import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/core/dto/sync_state_dto.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'transaction_dto.g.dart';

@JsonSerializable()
class TransactionDTO {
  final int id;
  final double amount;
  final TransactionType type;
  final String? description;
  final String datetime;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'wallet_id')
  final int walletId;
  @JsonKey(name: 'user_id')
  final int userId;
  final WalletDto? wallet;
  final List<dynamic> categories;
  @JsonKey(name: 'last_synced_at')
  final DateTime lastSyncedAt;
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  final String clientGeneratedId;
  @JsonKey(name: 'sync_state')
  final SyncStateDto syncState;

  TransactionDTO({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.datetime,
    required this.createdAt,
    required this.updatedAt,
    required this.walletId,
    required this.userId,
    this.wallet,
    required this.categories,
    required this.lastSyncedAt,
    required this.clientGeneratedId,
    required this.syncState,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) =>
      _$TransactionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDTOToJson(this);
}
