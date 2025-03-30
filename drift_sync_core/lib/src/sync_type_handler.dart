import 'dart:async';
import 'dart:typed_data';

abstract class SyncTypeHandler<TEntity, TKey> {
  String get entityType;

  String getId(TEntity entity);
  String getRev(TEntity entity);

  Future<TEntity> getLocal(TKey id);

  Future<void> upsertLocal(TEntity entity);
  Future<void> upsertAllLocal(List<TEntity> list);

  Future<void> deleteLocal(TEntity entity);
  Future<void> deleteAllLocal();

  Future<TEntity?> getRemote(TKey id);
  Future<List<TEntity>> getAllRemote();
  Future<TEntity> putRemote(TEntity entity);
  Future<void> deleteRemote(TEntity entity);

  TEntity unmarshal(Map<String, dynamic> entityBytes);
  Map<String, dynamic> marshal(TEntity entity);
}

typedef StringSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, String>;
typedef IntSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, int>;
