// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryDtoImpl _$$CategoryDtoImplFromJson(Map<String, dynamic> json) =>
    _$CategoryDtoImpl(
      clientId: json['client_generated_id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
      slug: json['slug'] as String,
      userId: (json['user_id'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncedAt: DateTime.parse(json['last_synced_at'] as String),
      syncState:
          SyncStateDto.fromJson(json['sync_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CategoryDtoImplToJson(_$CategoryDtoImpl instance) =>
    <String, dynamic>{
      'client_generated_id': instance.clientId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'slug': instance.slug,
      'user_id': instance.userId,
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'sync_state': instance.syncState.toJson(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
