import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class MediaFileRemoteDataSource {
  /// Media files are not listed on their own; they come with transactions.
  /// Returns empty list so sync has nothing to upsert from this endpoint.
  Future<List<MediaFile>> getAllMediaFiles({
    bool? noClientId,
    DateTime? syncedSince,
  });

  Future<MediaFile?> getMediaFile(int id);

  /// Fetches file content for viewing. GET /files/{id} (authenticated).
  /// Returns raw bytes
  Future<Uint8List> getFileContent(int id);
}

@Injectable(as: MediaFileRemoteDataSource)
class MediaFileRemoteDataSourceImpl implements MediaFileRemoteDataSource {
  final Dio dio;

  MediaFileRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MediaFile>> getAllMediaFiles({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return [];
  }

  @override
  Future<MediaFile?> getMediaFile(int id) async {
    return null;
  }

  @override
  Future<Uint8List> getFileContent(int id) async {
    final response = await dio.get<List<int>>(
      'files/$id',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? []);
  }
}
