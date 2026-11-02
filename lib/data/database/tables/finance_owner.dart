import 'package:drift/drift.dart';

mixin FinanceOwner on Table {
  @JsonKey('owner_type')
  TextColumn get ownerType => text().nullable()();

  @JsonKey('owner_id')
  IntColumn get ownerId => integer().nullable()();
}
