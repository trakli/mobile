import 'package:drift/drift.dart';
import 'package:trakli/core/database/tables/shema.dart';

@DataClassName('Transaction')
class Transactions extends Table with SyncTable {
  TextColumn get id => text()();

  TextColumn get serverId => text().nullable()();

  @JsonKey('amount')
  RealColumn get amount => real()();

  @JsonKey('created_at_local')
  DateTimeColumn get createdAtLocal =>
      dateTime().withDefault(currentDateAndTime)();

  @JsonKey('updated_at_local')
  DateTimeColumn get updatedAtLocal =>
      dateTime().withDefault(currentDateAndTime)();

  @JsonKey('created_at_server')
  DateTimeColumn get createdAtServer => dateTime().nullable()();

  @JsonKey('updated_at_server')
  DateTimeColumn get updatedAtServer => dateTime().nullable()();

  TextColumn get category => text()();

  TextColumn get description => text().nullable()();

  @JsonKey('deleted_at_local')
  DateTimeColumn get deletedAtLocal => dateTime().nullable()();

  @JsonKey('last_synced_at')
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
