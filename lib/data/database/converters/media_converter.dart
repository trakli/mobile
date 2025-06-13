import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trakli/data/models/media.dart';

class MediaConverter extends TypeConverter<Media, String>
    with JsonTypeConverter2<Media, String, Map<String, Object?>> {
  const MediaConverter();

  @override
  Media fromSql(String fromDb) {
    return Media.fromJson(jsonDecode(fromDb));
  }

  @override
  String toSql(Media value) {
    return jsonEncode(value.toJson());
  }

  @override
  Media fromJson(Map<String, Object?> json) {
    return Media.fromJson(json);
  }

  @override
  Map<String, Object?> toJson(Media value) {
    return value.toJson();
  }
}
