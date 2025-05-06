// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncStateDtoImpl _$$SyncStateDtoImplFromJson(Map<String, dynamic> json) =>
    _$SyncStateDtoImpl(
      id: (json['id'] as num).toInt(),
      syncableType: json['syncable_type'] as String,
      syncableId: (json['syncable_id'] as num).toInt(),
      source: json['source'] as String?,
      clientGeneratedId: json['client_generated_id'] as String,
      lastSyncedAt: json['last_synced_at'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SyncStateDtoImplToJson(_$SyncStateDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'syncable_type': instance.syncableType,
      'syncable_id': instance.syncableId,
      'source': instance.source,
      'client_generated_id': instance.clientGeneratedId,
      'last_synced_at': instance.lastSyncedAt,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
