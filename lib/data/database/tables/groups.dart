import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('Group')
class Groups extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
}
