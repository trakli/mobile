// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryEntityImpl _$$CategoryEntityImplFromJson(Map<String, dynamic> json) =>
    _$CategoryEntityImpl(
      clientGeneratedId: json['client_generated_id'] as String?,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
      slug: json['slug'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastSyncedAt: json['last_synced_at'] as String?,
      syncState: json['sync_state'] == null
          ? null
          : SyncStateDto.fromJson(json['sync_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CategoryEntityImplToJson(
        _$CategoryEntityImpl instance) =>
    <String, dynamic>{
      'client_generated_id': instance.clientGeneratedId,
      'type': _$CategoryTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'slug': instance.slug,
      'user_id': instance.userId,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt,
      'sync_state': instance.syncState?.toJson(),
    };

const _$CategoryTypeEnumMap = {
  CategoryType.income: 'income',
  CategoryType.expense: 'expense',
  CategoryType.invoice: 'invoice',
};
