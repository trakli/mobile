import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/domain/entities/config_entity.dart';

@DataClassName('Config')
class Configs extends Table with SyncTable {
  TextColumn get key => text().unique()();
  TextColumn get type => textEnum<ConfigType>()();
  TextColumn get value => text().map(const ConfigValueConverter())();
}

class ConfigValueConverter extends TypeConverter<dynamic, String> {
  const ConfigValueConverter();

  @override
  dynamic fromSql(String fromDb) {
    try {
      return jsonDecode(fromDb);
    } catch (e) {
      return fromDb; // Return as string if not valid JSON
    }
  }

  @override
  String toSql(dynamic value) {
    if (value is String) {
      return value;
    }
    return jsonEncode(value);
  }
}
