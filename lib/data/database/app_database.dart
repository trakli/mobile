import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:trakli/core/sync/sync_error_description.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/database/converters/budget_progress_json_converter.dart';
import 'package:trakli/data/database/converters/media_converter.dart';
import 'package:trakli/data/database/converters/party_type_converter.dart';
import 'package:trakli/data/database/converters/string_to_double_converter.dart';
import 'package:trakli/data/database/converters/wallet_stats_converter.dart';
import 'package:trakli/data/database/converters/wallet_type_converter.dart';
import 'package:trakli/data/database/tables/budget_period_states.dart';
import 'package:trakli/data/database/tables/budget_targets.dart';
import 'package:trakli/data/database/tables/budgets.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/data/database/tables/categorizables.dart';
import 'package:trakli/data/database/tables/configs.dart';
import 'package:trakli/data/database/tables/deferred_remote_items.dart';
import 'package:trakli/data/database/tables/financial_position_cache.dart';
import 'package:trakli/data/database/tables/groups.dart';
import 'package:trakli/data/database/tables/holdings.dart';
import 'package:trakli/data/database/tables/local_changes.dart';
import 'package:trakli/data/database/tables/media_files.dart';
import 'package:trakli/data/database/tables/notifications.dart';
import 'package:trakli/data/database/tables/parties.dart';
import 'package:trakli/data/database/tables/reminders.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/tables/transactions.dart';
import 'package:trakli/data/database/tables/transfers.dart';
import 'package:trakli/data/database/tables/users.dart';
import 'package:trakli/data/database/tables/wallets.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/data/models/wallet_stats.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

import 'app_database.steps.dart';
import 'tables/sync_meta_data.dart';
import 'package:trakli/core/sync/sync_entity.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Transactions,
  Parties,
  Categories,
  Configs,
  Users,
  Groups,
  Wallets,
  LocalChanges,
  SyncMetadata,
  Categorizables,
  Notifications,
  MediaFiles,
  Transfers,
  Budgets,
  BudgetTargets,
  BudgetPeriodStates,
  Holdings,
  FinancialPositionCache,
  Reminders,
  DeferredRemoteItems,
])
class AppDatabase extends _$AppDatabase with SynchronizerDb {
  final Set<SyncTypeHandler> typeHandlers;

  AppDatabase([
    QueryExecutor? executor,
    Set<SyncTypeHandler>? typeHandlers,
  ])  : typeHandlers = typeHandlers ?? {},
        super(executor ?? _openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await _schemaUpgrade(m, from, to);
      },
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'trakli.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  /// Failed changes are retried automatically once this much time has passed
  /// since the last attempt; a successful retry deletes the row.
  /// Base delay before the first retry of a failed change. Each further
  /// failed attempt doubles the wait ([retryBackoff]).
  static const failedChangeRetryDelay = Duration(minutes: 1);

  /// Upper bound on the exponential retry backoff.
  static const failedChangeRetryCap = Duration(hours: 1);

  /// Backoff before retrying a change that has failed [attemptCount] times:
  /// base doubles per attempt, capped at [failedChangeRetryCap].
  static Duration retryBackoff(int attemptCount) {
    if (attemptCount <= 1) return failedChangeRetryDelay;
    final shift = attemptCount - 1;
    // Cap the exponent itself, not just the final duration: on Dart
    // compiled to JS, bitwise shifts truncate to 32 bits, so a large shift
    // can wrap negative before the cap check below ever runs. 6 is already
    // past the point where the multiplication exceeds the cap.
    final safeShift = shift > 6 ? 6 : shift;
    final ms = failedChangeRetryDelay.inMilliseconds * (1 << safeShift);
    return ms >= failedChangeRetryCap.inMilliseconds
        ? failedChangeRetryCap
        : Duration(milliseconds: ms);
  }

  @override
  Future<List<PendingLocalChange>> getPendingLocalChanges() async {
    final now = DateTime.now();
    // Quarantined and dismissed changes never retry, so both are excluded
    // in SQL. The remaining rows are filtered by their per-row exponential
    // backoff below (not expressible in SQL).
    final rows = await (select(localChanges)
          ..where(
              (lc) => lc.quarantinedAt.isNull() & lc.dismissed.equals(false)))
        .get();

    return rows
        .where((row) {
          if (row.error == null) return true; // never failed
          final concluded = row.concludedMoment;
          if (concluded == null) return true;
          return now.isAfter(concluded.add(retryBackoff(row.attemptCount)));
        })
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
              attemptCount: row.attemptCount,
              quarantinedAt: row.quarantinedAt,
            ))
        .toList();
  }

  @override
  Future<void> cancelAllLocalChanges() async {
    await delete(localChanges).go();
  }

  /// Client ids with no server id and no local_changes row in any state.
  Future<List<String>> getOrphanedClientIds(
    String tableName,
    String entityType, {
    String clientIdColumn = 'client_id',
    String? deletedAtColumn = 'deleted_at',
  }) async {
    final activeRow =
        deletedAtColumn == null ? '' : 'AND t.$deletedAtColumn IS NULL ';
    final rows = await customSelect(
      'SELECT t.$clientIdColumn AS client_id FROM $tableName t '
      'WHERE t.id IS NULL $activeRow'
      'AND NOT EXISTS ('
      'SELECT 1 FROM local_changes lc '
      'WHERE lc.entity_type = ?1 '
      'AND lc.entity_id = t.$clientIdColumn)',
      variables: [Variable.withString(entityType)],
    ).get();
    return rows.map((r) => r.read<String>('client_id')).toList();
  }

  /// True while transaction or transfer changes are still waiting to sync —
  /// server /stats cannot include them yet. Dismissed and quarantined
  /// changes don't count: dismissed changes never sync, and quarantined
  /// ones won't sync without a user retry, so neither should hold reports
  /// on "local estimate" indefinitely.
  Future<bool> hasPendingTransactionChanges() async {
    final row = await (select(localChanges)
          ..where((lc) =>
              lc.entityType.isIn(const ['transaction', 'transfer']) &
              lc.dismissed.equals(false) &
              lc.quarantinedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
    return row != null;
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

  /// Folds [loserClientId] into [winnerClientId]: re-tags everything the
  /// duplicate categorised, moves budgets that targeted it, deletes it, and
  /// clears its stuck outbox entry. Returns the number of re-tagged rows.
  ///
  /// Repairs a create the API *rejected* (400, sent without a client id): the
  /// duplicate never received a server id, so it is the loser. A create that
  /// did send one gets 200 and the existing record instead, which
  /// [adoptCategoryServerId] reconciles the other way round.
  Future<int> mergeDuplicateCategory({
    required String loserClientId,
    required String winnerClientId,
  }) =>
      _mergeCategory(loserClientId, winnerClientId, requireWinner: true);

  /// Hands [serverId] to [clientId], folding away whichever local category
  /// holds it. See [_adoptServerId].
  Future<void> adoptCategoryServerId({
    required int? serverId,
    required String clientId,
  }) =>
      _adoptServerId('categories', serverId, clientId, _mergeCategory);

  /// Hands [serverId] to [clientId], folding away whichever local wallet
  /// holds it. See [_adoptServerId].
  Future<void> adoptWalletServerId({
    required int? serverId,
    required String clientId,
  }) =>
      _adoptServerId('wallets', serverId, clientId, _mergeWallet);

  /// Hands [serverId] to [clientId], folding away whichever local party
  /// holds it. See [_adoptServerId].
  Future<void> adoptPartyServerId({
    required int? serverId,
    required String clientId,
  }) =>
      _adoptServerId('parties', serverId, clientId, _mergeParty);

  /// Hands [serverId] to [clientId], folding away whichever local group
  /// holds it. See [_adoptServerId].
  Future<void> adoptGroupServerId({
    required int? serverId,
    required String clientId,
  }) =>
      _adoptServerId('groups', serverId, clientId, _mergeGroup);

  /// Makes [serverId] available to [clientId] by merging the row that owns it
  /// into [clientId]. A no-op unless some *other* local row owns it. Call it
  /// immediately before writing the row, inside the same transaction.
  ///
  /// The create endpoints answer a name the user already has with 200 and the
  /// existing record, after moving the posted client id onto it — so the server
  /// id that comes back is one this device filed under a different client id,
  /// and `SyncTable.id` is unique locally. Downloads reach the same state from
  /// the other side. Either way the server now points at the incoming copy, so
  /// the older one gives up its references.
  Future<void> _adoptServerId(
    String table,
    int? serverId,
    String clientId,
    Future<int> Function(String loser, String winner,
            {required bool requireWinner})
        merge,
  ) async {
    if (serverId == null || clientId.isEmpty) return;

    final holder = await customSelect(
      'SELECT client_id FROM $table WHERE id = ? LIMIT 1',
      variables: [Variable<int>(serverId)],
    ).getSingleOrNull();
    if (holder == null) return;

    final holderClientId = holder.read<String>('client_id');
    if (holderClientId.isEmpty || holderClientId == clientId) return;

    // The caller writes the survivor next; on a download its row does not
    // exist yet.
    await merge(holderClientId, clientId, requireWinner: false);
  }

  Future<int> _mergeCategory(
    String loser,
    String winner, {
    required bool requireWinner,
  }) {
    return _mergeDuplicate(
      entityType: SyncEntity.category,
      table: 'categories',
      loserClientId: loser,
      winnerClientId: winner,
      targetType: BudgetTargetType.category,
      requireWinner: requireWinner,
      repoint: () async {
        // Re-tag by insert-then-delete rather than by update: a transaction
        // already tagged with both categories would collide on the
        // (source, type, category) primary key.
        await customStatement(
          'INSERT OR IGNORE INTO categorizables '
          '(categorizable_id, categorizable_type, category_client_id) '
          'SELECT categorizable_id, categorizable_type, ? FROM categorizables '
          'WHERE category_client_id = ?',
          [winner, loser],
        );
        return (delete(categorizables)
              ..where((c) => c.categoryClientId.equals(loser)))
            .go();
      },
    );
  }

  Future<int> _mergeWallet(
    String loser,
    String winner, {
    required bool requireWinner,
  }) {
    return _mergeDuplicate(
      entityType: SyncEntity.wallet,
      table: 'wallets',
      loserClientId: loser,
      winnerClientId: winner,
      targetType: BudgetTargetType.wallet,
      requireWinner: requireWinner,
      repoint: () async {
        var moved = await (update(transactions)
              ..where((t) => t.walletClientId.equals(loser)))
            .write(TransactionsCompanion(walletClientId: Value(winner)));
        moved += await (update(transfers)
              ..where((t) => t.fromWalletClientId.equals(loser)))
            .write(TransfersCompanion(fromWalletClientId: Value(winner)));
        moved += await (update(transfers)
              ..where((t) => t.toWalletClientId.equals(loser)))
            .write(TransfersCompanion(toWalletClientId: Value(winner)));
        return moved;
      },
    );
  }

  Future<int> _mergeParty(
    String loser,
    String winner, {
    required bool requireWinner,
  }) {
    return _mergeDuplicate(
      entityType: SyncEntity.party,
      table: 'parties',
      loserClientId: loser,
      winnerClientId: winner,
      // Parties cannot be budget targets.
      targetType: null,
      requireWinner: requireWinner,
      repoint: () => (update(transactions)
            ..where((t) => t.partyClientId.equals(loser)))
          .write(TransactionsCompanion(partyClientId: Value(winner))),
    );
  }

  Future<int> _mergeGroup(
    String loser,
    String winner, {
    required bool requireWinner,
  }) {
    return _mergeDuplicate(
      entityType: SyncEntity.group,
      table: 'groups',
      loserClientId: loser,
      winnerClientId: winner,
      targetType: BudgetTargetType.group,
      requireWinner: requireWinner,
      repoint: () => (update(transactions)
            ..where((t) => t.groupClientId.equals(loser)))
          .write(TransactionsCompanion(groupClientId: Value(winner))),
    );
  }

  /// Shared body of the merges. [repoint] moves the rows that referenced the
  /// duplicate and reports how many; everything around it is the same for
  /// every entity.
  Future<int> _mergeDuplicate({
    required SyncEntity entityType,
    required String table,
    required String loserClientId,
    required String winnerClientId,
    required BudgetTargetType? targetType,
    required bool requireWinner,
    required Future<int> Function() repoint,
  }) {
    if (loserClientId == winnerClientId) {
      throw ArgumentError.value(
        loserClientId,
        'loserClientId',
        'A ${entityType.key} cannot be merged into itself',
      );
    }

    return transaction(() async {
      final required = [
        loserClientId,
        if (requireWinner) winnerClientId,
      ];
      for (final clientId in required) {
        final exists = await customSelect(
          'SELECT 1 FROM $table WHERE client_id = ? LIMIT 1',
          variables: [Variable<String>(clientId)],
        ).getSingleOrNull();
        if (exists == null) {
          throw StateError('No ${entityType.key} with client id $clientId');
        }
      }

      final repointed = await repoint();
      if (targetType != null) {
        await _repointBudgetTargets(targetType, loserClientId, winnerClientId);
      }

      // Its queued write cannot stand alone, and re-pointing it would collide
      // with the survivor's entry on (entity_id, entity_type).
      await (delete(localChanges)
            ..where((lc) =>
                lc.entityType.equals(entityType.key) &
                lc.entityId.equals(loserClientId)))
          .go();
      await (delete(deferredRemoteItems)
            ..where((d) =>
                d.entityType.equals(entityType.key) &
                d.clientId.equals(loserClientId)))
          .go();

      await _repointPayloads(loserClientId, winnerClientId);

      await customStatement(
        'DELETE FROM $table WHERE client_id = ?',
        [loserClientId],
      );

      return repointed;
    });
  }

  /// Budget targets are keyed by (budget, type, target), so a budget that
  /// targeted both copies would collide on the primary key — add what is
  /// missing, then drop the duplicate's rows.
  Future<void> _repointBudgetTargets(
    BudgetTargetType targetType,
    String loserClientId,
    String winnerClientId,
  ) async {
    await customStatement(
      'INSERT OR IGNORE INTO budget_targets '
      '(budget_client_id, target_type, target_client_id) '
      'SELECT budget_client_id, target_type, ? FROM budget_targets '
      'WHERE target_type = ? AND target_client_id = ?',
      [winnerClientId, targetType.name, loserClientId],
    );
    await (delete(budgetTargets)
          ..where((t) =>
              t.targetType.equalsValue(targetType) &
              t.targetClientId.equals(loserClientId)))
        .go();
  }

  /// Rewrites references to [loserClientId] inside the queued outbox payloads
  /// and the parked download payloads.
  ///
  /// They are immutable JSON snapshots of whole DTO graphs — a queued
  /// transaction embeds its wallet object, which is written back verbatim and
  /// would resurrect the row this merge just deleted. References sit under many
  /// keys, in both camelCase and snake_case, at any depth; client ids are
  /// unique enough that swapping the text hits exactly them.
  Future<void> _repointPayloads(
    String loserClientId,
    String winnerClientId,
  ) async {
    for (final table in const ['local_changes', 'deferred_remote_items']) {
      await customStatement(
        // instr() is an exact, case-sensitive substring test. LIKE would treat
        // % and _ in the id as wildcards and match case-insensitively, so it
        // can select rows replace() then leaves untouched.
        'UPDATE $table SET data = replace(data, ?, ?) WHERE instr(data, ?) > 0',
        [loserClientId, winnerClientId, loserClientId],
      );
    }
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
      {Object? error,
      bool persistedToRemote = false,
      bool quarantine = false}) async {
    if (error != null) {
      await (update(localChanges)
            ..where((lc) =>
                lc.entityType.equals(localChange.entityType) &
                lc.entityId.equals(localChange.entityId)))
          .write(
        LocalChangesCompanion(
          concludedMoment: Value(DateTime.now()),
          error: Value(describeSyncError(error)),
          concluded: const Value(true),
          attemptCount: Value(localChange.attemptCount + 1),
          quarantinedAt:
              quarantine ? Value(DateTime.now()) : const Value.absent(),
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
      attemptCount: Value(pendingLocalChange.attemptCount),
      quarantinedAt: Value(pendingLocalChange.quarantinedAt),
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
      lastAttemptedAt: row.lastAttemptedAt,
      lastError: row.lastError,
    );
  }

  @override
  Future<List<LocalSyncMetadata>> getLocalSyncMetadataList() async {
    final rows = await select(syncMetadata).get();
    return rows
        .map((row) => LocalSyncMetadata(
              entityType: row.entityType,
              lastSyncedAt: row.lastSyncedAt,
              lastAttemptedAt: row.lastAttemptedAt,
              lastError: row.lastError,
            ))
        .toList();
  }

  @override
  Future<void> updateEntityLocalSyncMetadata(
      {required String entityType, DateTime? lastSyncedAt}) async {
    await into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion(
        entityType: Value(entityType),
        lastSyncedAt: Value(lastSyncedAt),
      ),
    );
  }

  @override
  Future<void> recordEntitySyncAttempt(
    String entityType, {
    required DateTime attemptedAt,
    Object? error,
  }) async {
    await into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion(
        entityType: Value(entityType),
        lastAttemptedAt: Value(attemptedAt),
        lastError: Value(error?.toString()),
      ),
    );
  }

  @override
  Future<void> parkRemoteItem(ParkedRemoteItem item) async {
    await deferredRemoteItems.insertOne(
      DeferredRemoteItemsCompanion.insert(
        entityType: item.entityType,
        clientId: item.clientId,
        data: jsonEncode(item.data),
        parkedAt: Value(item.parkedAt ?? DateTime.now().toUtc()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<List<ParkedRemoteItem>> getParkedRemoteItems(String entityType) async {
    final rows = await (select(deferredRemoteItems)
          ..where((t) => t.entityType.equals(entityType)))
        .get();
    return rows
        .map((row) => ParkedRemoteItem(
              entityType: row.entityType,
              clientId: row.clientId,
              data: jsonDecode(row.data) as Map<String, dynamic>,
              parkedAt: row.parkedAt,
            ))
        .toList(growable: false);
  }

  @override
  Future<void> unparkRemoteItem(String entityType, String clientId) async {
    await (delete(deferredRemoteItems)
          ..where((t) =>
              t.entityType.equals(entityType) & t.clientId.equals(clientId)))
        .go();
  }

  @override
  Future<void> clearDatabase() async {
    await users.deleteAll();
    await transactions.deleteAll();
    await categories.deleteAll();
    await configs.deleteAll();
    await parties.deleteAll();
    await groups.deleteAll();
    await wallets.deleteAll();
    await localChanges.deleteAll();
    await syncMetadata.deleteAll();
    await categorizables.deleteAll();
    await notifications.deleteAll();
    await mediaFiles.deleteAll();
    await transfers.deleteAll();
    await budgetTargets.deleteAll();
    await budgetPeriodStates.deleteAll();
    await budgets.deleteAll();
    await holdings.deleteAll();
    await financialPositionCache.deleteAll();
    await reminders.deleteAll();
  }
}

extension Migrations on GeneratedDatabase {
  // A getter (not a field) so each step uses its own schema snapshot, not the
  // current one.
  OnUpgrade get _schemaUpgrade => stepByStep(
        from1To2: (m, schema) async {
          await m.createTable(schema.notifications);
        },
        from2To3: (m, schema) async {
          await m.createTable(schema.mediaFiles);
        },
        from3To4: (m, schema) async {
          await m.createTable(schema.transfers);
          await m.addColumn(
              schema.transactions, schema.transactions.transferId);
          await m.addColumn(
            schema.transactions,
            schema.transactions.transferClientId,
          );
        },
        from4To5: (Migrator m, Schema5 schema) async {
          await m.createTable(schema.budgets);
          await m.createTable(schema.budgetTargets);
          await m.createTable(schema.budgetPeriodStates);
        },
        from5To6: (Migrator m, Schema6 schema) async {
          await m.addColumn(schema.transactions, schema.transactions.intent);
          await m.createTable(schema.holdings);
          await m.createTable(schema.financialPositionCache);
        },
        from6To7: (Migrator m, Schema7 schema) async {
          // Refunds
          await m.addColumn(schema.transactions, schema.transactions.isRefund);
          await m.addColumn(
              schema.transactions, schema.transactions.refundOfTransactionId);
          // Recurring transactions
          await m.addColumn(
              schema.transactions, schema.transactions.recurrencePeriod);
          await m.addColumn(
              schema.transactions, schema.transactions.recurrenceInterval);
          await m.addColumn(
              schema.transactions, schema.transactions.recurrenceEndsAt);
          await m.addColumn(schema.transactions,
              schema.transactions.recurrenceNextScheduledAt);
          // Reminders
          await m.createTable(schema.reminders);
        },
        from7To8: (Migrator m, Schema8 schema) async {
          // Parking store for down-synced items with unmet local
          // dependencies (SyncTypeHandler.shouldPersistLocal).
          await m.createTable(schema.deferredRemoteItems);

          // Failure classification: retry accounting + quarantine for
          // permanently failed local changes.
          await m.addColumn(
              schema.localChanges, schema.localChanges.attemptCount);
          await m.addColumn(
              schema.localChanges, schema.localChanges.quarantinedAt);
        },
        from8To9: (Migrator m, Schema9 schema) async {
          await m.addColumn(
            schema.syncMetadata,
            schema.syncMetadata.lastAttemptedAt,
          );
          await m.addColumn(
            schema.syncMetadata,
            schema.syncMetadata.lastError,
          );
        },
      );
}
