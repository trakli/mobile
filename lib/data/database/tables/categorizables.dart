import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Categorizable')
class Categorizables extends Table {
  // The ID of the source (transaction, invoice, etc.)
  TextColumn get categorizableId => text()();

  // The type of the source (transaction, invoice, category)
  TextColumn get categorizableType => textEnum<CategorizableType>()();

  // Reference to the category
  TextColumn get categoryClientId => text().references(Categories, #clientId)();

  @override
  Set<Column> get primaryKey =>
      {categorizableId, categorizableType, categoryClientId};
}
