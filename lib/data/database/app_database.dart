import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:trakli/data/database/converters/media_converter.dart';
import 'package:trakli/data/database/converters/wallet_stats_converter.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/data/database/tables/groups.dart';
import 'package:trakli/data/database/tables/local_changes.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/database/tables/parties.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/tables/transactions.dart';
import 'package:trakli/data/database/tables/users.dart';
import 'package:trakli/data/database/tables/wallets.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/models/wallet_stats.dart';
import 'dart:io';
import 'tables/sync_meta_data.dart';
import 'package:trakli/data/database/tables/categorizables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Transactions,
  Parties,
  Categories,
  Users,
  Groups,
  Wallets,
  LocalChanges,
  SyncMetadata,
  Categorizables,
])
class AppDatabase extends _$AppDatabase with SynchronizerDb {
  final Set<SyncTypeHandler> typeHandlers;

  AppDatabase([
    QueryExecutor? executor,
    Set<SyncTypeHandler>? typeHandlers,
  ])  : typeHandlers = typeHandlers ?? {},
        super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'trakli.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  Future<List<PendingLocalChange>> getPendingLocalChanges() async {
    final rows =
        await (select(localChanges)..where((lc) => lc.error.isNull())).get();

    return rows
        .map((row) => PendingLocalChange(
              entityType: row.entityType,
              entityId: row.entityId,
              entityRev: row.entityRev,
              deleted: row.deleted,
              data: row.data,
              createMoment: row.createAt,
              concluded: row.concluded,
              concludedMoment: row.concludedMoment,
              error: row.error,
              dismissed: row.dismissed,
            ))
        .toList();
  }

  @override
  Future<void> cancelAllLocalChanges() async {
    await delete(localChanges).go();
  }

  Future<List<Category>> getCategoriesForTransaction(
      String transactionId, CategorizableType sourceType) async {
    final query = select(categories).join([
      innerJoin(
        categorizables,
        categorizables.categoryClientId.equalsExp(categories.clientId),
      )
    ])
      ..where(categorizables.categorizableId.equals(transactionId) &
          categorizables.categorizableType.equals(sourceType.name));

    final results = await query.get();
    return results.map((row) => row.readTable(categories)).toList();
  }

  @override
  Future<void> concludeEntityLocalChanges(
    String entityType,
    int? entityId,
    Operation operation,
  ) async {
    logger.i(
      "${operation.name.toUpperCase()} operations on enity type $entityType for object $entityId completed",
    );
  }

  @override
  Future<void> concludeLocalChange(PendingLocalChange localChange,
      {Object? error, bool persistedToRemote = false}) async {
    if (error != null) {
      await (update(localChanges)
            ..where((lc) => lc.entityId.equals(localChange.entityId)))
          .write(
        LocalChangesCompanion(
          concludedMoment: Value(DateTime.now()),
          error: Value(error.toString()),
          concluded: const Value(true),
        ),
      );
    }

    if (persistedToRemote) {
      // Remove the local change after successful sync
      await (delete(localChanges)
            ..where((lc) =>
                lc.entityType.equals(localChange.entityType) &
                lc.entityId.equals(localChange.entityId)))
          .go();
    } else {
      logger.info(
          "Cannot conclude sync for ${localChange.entityType} with id ${localChange.entityId}");
    }
  }

  @override
  Future<void> insertLocalChange(PendingLocalChange pendingLocalChange) async {
    final localChange = LocalChangesCompanion(
      entityType: Value(pendingLocalChange.entityType),
      entityId: Value(pendingLocalChange.entityId),
      entityRev: Value(pendingLocalChange.entityRev),
      data: Value(pendingLocalChange.data),
      createAt: Value(pendingLocalChange.createMoment),
      dismissed: Value(pendingLocalChange.dismissed),
      concluded: Value(pendingLocalChange.concluded),
      concludedMoment: Value(pendingLocalChange.concludedMoment),
      error: Value(pendingLocalChange.error),
      deleted: Value(pendingLocalChange.deleted),
    );

    await into(localChanges).insert(
      localChange,
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<Wallet?> getWalletForTransaction(String clientId) async {
    final query = select(wallets).join([
      innerJoin(
        transactions,
        transactions.walletClientId.equalsExp(wallets.clientId),
      )
    ])
      ..where(transactions.clientId.equals(clientId));

    final results = await query.getSingleOrNull();
    return results?.readTable(wallets);
  }

  Future<Party?> getPartyForTransaction(String clientId) async {
    final query = select(parties).join([
      innerJoin(
        transactions,
        transactions.partyClientId.equalsExp(parties.clientId),
      )
    ])
      ..where(transactions.clientId.equals(clientId));

    final results = await query.getSingleOrNull();
    return results?.readTable(parties);
  }

  Future<Group?> getGroupForTransaction(String clientId) async {
    final query = select(groups).join([
      innerJoin(
        transactions,
        transactions.groupClientId.equalsExp(groups.clientId),
      )
    ])
      ..where(transactions.clientId.equals(clientId));

    final results = await query.getSingleOrNull();
    return results?.readTable(groups);
  }

  @override
  Future<LocalSyncMetadata?> getLocalSyncMetadata(String entityType) async {
    final row = await (select(syncMetadata)
          ..where((t) => t.entityType.equals(entityType)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }

    return LocalSyncMetadata(
      entityType: row.entityType,
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  @override
  Future<List<LocalSyncMetadata>> getLocalSyncMetadataList() async {
    final rows = await select(syncMetadata).get();
    return rows
        .map((row) => LocalSyncMetadata(
              entityType: row.entityType,
              lastSyncedAt: row.lastSyncedAt,
            ))
        .toList();
  }

  @override
  Future<void> updateEnityLocalSyncMetadata(
      {required String entityType, DateTime? lastSyncedAt}) async {
    final time = lastSyncedAt?.add(
          const Duration(seconds: 2),
        ) ??
        DateTime.now().add(
          const Duration(seconds: 2),
        );

    await into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion(
        entityType: Value(entityType),
        lastSyncedAt: Value(time),
      ),
    );
  }

  @override
  Future<void> clearDatabase() async {
    await users.deleteAll();
    await transactions.deleteAll();
    await categories.deleteAll();
    await parties.deleteAll();
    await groups.deleteAll();
    await wallets.deleteAll();
    await localChanges.deleteAll();
    await syncMetadata.deleteAll();
    await categorizables.deleteAll();
  }
}
