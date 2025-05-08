import 'package:drift/drift.dart';

mixin SyncTable on Table {
  // Server ID (nullable since it's assigned by the server)
  IntColumn get id => integer().nullable()();

  // Client ID (required, generated locally)
  @JsonKey(
    'client_generated_id',
  )
  TextColumn get clientId => text()();

  // Add any common columns needed for sync
  TextColumn get rev => text().withDefault(const Constant('1')).nullable()();

  // @JsonKey(name: 'created_at', fromJson: dateTimeFromString)
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @JsonKey(
    'last_synced_at',
  )
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {clientId};

  // You can add other common sync columns if needed
  // DateTimeColumn get lastUpdated => dateTime().nullable()();
}
