import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/local_changes.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Notification')
class Notifications extends Table with SyncTable {
  TextColumn get type => textEnum<NotificationType>()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get data => text().map(const JsonMapConverter())();
  @JsonKey('read_at')
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {clientId};
}
