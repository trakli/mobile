import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/converters/media_converter.dart';

@DataClassName('Group')
class Groups extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable().map(const MediaConverter())();
}
