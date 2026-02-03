import 'package:equatable/equatable.dart';

/// Lightweight entity for a media file (e.g. transaction attachment: path + optional server id).
class MediaFileEntity extends Equatable {
  final String path;
  final int? id;

  const MediaFileEntity({required this.path, this.id});

  /// File extension derived from [path] (e.g. "pdf", "jpg"), or "bin" if none.
  String get pathExtension =>
      path.contains('.') ? path.split('.').last.toLowerCase() : 'bin';

  /// Returns the expected cache file path when this media has a server [id].
  /// [cacheBaseDir] is the cache directory (e.g. from path_provider + "media/cache").
  String? cacheFilePath(String cacheBaseDir) =>
      id != null ? '$cacheBaseDir/file_$id.$pathExtension' : null;

  @override
  List<Object?> get props => [path, id];
}
