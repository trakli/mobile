import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:uuid/uuid.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category> insertCategory(
    String name,
    String slug,
    TransactionType type,
    int userId, {
    String? description,
  });
  Future<Category> updateCategory(
    String clientId, {
    String? name,
    String? slug,
    TransactionType? type,
    int? userId,
    String? description,
  });
  Future<Category> deleteCategory(String clientId);
  Stream<List<Category>> listenToCategories();
}

@Injectable(as: CategoryLocalDataSource)
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this.database);
  final AppDatabase database;

  @override
  Future<List<Category>> getAllCategories() async {
    return await database.select(database.categories).get();
  }

  @override
  Future<Category> insertCategory(
      String name, String slug, TransactionType type, int userId,
      {String? description}) async {
    final now = DateTime.now();
    DateTime dateTime = formatServerIsoDateTime(now);

    final model = await database.into(database.categories).insertReturning(
          CategoriesCompanion.insert(
            clientId: const Uuid().v4(),
            name: name,
            slug: slug,
            type: type,
            userId: userId,
            description: Value(description),
            createdAt: Value(dateTime),
            updatedAt: Value(dateTime),
          ),
        );
    return model;
  }

  @override
  Future<Category> updateCategory(String clientId,
      {String? name,
      String? slug,
      TransactionType? type,
      int? userId,
      String? description}) async {
    final model = await (database.update(database.categories)
          ..where((c) => c.clientId.equals(clientId)))
        .writeReturning(
      CategoriesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        slug: slug != null ? Value(slug) : const Value.absent(),
        type: type != null ? Value(type) : const Value.absent(),
        userId: userId != null ? Value(userId) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
      ),
    );
    return model.first;
  }

  @override
  Future<Category> deleteCategory(String clientId) async {
    final model = await (database.select(database.categories)
          ..where((c) => c.clientId.equals(clientId)))
        .getSingle();
    await database.delete(database.categories).delete(model);
    return model;
  }

  @override
  Stream<List<Category>> listenToCategories() {
    return database.select(database.categories).watch();
  }
}
