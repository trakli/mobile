// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletDtoImpl _$$WalletDtoImplFromJson(Map<String, dynamic> json) =>
    _$WalletDtoImpl(
      clientId: json['client_generated_id'] as String? ?? '',
      type: $enumDecodeNullable(_$WalletTypeEnumMap, json['type']) ??
          WalletType.bank,
      name: json['name'] as String,
      description: json['description'] as String?,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncedAt: json['last_synced_at'] == null
          ? null
          : DateTime.parse(json['last_synced_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      syncState:
          SyncStateDto.fromJson(json['sync_state'] as Map<String, dynamic>),
      rev: json['rev'] as String?,
      stats: json['stats'] == null
          ? null
          : WalletStats.fromJson(json['stats'] as Map<String, dynamic>),
      icon: json['icon'] == null
          ? null
          : Media.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletDtoImplToJson(_$WalletDtoImpl instance) =>
    <String, dynamic>{
      'client_generated_id': instance.clientId,
      'type': _$WalletTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'balance': instance.balance,
      'currency': instance.currency,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'user_id': instance.userId,
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'sync_state': instance.syncState.toJson(),
      'rev': instance.rev,
      'stats': instance.stats?.toJson(),
      'icon': instance.icon?.toJson(),
    };

const _$WalletTypeEnumMap = {
  WalletType.bank: 'bank',
  WalletType.cash: 'cash',
  WalletType.creditCard: 'credit_card',
  WalletType.mobile: 'mobile',
};
