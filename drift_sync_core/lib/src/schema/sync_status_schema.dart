import 'package:drift/drift.dart';

class SyncStatus extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get lastReceivedChangeId => text().nullable()();
}
