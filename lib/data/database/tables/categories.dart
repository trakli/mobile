import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('Category')
class Categories extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => textEnum<CategoryType>()();
  IntColumn get userId => integer()();
}
