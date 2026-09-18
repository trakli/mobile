import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/name_matching.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/core/error/exceptions.dart';

abstract class GroupLocalDataSource {
  Future<List<Group>> getAllGroups();
  Future<Group?> getGroup(String clientId);
  Future<Group> insertGroup(
    String name, {
    String? description,
    Media? icon,
  });
  Future<Group> updateGroup(
    String clientId, {
    String? name,
    String? description,
    Media? icon,
  });
  Future<void> deleteGroup(String clientId);
  Stream<List<Group>> listenToGroups();
}

@Injectable(as: GroupLocalDataSource)
class GroupLocalDataSourceImpl implements GroupLocalDataSource {
  final AppDatabase database;

  GroupLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<Group>> getAllGroups() async {
    return (database.select(database.groups)
          ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
        .get();
  }

  /// The same name is the same group, case and surrounding spaces aside.
  Future<Group?> _findByServerName(String name, {String? excluding}) async {
    final rows = await database.select(database.groups).get();
    return firstMatchingName(
      rows,
      name,
      nameOf: (row) => row.name,
      clientIdOf: (row) => row.clientId,
      excluding: excluding,
    );
  }

  @override
  Future<Group> insertGroup(
    String name, {
    String? description,
    Media? icon,
  }) async {
    final existing = await _findByServerName(name);
    if (existing != null) {
      throw DuplicateException('Group with name "$name" already exists');
    }

    final dateTime = getNewFormattedUtcDateTime();

    final companion = GroupsCompanion.insert(
      clientId: Value(await generateDeviceScopedId()),
      name: name.trim(),
      description: Value(description),
      createdAt: Value(dateTime),
      updatedAt: Value(dateTime),
      icon: Value(icon),
    );

    final model =
        await database.into(database.groups).insertReturning(companion);
    return model;
  }

  @override
  Future<Group> updateGroup(
    String clientId, {
    String? name,
    String? description,
    Media? icon,
  }) async {
    if (name != null) {
      final existing = await _findByServerName(name, excluding: clientId);
      if (existing != null) {
        throw DuplicateException('Group with name "$name" already exists');
      }
    }

    DateTime dateTime = getNewFormattedUtcDateTime();

    final companion = GroupsCompanion(
      name: name != null ? Value(name.trim()) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      updatedAt: Value(dateTime),
      icon: icon != null ? Value(icon) : const Value.absent(),
    );

    final model = await (database.update(database.groups)
          ..where((tbl) => tbl.clientId.equals(clientId)))
        .writeReturning(companion);

    return model.first;
  }

  @override
  Future<void> deleteGroup(String clientId) async {
    final query = database.delete(database.groups)
      ..where((tbl) => tbl.clientId.equals(clientId));
    await query.go();
  }

  @override
  Stream<List<Group>> listenToGroups() {
    return (database.select(database.groups)
          ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
        .watch();
  }

  @override
  Future<Group?> getGroup(String clientId) async {
    final query = database.select(database.groups)
      ..where((tbl) => tbl.clientId.equals(clientId));
    return await query.getSingleOrNull();
  }
}
