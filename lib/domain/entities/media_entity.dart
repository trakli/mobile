import 'package:equatable/equatable.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/presentation/utils/enums.dart';

class MediaEntity extends Equatable {
  final String? content;
  final MediaType mediaType;

  const MediaEntity({
    required this.mediaType,
    this.content,
  });

  factory MediaEntity.fromModel(Media media) => MediaEntity(
        content: media.content,
        mediaType: media.type,
      );

  @override
  List<Object?> get props => [content, mediaType];
}
