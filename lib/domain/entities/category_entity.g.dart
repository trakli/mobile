// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryEntityImpl _$$CategoryEntityImplFromJson(Map<String, dynamic> json) =>
    _$CategoryEntityImpl(
      clientGeneratedId: json['clientGeneratedId'] as String?,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: (json['id'] as num?)?.toInt(),
      slug: json['slug'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] as String?,
      syncState: json['syncState'] == null
          ? null
          : SyncStateDto.fromJson(json['syncState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CategoryEntityImplToJson(
        _$CategoryEntityImpl instance) =>
    <String, dynamic>{
      'clientGeneratedId': instance.clientGeneratedId,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'id': instance.id,
      'slug': instance.slug,
      'userId': instance.userId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt,
      'syncState': instance.syncState?.toJson(),
    };
