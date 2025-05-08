import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/data/datasources/category/category_remote_datasource.dart';

@lazySingleton
class CategorySyncHandler extends SyncTypeHandler<Category, String, int>
    with RestSyncTypeHandler<Category, String, int> {
  CategorySyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final CategoryRemoteDataSource remoteDataSource;

  TableInfo<Categories, Category> get table => db.categories;

  @override
  String get entityType => 'category';

  // @override
  // String getId(Category entity) => entity.clientId;

  @override
  String getRev(Category entity) => entity.rev ?? '1';

  // @override
  // Future<Category> getLocal(String id) async {
  //   final row = await (db.select(table)..where((t) => t.clientId.equals(id)))
  //       .getSingle();

  //   return Category(
  //     id: row.id,
  //     name: row.name,
  //     type: row.type.toString().split('.').last,
  //     description: row.description,
  //     clientGeneratedId: row.clientId,
  //     slug: row.slug,
  //     userId: row.userId,
  //     createdAt: row.createdAt,
  //     updatedAt: row.createdAt,
  //     lastSyncedAt: row.createdAt?.toIso8601String(),
  //   );
  // }

  @override
  Category unmarshal(Map<String, dynamic> entityJson) {
    return Category.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Category entity) {
    return entity.toJson();
  }

  @override
  Future<List<Category>> restGetAllRemote() async {
    return remoteDataSource.getAllCategories();
  }

  @override
  Future<Category?> restGetRemote(int id) async {
    return await remoteDataSource.getCategory(id);
  }

  @override
  Future<Category> restPutRemote(Category entity) async {
    if (entity.id == null) {
      return remoteDataSource.insertCategory(entity);
    } else {
      return await remoteDataSource.updateCategory(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Category entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteCategory(entity.id!);
    }
  }

  @override
  Future<void> deleteLocal(Category entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Category entity) async {
    final category = CategoriesCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      type: Value(entity.type),
      // Value(CategoryType.values.firstWhere(
      //   (e) => e.toString().split('.').last == entity.type,
      //   orElse: () => CategoryType.expense,
      // )),
      description: Value(entity.description),
      clientId: Value(entity.clientId),
      slug: Value(entity.slug),
      userId: Value(entity.userId),
      createdAt: Value(entity.createdAt),
    );
    await table.insertOne(category, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Category> list) async {
    final categories = list.map((entity) => CategoriesCompanion(
          id: Value(entity.id),
          name: Value(entity.name),
          type: Value(CategoryType.values.firstWhere(
            (e) => e.toString().split('.').last == entity.type,
            orElse: () => CategoryType.expense,
          )),
          description: Value(entity.description),
          clientId: Value(entity.clientId),
          slug: Value(entity.slug),
          userId: Value(entity.userId),
          createdAt: Value(entity.createdAt),
        ));
    await table.insertAll(categories, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  String getClientId(Category entity) => entity.clientId;

  @override
  Future<Category> getLocalByClientId(String clientId) async {
    try {
      return await getLocalByClientId(clientId);
    } catch (e) {
      throw Exception('Category not found');
    }
  }

  @override
  Future<Category?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
      return Category(
          id: row.id,
          name: row.name,
          type: row.type,
          clientId: row.clientId,
          slug: row.slug,
          userId: row.userId,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt
          // rev: row.rev,
          );
    } catch (e) {
      return null;
    }
  }

  @override
  int getServerId(Category entity) => entity.id ?? 0;
}
