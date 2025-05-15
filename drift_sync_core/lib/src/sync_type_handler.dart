import 'dart:async';

abstract class SyncTypeHandler<TEntity, TKey, TServerKey> {
  String get entityType;

  // Get the client ID (string) from an entity
  String getClientId(TEntity entity);

  // Get the server ID (int) from an entity
  int? getServerId(TEntity entity);

  // Get the revision from an entity
  String getRev(TEntity entity);

  //Future<TEntity> getLocal(TKey id);
  // Get entity by client ID
  Future<TEntity> getLocalByClientId(TKey clientId);

  // Get entity by server ID
  Future<TEntity?> getLocalByServerId(TServerKey serverId);

  Future<void> upsertLocal(TEntity entity);
  Future<void> upsertAllLocal(List<TEntity> list);

  Future<void> deleteLocal(TEntity entity);
  Future<void> deleteAllLocal();

  // Get remote entity by server ID
  //Future<TEntity?> getRemote(TKey id);
  Future<TEntity?> getRemote(TServerKey serverId);
  Future<List<TEntity>> getAllRemote();
  Future<TEntity> putRemote(TEntity entity);
  Future<void> deleteRemote(TEntity entity);

  Future<TEntity> unmarshal(Map<String, dynamic> entityBytes);
  Map<String, dynamic> marshal(TEntity entity);

  bool shouldPersistRemote(TEntity entity);
}

// Helper typedefs for clarity
typedef StringSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, String, int>;
typedef IntSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, int, int>;
