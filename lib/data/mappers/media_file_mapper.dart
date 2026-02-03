import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/media_file/dto/media_file_dto.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';

class MediaFileMapper {
  static MediaFileEntity toDomain(MediaFileDto dto) {
    return MediaFileEntity(path: dto.path, id: dto.id);
  }

  static List<MediaFileEntity> toDomainList(List<MediaFileDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static MediaFileEntity toDomainFromRow(MediaFile row) {
    return MediaFileEntity(path: row.path, id: row.id);
  }

  static List<MediaFileEntity> toDomainListFromRows(List<MediaFile> rows) {
    return rows.map((row) => toDomainFromRow(row)).toList();
  }
}
