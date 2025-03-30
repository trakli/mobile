import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

enum DataSource { remote, local }

enum DataDestination { local, both }

/// Provides methods to get, create, update and delete
/// entities of type <TEntity>.
///
/// Each of these
/// methods works by attempting to first use
/// online data with the fallback of the offline data.
abstract class SyncEntityRepository<
  TAppDatabase extends SynchronizerDb,
  TEntity,
  TKey
> {
  const SyncEntityRepository({required this.syncHandler, required this.db});

  final SyncTypeHandler<TEntity, TKey> syncHandler;
  final TAppDatabase db;

  Future<(TEntity, DataSource)> get(TKey id) async {
    final remote = await getRemote(id);

    if (remote != null) {
      await syncHandler.upsertLocal(remote);
      return (remote, DataSource.remote);
    }

    final local = await syncHandler.getLocal(id);
    return (local, DataSource.local);
  }

  @protected
  Future<TEntity?> getRemote(TKey id) async {
    try {
      final e = await syncHandler.getRemote(id);
      return e;
    } on UnavailableException catch (_) {
      return null;
    }
  }

  Future<(TEntity, DataDestination)> put(TEntity entity) async {
    final remoteCreated = await putRemote(entity);
    final created = remoteCreated ?? entity;

    final ds =
        remoteCreated == null ? DataDestination.local : DataDestination.both;

    await this.db.transaction(() async {
      await syncHandler.upsertLocal(created);
      
      if (remoteCreated == null) {
        final localChange = PendingLocalChange.put(
          protoBytes: syncHandler.marshal(entity),
          entityType: syncHandler.entityType,
          entityId: syncHandler.getId(entity),
          entityRev: syncHandler.getRev(entity),
        );
        await db.insertLocalChange(localChange);
      } else {
        await db.concludeEntityLocalChanges(
          syncHandler.entityType,
          syncHandler.getId(entity),
        );
      }
    });

    return (created, ds);
  }

  /// Tries to update remotely.
  /// Returns:
  /// - The updated entity if succeed
  /// - null if unavailable
  /// throws if any other exception
  @protected
  Future<TEntity?> putRemote(TEntity entity) async {
    try {
      final created = await syncHandler.putRemote(entity);
      return created;
    } on UnavailableException catch (_) {
      return null;
    }
  }

  Future<DataDestination> delete(TEntity entity) async {
    final synced = await deleteRemote(entity);
    final ds = synced ? DataDestination.both : DataDestination.local;

    await db.transaction(() async {
      await syncHandler.deleteLocal(entity);
      if (!synced) {
        final localChange = PendingLocalChange.delete(
          entityType: syncHandler.entityType,
          data: syncHandler.marshal(entity),
          entityId: syncHandler.getId(entity),
          entityRev: syncHandler.getRev(entity),
        );
        await db.insertLocalChange(localChange);
      } else {
        await db.concludeEntityLocalChanges(
          syncHandler.entityType,
          syncHandler.getId(entity),
        );
      }
    });

    return ds;
  }

  // Tries to delete the entity remotely
  // Returns:
  // - true if succeeded
  // - false if unavailable
  // throws if any other exception
  Future<bool> deleteRemote(TEntity entity) async {
    try {
      await syncHandler.deleteRemote(entity);
      return true;
    } on UnavailableException catch (_) {
      return false;
    }
  }
}
