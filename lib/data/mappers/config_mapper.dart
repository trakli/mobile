import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/domain/entities/config_entity.dart';

class ConfigMapper {
  static ConfigEntity toDomain(db.Config c) {
    return ConfigEntity(
      id: c.id ?? 0,
      userId: c.userId ?? 0,
      key: c.key,
      type: c.type,
      value: c.value,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    );
  }

  static List<ConfigEntity> toDomainList(List<db.Config> configs) {
    return configs.map((c) => toDomain(c)).toList();
  }
}

