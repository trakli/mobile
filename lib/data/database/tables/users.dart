import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get email => text().unique()();

  @JsonKey('first_name')
  TextColumn get firstName => text()();

  @JsonKey('last_name')
  TextColumn get lastName => text().nullable()();

  TextColumn get username => text().nullable()();

  TextColumn get phone => text().nullable()();
  // TextColumn get password => text()();
  TextColumn get avatar => text().nullable()();

  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime().nullable()();

  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
