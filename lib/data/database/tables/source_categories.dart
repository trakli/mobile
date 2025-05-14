import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('SourceCategory')
class SourceCategories extends Table {
  // The ID of the source (transaction, invoice, etc.)
  TextColumn get sourceId => text()();

  // The type of the source (transaction, invoice, category)
  TextColumn get sourceType => textEnum<SourceType>()();

  // Reference to the category
  TextColumn get categoryClientId => text().references(Categories, #clientId)();

  @override
  Set<Column> get primaryKey => {sourceId, sourceType, categoryClientId};
}
