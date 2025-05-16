import 'package:drift/drift.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('Category')
class Categories extends Table with SyncTable {
  TextColumn get name => text().unique()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => textEnum<TransactionType>()();

  @JsonKey('user_id')
  IntColumn get userId => integer()();
}
