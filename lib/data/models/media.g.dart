// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'image': instance.image,
    };

const _$MediaTypeEnumMap = {
  MediaType.emoji: 'emoji',
  MediaType.image: 'image',
  MediaType.icon: 'icon',
};
