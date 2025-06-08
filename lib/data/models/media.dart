import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'media.g.dart';

@JsonSerializable()
class Media {
  final String? id;
  final String image;
  @JsonKey(name: 'media_type')
  final MediaType mediaType;

  Media({
    this.id,
    required this.image,
    required this.mediaType,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  factory Media.fromLocal(
          {required String image, required MediaType mediaType}) =>
      Media(image: image, mediaType: mediaType);

  factory Media.fromEntity(MediaEntity media) =>
      Media(image: media.image, mediaType: media.mediaType);

  MediaEntity toEntity() => MediaEntity(image: image, mediaType: mediaType);
}
