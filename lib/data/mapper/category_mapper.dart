import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/domain/entities/category_entity.dart';

class CategoryMapper {
  static CategoryEntity toDomain(db.Category c) {
    return CategoryEntity(
      id: c.id,
      name: c.name,
      slug: c.slug,
      type: c.type,
      userId: c.userId,
      description: c.description,
      clientId: c.clientId,
      createdAt: c.createdAt,
      updatedAt: null,
      lastSyncedAt: null,
      syncState: null,
    );
  }

  static List<CategoryEntity> toDomainList(List<db.Category> categories) {
    return categories.map((c) => toDomain(c)).toList();
  }
}
