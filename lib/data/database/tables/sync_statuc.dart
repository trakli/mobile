import 'package:drift/drift.dart';

@DataClassName('SyncMetadatas')
class SyncMetadata extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get lastReceivedChangeId => text().nullable()();
}
