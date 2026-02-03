import 'package:json_annotation/json_annotation.dart';

part 'media_file_dto.g.dart';

/// API shape for media file (e.g. files[] in transaction response).
@JsonSerializable()
class MediaFileDto {
  final int? id;
  final String path;
  final String? type;
  @JsonKey(name: 'fileable_type')
  final String? fileableType;
  @JsonKey(name: 'fileable_id')
  final int? fileableId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const MediaFileDto({
    this.id,
    required this.path,
    this.type,
    this.fileableType,
    this.fileableId,
    this.createdAt,
    this.updatedAt,
  });

  factory MediaFileDto.fromJson(Map<String, dynamic> json) =>
      _$MediaFileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFileDtoToJson(this);
}
