import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'media.g.dart';

@JsonSerializable()
class Media {
  final int? id;
  final String? content;
  @JsonKey(name: 'type')
  final MediaType type;
  final String? image;

  Media({
    this.id,
    this.content,
    required this.type,
    this.image,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  factory Media.fromLocal({
    String? content,
    required MediaType type,
  }) =>
      Media(
        content: content,
        type: type,
      );

  factory Media.fromEntity(MediaEntity media) => Media(
        content: media.content,
        type: media.mediaType,
      );

  MediaEntity toEntity() => MediaEntity(
        content: content,
        mediaType: type,
      );
}
