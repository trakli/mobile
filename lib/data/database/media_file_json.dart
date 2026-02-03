import 'package:trakli/data/database/app_database.dart';

/// JSON helpers for [MediaFile] (sync pending change marshal/unmarshal).
MediaFile mediaFileFromJson(Map<String, dynamic> json) {
  return MediaFile(
    path: json['path'] as String,
    id: json['id'] as int?,
    type: json['type'] as String?,
    fileableType: json['fileableType'] as String?,
    fileableId: json['fileableId'] as int?,
    localFileableType: json['localFileableType'] as String?,
    localFileableId: json['localFileableId'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
  );
}

Map<String, dynamic> mediaFileToJson(MediaFile file) {
  return <String, dynamic>{
    'path': file.path,
    'id': file.id,
    'type': file.type,
    'fileableType': file.fileableType,
    'fileableId': file.fileableId,
    'localFileableType': file.localFileableType,
    'localFileableId': file.localFileableId,
    'createdAt': file.createdAt?.toIso8601String(),
    'updatedAt': file.updatedAt?.toIso8601String(),
  };
}
