import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('Party')
class Parties extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
}
