import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigLocalDataSource {
  Future<List<Config>> getAllConfigs();
  Future<Config?> getConfigByKey(String key);
  Future<Config> insertConfig({
    required String key,
    required ConfigType type,
    required dynamic value,
    int? userId,
  });
  Future<Config> updateConfig(
    String key, {
    ConfigType? type,
    dynamic value,
  });
  Future<void> deleteConfig(String key);
  Stream<List<Config>> listenToConfigs();
}

@Injectable(as: ConfigLocalDataSource)
class ConfigLocalDataSourceImpl implements ConfigLocalDataSource {
  final AppDatabase database;

  ConfigLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<Config>> getAllConfigs() async {
    return (database.select(database.configs)
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
  }

  @override
  Future<Config?> getConfigByKey(String key) async {
    final query = database.select(database.configs)
      ..where((tbl) => tbl.key.equals(key));
    return await query.getSingleOrNull();
  }

  @override
  Future<Config> insertConfig({
    required String key,
    required ConfigType type,
    required dynamic value,
    int? userId,
  }) async {
    final now = DateTime.now();
    final dateTime = formatServerIsoDateTime(now);

    final companion = ConfigsCompanion.insert(
      clientId: Value(await generateDeviceScopedId()),
      key: key,
      type: type,
      value: value,
      userId: Value(userId),
      createdAt: Value(dateTime),
      updatedAt: Value(dateTime),
    );

    final model =
        await database.into(database.configs).insertReturning(companion);
    return model;
  }

  @override
  Future<Config> updateConfig(
    String key, {
    ConfigType? type,
    dynamic value,
  }) async {
    final now = DateTime.now();
    final dateTime = formatServerIsoDateTime(now);

    final companion = ConfigsCompanion(
      type: type != null ? Value(type) : const Value.absent(),
      value: value != null ? Value(value) : const Value.absent(),
      updatedAt: Value(dateTime),
    );

    final model = await (database.update(database.configs)
          ..where((tbl) => tbl.key.equals(key)))
        .writeReturning(companion);

    return model.first;
  }

  @override
  Future<void> deleteConfig(String key) async {
    final query = database.delete(database.configs)
      ..where((tbl) => tbl.key.equals(key));
    await query.go();
  }

  @override
  Stream<List<Config>> listenToConfigs() {
    return (database.select(database.configs)
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .watch();
  }
}
