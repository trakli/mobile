import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/parties.dart';
import 'package:trakli/data/datasources/party/party_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PartySyncHandler extends SyncTypeHandler<Party, String, int>
    with RestSyncTypeHandler<Party, String, int> {
  PartySyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final PartyRemoteDataSource remoteDataSource;

  TableInfo<Parties, Party> get table => db.parties;

  @override
  String get entityType => 'party';

  @override
  String getRev(Party entity) => entity.rev ?? '1';

  @override
  Future<Party> unmarshal(Map<String, dynamic> entityJson) async {
    return Party.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Party entity) {
    return entity.toJson();
  }

  @override
  bool shouldPersistRemote(Party entity) => true;

  @override
  Future<List<Party>> restGetAllRemote() async {
    return remoteDataSource.getAllParties();
  }

  @override
  Future<Party> restPutRemote(Party entity) async {
    if (entity.id == null) {
      return remoteDataSource.insertParty(entity);
    } else {
      return await remoteDataSource.updateParty(entity);
    }
  }

  @override
  Future<Party?> restGetRemote(int id) async {
    return await remoteDataSource.getParty(id);
  }

  @override
  Future<void> restDeleteRemote(Party entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteParty(entity.id!);
    }
  }

  @override
  Future<void> deleteLocal(Party entity) async {
    await table.deleteOne(entity);
  }

  @override
  Future<void> upsertLocal(Party entity) async {
    await table.insertOne(entity, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Party> list) async {
    await table.insertAll(list, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  String getClientId(Party entity) {
    return entity.clientId;
  }

  @override
  Future<Party> getLocalByClientId(String clientId) async {
    final result = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .get();
    return result.first;
  }

  @override
  Future<Party?> getLocalByServerId(int serverId) async {
    final result = await (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();

    return result;
  }

  @override
  int? getServerId(Party entity) {
    return entity.id;
  }
}
