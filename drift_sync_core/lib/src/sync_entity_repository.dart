import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

enum DataSource { remote, local }

enum Operation { put, delete }

enum DataDestination { local, both }

/// Provides methods to get, create, update and delete
/// entities of type TEntity.
///
/// Each of these
/// methods works by attempting to first use
/// online data with the fallback of the offline data.
abstract class SyncEntityRepository<TAppDatabase extends SynchronizerDb,
    TEntity, TKey, TServerKey> {
  const SyncEntityRepository({required this.syncHandler, required this.db});

  final SyncTypeHandler<TEntity, TKey, TServerKey> syncHandler;
  final TAppDatabase db;

  // Future<(TEntity, DataSource)> get(TKey id) async {
  //   final remote = await getRemote(id);

  //   if (remote != null) {
  //     await syncHandler.upsertLocal(remote);
  //     return (remote, DataSource.remote);
  //   }

  //   final local = await syncHandler.getLocalByClientId(id);
  //   return (local, DataSource.local);
  // }

  @protected
  Future<TEntity?> getRemote(TServerKey id) async {
    try {
      return await syncHandler.getRemote(id);
    } on UnavailableException {
      return null;
    }
  }

  Future<(TEntity, DataDestination)> put(TEntity entity) async {
    final serverId = syncHandler.getServerId(entity);
    final remoteCreated = serverId != null ? await putRemote(entity) : null;
    final created = remoteCreated ?? entity;
    final ds =
        remoteCreated == null ? DataDestination.local : DataDestination.both;

    await _handleLocalStorage(entity, remoteCreated);
    return (created, ds);
  }

  Future<(TEntity, DataDestination)> post(TEntity entity) async {
    final remoteCreated = await putRemote(entity);
    final created = remoteCreated ?? entity;
    final ds =
        remoteCreated == null ? DataDestination.local : DataDestination.both;

    await _handleLocalStorage(created, remoteCreated);
    return (created, ds);
  }

  Future<void> _handleLocalStorage(
      TEntity entity, TEntity? remoteCreated) async {
    await db.transaction(() async {
      if (remoteCreated == null) {
        await _createPendingChange(entity);
      } else {
        await _concludeEntityChanges(entity);
      }
    });
  }

  Future<void> _createPendingChange(TEntity entity) async {
    final localChange = PendingLocalChange.put(
      protoBytes: syncHandler.marshal(entity),
      entityType: syncHandler.entityType,
      entityId: syncHandler.getClientId(entity),
      entityRev: syncHandler.getRev(entity),
    );
    await db.insertLocalChange(localChange);
  }

  Future<void> _concludeEntityChanges(TEntity entity) async {
    await db.concludeEntityLocalChanges(
      syncHandler.entityType,
      syncHandler.getServerId(entity),
      Operation.put,
    );
    await syncHandler.upsertLocal(entity);
  }

  @protected
  Future<TEntity?> putRemote(TEntity entity) async {
    try {
      return await syncHandler.putRemote(entity);
    } on UnavailableException {
      return null;
    }
  }

  Future<DataDestination> delete(TEntity entity) async {
    final synced = await deleteRemote(entity);
    final ds = synced ? DataDestination.both : DataDestination.local;

    await _handleDeleteStorage(entity, synced);
    return ds;
  }

  Future<void> _handleDeleteStorage(TEntity entity, bool synced) async {
    await db.transaction(() async {
      await syncHandler.deleteLocal(entity);
      if (!synced) {
        await _createDeletePendingChange(entity);
      } else {
        await _concludeDeleteChanges(entity);
      }
    });
  }

  Future<void> _createDeletePendingChange(TEntity entity) async {
    final localChange = PendingLocalChange.delete(
      entityType: syncHandler.entityType,
      data: syncHandler.marshal(entity),
      entityId: syncHandler.getClientId(entity),
      entityRev: syncHandler.getRev(entity),
    );
    await db.insertLocalChange(localChange);
  }

  Future<void> _concludeDeleteChanges(TEntity entity) async {
    await db.concludeEntityLocalChanges(
      syncHandler.entityType,
      syncHandler.getServerId(entity),
      Operation.delete,
    );
  }

  Future<bool> deleteRemote(TEntity entity) async {
    try {
      await syncHandler.deleteRemote(entity);
      return true;
    } on UnavailableException {
      return false;
    }
  }
}
