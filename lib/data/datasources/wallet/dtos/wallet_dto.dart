import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/dto/sync_state_dto.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/models/wallet_stats.dart';

part 'wallet_dto.freezed.dart';
part 'wallet_dto.g.dart';

@freezed
// @JsonSerializable(explicitToJson: true)
class WalletDto with _$WalletDto {
  const factory WalletDto({
    @JsonKey(name: 'client_generated_id') required String clientId,
    @JsonKey(defaultValue: WalletType.bank) required WalletType type,
    required String name,
    String? description,
    @JsonKey(name: 'balance') required double balance,
    required String currency,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse)
    required DateTime createdAt,
    int? id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
    required DateTime updatedAt,
    @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
    DateTime? lastSyncedAt,
    @JsonKey(name: 'sync_state') required SyncStateDto syncState,
    String? rev,
    @JsonKey(name: 'stats') WalletStats? stats,
    @JsonKey(name: 'icon') Media? icon,
  }) = _WalletDto;

  const WalletDto._();

  factory WalletDto.fromJson(Map<String, dynamic> json) =>
      _$WalletDtoFromJson(json);

  Wallet toModel() {
    final wallet = Wallet(
      id: id,
      userId: userId,
      clientId: clientId,
      rev: rev,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      type: type,
      balance: balance,
      currency: currency,
      description: description,
      lastSyncedAt: lastSyncedAt,
      stats: stats,
      icon: icon,
    );

    return wallet;
  }
}

double parseBalance(String balance) {
  return double.parse(balance.replaceAll(',', ''));
}
