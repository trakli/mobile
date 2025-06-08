import 'package:equatable/equatable.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/presentation/utils/enums.dart';

class MediaEntity extends Equatable {
  final String image;
  final MediaType mediaType;

  const MediaEntity({required this.image, required this.mediaType});

  factory MediaEntity.fromModel(Media media) =>
      MediaEntity(image: media.image, mediaType: media.mediaType);

  @override
  List<Object?> get props => [image, mediaType];
}
