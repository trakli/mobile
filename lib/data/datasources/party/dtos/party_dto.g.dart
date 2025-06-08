// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartyDtoImpl _$$PartyDtoImplFromJson(Map<String, dynamic> json) =>
    _$PartyDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      clientId: json['client_generated_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: (json['userId'] as num).toInt(),
      media: json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PartyDtoImplToJson(_$PartyDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'client_generated_id': instance.clientId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      'media': instance.media?.toJson(),
    };
