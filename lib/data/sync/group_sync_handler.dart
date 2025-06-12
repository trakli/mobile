import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/groups.dart';
import 'package:trakli/data/datasources/group/group_remote_datasource.dart';

@lazySingleton
class GroupSyncHandler extends SyncTypeHandler<Group, String, int>
    with RestSyncTypeHandler<Group, String, int> {
  GroupSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final GroupRemoteDataSource remoteDataSource;

  TableInfo<Groups, Group> get table => db.groups;

  @override
  String get entityType => 'group';

  @override
  String getRev(Group entity) => entity.rev ?? '1';

  @override
  Future<Group> unmarshal(Map<String, dynamic> entityJson) async {
    return Group.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Group entity) {
    return entity.toJson();
  }

  @override
  bool shouldPersistRemote(Group entity) {
    return true;
  }

  @override
  Future<List<Group>> restGetAllRemote() async {
    return remoteDataSource.getAllGroups();
  }

  @override
  Future<Group?> restGetRemote(int id) async {
    return await remoteDataSource.getGroup(id.toString());
  }

  @override
  Future<Group> restPutRemote(Group entity) async {
    if (entity.id == null) {
      return remoteDataSource.insertGroup(entity);
    } else {
      return remoteDataSource.updateGroup(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Group entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteGroup(entity.clientId);
    }
  }

  @override
  Future<void> deleteLocal(Group entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Group entity) async {
    final group = GroupsCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      description: Value(entity.description),
      clientId: Value(entity.clientId),
      userId: Value(entity.userId),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      icon: Value(entity.icon),
    );

    await table.insertOne(group, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Group> list) async {
    final groups = list.map((entity) => GroupsCompanion(
          id: Value(entity.id),
          name: Value(entity.name),
          description: Value(entity.description),
          clientId: Value(entity.clientId),
          userId: Value(entity.userId),
          createdAt: Value(entity.createdAt),
          updatedAt: Value(entity.updatedAt),
          icon: Value(entity.icon),
        ));

    await table.insertAll(groups, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  String getClientId(Group entity) => entity.clientId;

  @override
  Future<Group> getLocalByClientId(String clientId) async {
    try {
      final row = await (db.select(table)
            ..where((t) => t.clientId.equals(clientId)))
          .getSingle();
      return Group(
        id: row.id,
        name: row.name,
        description: row.description,
        clientId: row.clientId,
        userId: row.userId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        icon: row.icon,
      );
    } catch (e) {
      throw Exception('Group not found');
    }
  }

  @override
  Future<Group?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
      return Group(
        id: row.id,
        name: row.name,
        description: row.description,
        clientId: row.clientId,
        userId: row.userId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        icon: row.icon,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  int? getServerId(Group entity) => entity.id;
}
