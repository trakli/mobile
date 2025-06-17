import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/wallet/wallet_remote_datasource.dart';

@injectable
class WalletSyncHandler extends SyncTypeHandler<Wallet, String, int>
    with RestSyncTypeHandler<Wallet, String, int> {
  final WalletRemoteDataSource remoteDataSource;
  final AppDatabase db;

  WalletSyncHandler({
    required this.remoteDataSource,
    required this.db,
  });

  $WalletsTable get table => db.wallets;

  @override
  String get entityType => 'wallet';

  @override
  Future<List<Wallet>> restGetAllRemote() async {
    return await remoteDataSource.getAllWallets();
  }

  @override
  Future<Wallet?> restGetRemote(int id) async {
    return await remoteDataSource.getWallet(id);
  }

  @override
  Future<Wallet> restPutRemote(Wallet entity) async {
    if (entity.id == null) {
      return await remoteDataSource.insertWallet(entity);
    } else {
      return await remoteDataSource.updateWallet(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Wallet entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteWallet(entity.id!);
    }
  }

  @override
  String getClientId(Wallet entity) => entity.clientId;

  @override
  int? getServerId(Wallet entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocal(Wallet entity) async {
    await (db.delete(table)..where((t) => t.clientId.equals(entity.clientId)))
        .go();
  }

  @override
  Future<Wallet> getLocalByClientId(String clientId) async {
    final wallet = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (wallet == null) {
      throw const NotFoundException(message: 'Wallet not found');
    }
    return wallet;
  }

  @override
  Future<Wallet?> getLocalByServerId(int serverId) async {
    return await (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();
  }

  @override
  Future<void> upsertLocal(Wallet entity) async {
    final companion = WalletsCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      type: Value(entity.type),
      balance: Value(entity.balance),
      currency: Value(entity.currency),
      description: Value(entity.description),
      clientId: Value(entity.clientId),
      userId: Value(entity.userId),
      rev: Value(entity.rev),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      lastSyncedAt: Value(entity.lastSyncedAt),
      stats: Value(entity.stats),
      icon: Value(entity.icon),
    );
    await table.insertOne(companion, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Wallet> entities) async {
    final companions = entities.map((entity) => WalletsCompanion(
          clientId: Value(entity.clientId),
          userId: Value(entity.userId),
          rev: Value(entity.rev),
          createdAt: Value(entity.createdAt),
          updatedAt: Value(entity.updatedAt),
          lastSyncedAt: Value(entity.lastSyncedAt),
          id: Value(entity.id),
          name: Value(entity.name),
          type: Value(entity.type),
          balance: Value(entity.balance),
          currency: Value(entity.currency),
          description: Value(entity.description),
          stats: Value(entity.stats),
          icon: Value(entity.icon),
        ));
    await table.insertAll(companions, mode: InsertMode.insertOrReplace);
  }

  @override
  String getRev(Wallet entity) => entity.rev ?? '1';

  @override
  Map<String, dynamic> marshal(Wallet entity) => entity.toJson();

  @override
  bool shouldPersistRemote(Wallet entity) => true;

  @override
  Future<Wallet> unmarshal(Map<String, dynamic> data) async {
    return Wallet.fromJson(data);
  }
}
