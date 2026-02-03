// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFileDto _$MediaFileDtoFromJson(Map<String, dynamic> json) => MediaFileDto(
      id: (json['id'] as num?)?.toInt(),
      path: json['path'] as String,
      type: json['type'] as String?,
      fileableType: json['fileable_type'] as String?,
      fileableId: (json['fileable_id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MediaFileDtoToJson(MediaFileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'type': instance.type,
      'fileable_type': instance.fileableType,
      'fileable_id': instance.fileableId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
