import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:trakli/core/database/tables/local_changes.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'dart:io';
import 'tables/transaction_table.dart';
import 'tables/sync_statuc.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Transactions, LocalChanges, SyncMetadata])
class AppDatabase extends _$AppDatabase with SynchronizerDb {
  final Set<SyncTypeHandler> typeHandlers;

  AppDatabase([
    QueryExecutor? executor,
    Set<SyncTypeHandler>? typeHandlers,
  ])  : typeHandlers = typeHandlers ?? {},
        super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

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

  @override
  Future<void> concludeEntityLocalChanges(
    String entityType,
    String entityId,
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
  Future<String?> getLastChangeId() async {
    final status = await (select(syncMetadata)..limit(1)).getSingleOrNull();
    return status?.lastReceivedChangeId;
  }

  @override
  Future<void> setLastReceivedChangeId(String? id) async {
    await into(syncMetadata).insertOnConflictUpdate(SyncMetadataCompanion(
      id: const Value(1),
      lastReceivedChangeId: Value(id),
    ));
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
}

// @DriftDatabase(tables: [Transactions])
// class AppDatabase extends _$AppDatabase with SynchronizerDb {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;

//   @override
//   List<TableInfo<Table, DataClass>> get allTables => [transactions];
// }
