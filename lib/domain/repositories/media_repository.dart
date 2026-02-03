import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';

abstract class MediaRepository {
  /// Fetches file content for viewing. GET /files/{id} (authenticated).
  /// Returns the path to the cached file (fetches and caches if needed).
  /// Extension for cache naming is derived from the local media row's path when present.
  Future<Either<Failure, String>> getFileContent(int id);

  /// Adds a media file to an existing transaction (creates local row and pending change for sync).
  /// [transactionClientId] is the transaction's client id.
  /// [filePath] is the path to the file (e.g. in app "media" directory).
  Future<Either<Failure, Unit>> addMediaToTransaction(
    String transactionClientId,
    String filePath,
  );

  /// Returns all media attached to a transaction (from local DB).
  Future<Either<Failure, List<MediaFileEntity>>> getMediaForTransaction(
    String transactionClientId,
  );

  /// Deletes a media by path (client id). Removes local row and creates a pending delete
  /// so the server is called on next sync (if the media had a server id).
  Future<Either<Failure, Unit>> deleteMediaByPath(String path);
}
