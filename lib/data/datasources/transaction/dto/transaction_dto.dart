import 'package:json_annotation/json_annotation.dart';
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
  @JsonKey(name: 'client_generated_id')
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

// @JsonSerializable()
// class WalletDTO {
//   final int id;
//   final String name;
//   final String type;
//   final String balance;
//   final String currency;
//   final String description;
//   @JsonKey(name: 'user_id')
//   final int userId;
//   @JsonKey(name: 'created_at')
//   final String createdAt;
//   @JsonKey(name: 'updated_at')
//   final String updatedAt;
//   @JsonKey(name: 'last_synced_at')
//   final String lastSyncedAt;
//   @JsonKey(name: 'client_generated_id')
//   final String clientGeneratedId;
//   @JsonKey(name: 'sync_state')
//   final SyncStateDTO syncState;

//   WalletDTO({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.balance,
//     required this.currency,
//     required this.description,
//     required this.userId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.lastSyncedAt,
//     required this.clientGeneratedId,
//     required this.syncState,
//   });

//   factory WalletDTO.fromJson(Map<String, dynamic> json) =>
//       _$WalletDTOFromJson(json);

//   Map<String, dynamic> toJson() => _$WalletDTOToJson(this);
// }

// @JsonSerializable()
// class SyncStateDTO {
//   final int id;
//   @JsonKey(name: 'syncable_type')
//   final String syncableType;
//   @JsonKey(name: 'syncable_id')
//   final int syncableId;
//   final dynamic source;
//   @JsonKey(name: 'client_generated_id')
//   final String clientGeneratedId;
//   @JsonKey(name: 'last_synced_at')
//   final String lastSyncedAt;
//   @JsonKey(name: 'created_at')
//   final String createdAt;
//   @JsonKey(name: 'updated_at')
//   final String updatedAt;

//   SyncStateDTO({
//     required this.id,
//     required this.syncableType,
//     required this.syncableId,
//     this.source,
//     required this.clientGeneratedId,
//     required this.lastSyncedAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory SyncStateDTO.fromJson(Map<String, dynamic> json) =>
//       _$SyncStateDTOFromJson(json);

//   Map<String, dynamic> toJson() => _$SyncStateDTOToJson(this);
// }
