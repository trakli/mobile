import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/category/category_remote_datasource.dart';
import 'package:trakli/data/datasources/wallet/wallet_remote_datasource.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockWalletRemote extends Mock implements WalletRemoteDataSource {}

class _MockCategoryRemote extends Mock implements CategoryRemoteDataSource {}

/// The create endpoints answer a name the user already has with 200 and the
/// existing record, after moving the posted client id onto it. The server id
/// that comes back is one this device filed under a different client id, and
/// `SyncTable.id` is unique locally, so the older copy has to hand over
/// everything that pointed at it and go away.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  /// Synced as server id 41, and the target of every reference below.
  const older = 'device:older';

  /// Just created locally; its POST came back with wallet 41.
  const fresh = 'device:fresh';

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    await db.wallets.insertOne(WalletsCompanion.insert(
      name: 'Cash',
      type: WalletType.cash,
      currency: 'USD',
      id: const Value(41),
      clientId: const Value(older),
    ));
    await db.wallets.insertOne(WalletsCompanion.insert(
      name: 'Cash',
      type: WalletType.cash,
      currency: 'USD',
      clientId: const Value(fresh),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addTransaction(String clientId, String walletClientId) {
    return db.transactions.insertOne(TransactionsCompanion.insert(
      amount: 10,
      type: TransactionType.expense,
      walletClientId: walletClientId,
      clientId: Value(clientId),
    ));
  }

  Future<void> addBudgetTargeting(
    String budgetClientId,
    BudgetTargetType type,
    String targetClientId,
  ) async {
    await db.budgets.insertOne(BudgetsCompanion.insert(
      name: budgetClientId,
      slug: budgetClientId,
      amount: 500,
      currency: 'USD',
      periodType: BudgetPeriodType.monthly,
      startDate: DateTime(2026, 9),
      clientId: Value(budgetClientId),
    ));
    await db.budgetTargets.insertOne(BudgetTargetsCompanion.insert(
      budgetClientId: budgetClientId,
      targetType: type,
      targetClientId: targetClientId,
    ));
  }

  Future<void> queueChange(
    String entityType,
    String entityId,
    Map<String, dynamic> data,
  ) {
    return db.localChanges.insertOne(LocalChangesCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      entityRev: '1',
      deleted: false,
      data: data,
      createAt: DateTime(2026, 9, 9),
      concluded: false,
      dismissed: false,
    ));
  }

  group('adoptWalletServerId', () {
    test('moves the transactions of the copy that held the server id',
        () async {
      await addTransaction('t-1', older);
      await addTransaction('t-2', older);
      await addTransaction('t-3', fresh);

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final rows = await db.transactions.all().get();
      expect(rows.map((t) => t.walletClientId), everyElement(fresh));
      expect(rows, hasLength(3));
    });

    test('moves both legs of a transfer', () async {
      await db.wallets.insertOne(WalletsCompanion.insert(
        name: 'Savings',
        type: WalletType.bank,
        currency: 'USD',
        id: const Value(42),
        clientId: const Value('device:savings'),
      ));
      await db.transfers.insertOne(TransfersCompanion.insert(
        amount: 25,
        datetime: DateTime(2026, 9, 9),
        clientId: const Value('tr-out'),
        fromWalletClientId: const Value(older),
        toWalletClientId: const Value('device:savings'),
      ));
      await db.transfers.insertOne(TransfersCompanion.insert(
        amount: 25,
        datetime: DateTime(2026, 9, 9),
        clientId: const Value('tr-in'),
        fromWalletClientId: const Value('device:savings'),
        toWalletClientId: const Value(older),
      ));

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final out = await (db.select(db.transfers)
            ..where((t) => t.clientId.equals('tr-out')))
          .getSingle();
      final into = await (db.select(db.transfers)
            ..where((t) => t.clientId.equals('tr-in')))
          .getSingle();
      expect(out.fromWalletClientId, fresh);
      expect(out.toWalletClientId, 'device:savings');
      expect(into.toWalletClientId, fresh);
    });

    test('moves budgets that targeted the duplicate', () async {
      await addBudgetTargeting('b-1', BudgetTargetType.wallet, older);

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final targets = await db.budgetTargets.all().get();
      expect(targets.single.targetClientId, fresh);
    });

    // Keyed by (budget, type, target), so a budget targeting both copies
    // would collide on its own primary key.
    test('collapses a budget that targeted both copies', () async {
      await addBudgetTargeting('b-1', BudgetTargetType.wallet, older);
      await db.budgetTargets.insertOne(BudgetTargetsCompanion.insert(
        budgetClientId: 'b-1',
        targetType: BudgetTargetType.wallet,
        targetClientId: fresh,
      ));

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final targets = await db.budgetTargets.all().get();
      expect(targets, hasLength(1));
      expect(targets.single.targetClientId, fresh);
    });

    test('leaves the duplicate holding the server id and nothing else',
        () async {
      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final wallets = await db.wallets.all().get();
      expect(wallets, hasLength(1));
      expect(wallets.single.clientId, fresh);
      // The caller writes the row next; what matters is that nothing else
      // is left claiming server id 41.
      expect(wallets.single.id, isNull);
    });

    test('rewrites the client id inside queued payloads', () async {
      await queueChange('transaction', 't-9', {
        'walletClientId': older,
        'wallet': {'client_generated_id': older, 'id': 41},
      });

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final queued = await (db.select(db.localChanges)
            ..where((lc) => lc.entityId.equals('t-9')))
          .getSingle();
      expect(queued.data['walletClientId'], fresh);
      expect((queued.data['wallet'] as Map)['client_generated_id'], fresh);
    });

    test('rewrites the client id inside parked downloads', () async {
      await db.deferredRemoteItems.insertOne(
        DeferredRemoteItemsCompanion.insert(
          entityType: 'transaction',
          clientId: 't-8',
          data: '{"walletClientId":"$older"}',
        ),
      );

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      final parked = await db.deferredRemoteItems.all().get();
      expect(parked.single.data, contains(fresh));
      expect(parked.single.data, isNot(contains(older)));
    });

    test("drops the duplicate's own queued write and parked download",
        () async {
      await queueChange('wallet', older, {'name': 'Cash'});
      await db.deferredRemoteItems.insertOne(
        DeferredRemoteItemsCompanion.insert(
          entityType: 'wallet',
          clientId: older,
          data: '{}',
        ),
      );

      await db.adoptWalletServerId(serverId: 41, clientId: fresh);

      expect(await db.localChanges.all().get(), isEmpty);
      expect(await db.deferredRemoteItems.all().get(), isEmpty);
    });

    test('does nothing when the same row already holds the server id',
        () async {
      await addTransaction('t-1', older);

      await db.adoptWalletServerId(serverId: 41, clientId: older);

      expect(await db.wallets.all().get(), hasLength(2));
      final txn = await db.transactions.all().get();
      expect(txn.single.walletClientId, older);
    });

    test('does nothing when no local row holds the server id', () async {
      await db.adoptWalletServerId(serverId: 999, clientId: fresh);

      expect(await db.wallets.all().get(), hasLength(2));
    });

    test('does nothing without a server id', () async {
      await db.adoptWalletServerId(serverId: null, clientId: fresh);

      expect(await db.wallets.all().get(), hasLength(2));
    });
  });

  group('adoptPartyServerId', () {
    test('moves the transactions of the copy that held the server id',
        () async {
      await db.parties.insertOne(PartiesCompanion.insert(
        name: 'Jane Doe',
        id: const Value(7),
        clientId: const Value('party:older'),
      ));
      await db.parties.insertOne(PartiesCompanion.insert(
        name: 'Jane Doe',
        clientId: const Value('party:fresh'),
      ));
      await db.transactions.insertOne(TransactionsCompanion.insert(
        amount: 10,
        type: TransactionType.expense,
        walletClientId: older,
        clientId: const Value('t-1'),
        partyClientId: const Value('party:older'),
      ));

      await db.adoptPartyServerId(serverId: 7, clientId: 'party:fresh');

      final parties = await db.parties.all().get();
      expect(parties.single.clientId, 'party:fresh');
      final txn = await db.transactions.all().get();
      expect(txn.single.partyClientId, 'party:fresh');
    });
  });

  group('adoptGroupServerId', () {
    test('moves transactions and budget targets', () async {
      await db.groups.insertOne(GroupsCompanion.insert(
        name: 'Household',
        id: const Value(5),
        clientId: const Value('group:older'),
      ));
      await db.groups.insertOne(GroupsCompanion.insert(
        name: 'Household',
        clientId: const Value('group:fresh'),
      ));
      await db.transactions.insertOne(TransactionsCompanion.insert(
        amount: 10,
        type: TransactionType.expense,
        walletClientId: older,
        clientId: const Value('t-1'),
        groupClientId: const Value('group:older'),
      ));
      await addBudgetTargeting('b-1', BudgetTargetType.group, 'group:older');

      await db.adoptGroupServerId(serverId: 5, clientId: 'group:fresh');

      final groups = await db.groups.all().get();
      expect(groups.single.clientId, 'group:fresh');
      final txn = await db.transactions.all().get();
      expect(txn.single.groupClientId, 'group:fresh');
      final targets = await db.budgetTargets.all().get();
      expect(targets.single.targetClientId, 'group:fresh');
    });
  });

  group('adoptCategoryServerId', () {
    test('re-tags what the duplicate categorised', () async {
      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'Rent',
        slug: 'rent',
        type: TransactionType.expense,
        id: const Value(9),
        clientId: const Value('cat:older'),
      ));
      // Byte-different, so the local unique index on name allows both; the
      // API's collation is what considers them the same category.
      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'rent ',
        slug: 'rent-',
        type: TransactionType.expense,
        clientId: const Value('cat:fresh'),
      ));
      await db.categorizables.insertOne(CategorizablesCompanion.insert(
        categorizableId: 't-1',
        categorizableType: CategorizableType.transaction,
        categoryClientId: 'cat:older',
      ));
      await addBudgetTargeting('b-1', BudgetTargetType.category, 'cat:older');

      await db.adoptCategoryServerId(serverId: 9, clientId: 'cat:fresh');

      final categories = await db.categories.all().get();
      expect(categories.single.clientId, 'cat:fresh');
      final tags = await db.categorizables.all().get();
      expect(tags.single.categoryClientId, 'cat:fresh');
      final targets = await db.budgetTargets.all().get();
      expect(targets.single.targetClientId, 'cat:fresh');
    });
  });

  // Persisting the server's answer used to fail with
  // `UNIQUE constraint failed: wallets.id`, quarantining an accepted change.
  group('WalletSyncHandler', () {
    test('persists a create answered with the wallet the user already had',
        () async {
      final handler = WalletSyncHandler(
        remoteDataSource: _MockWalletRemote(),
        db: db,
      );
      await addTransaction('t-1', older);

      final existing = await (db.select(db.wallets)
            ..where((w) => w.clientId.equals(older)))
          .getSingle();

      // What the API returns: the existing wallet, client id moved to ours.
      await handler.upsertAllLocal([existing.copyWith(clientId: fresh)]);

      final wallets = await db.wallets.all().get();
      expect(wallets, hasLength(1));
      expect(wallets.single.clientId, fresh);
      expect(wallets.single.id, 41);
      final txn = await db.transactions.all().get();
      expect(txn.single.walletClientId, fresh);
    });
  });

  // `POST /categories` used to answer a duplicate with 400; it now returns
  // the existing category like the other endpoints. What has to come out the
  // far side is the remote category: its name, its server id, and the client
  // id the server now files it under.
  group('CategorySyncHandler', () {
    late CategorySyncHandler handler;

    setUp(() async {
      handler = CategorySyncHandler(db, _MockCategoryRemote());

      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'Rent',
        slug: 'rent',
        type: TransactionType.expense,
        id: const Value(9),
        clientId: const Value('cat:older'),
      ));
      // The duplicate just created here, with the name as the user typed it.
      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'rent ',
        slug: 'rent-',
        type: TransactionType.expense,
        description: const Value('typed on this device'),
        clientId: const Value('cat:fresh'),
      ));
      for (final tag in [('t-1', 'cat:older'), ('t-2', 'cat:fresh')]) {
        await db.categorizables.insertOne(CategorizablesCompanion.insert(
          categorizableId: tag.$1,
          categorizableType: CategorizableType.transaction,
          categoryClientId: tag.$2,
        ));
      }
    });

    test('the surviving category is the one the server already had', () async {
      final remote = await (db.select(db.categories)
            ..where((c) => c.clientId.equals('cat:older')))
          .getSingle();

      // What the API returns: the existing category, client id moved to ours.
      await handler.upsertAllLocal([remote.copyWith(clientId: 'cat:fresh')]);

      final categories = await db.categories.all().get();
      expect(categories, hasLength(1));
      final survivor = categories.single;
      expect(survivor.id, 9, reason: 'keeps the remote server id');
      expect(survivor.name, 'Rent', reason: "the remote's name, not the typed one");
      expect(survivor.description, isNull,
          reason: 'the locally typed description is not the remote category');
      expect(survivor.clientId, 'cat:fresh',
          reason: 'the client id the server now files that category under');
    });

    test('both copies\' transactions end up on it', () async {
      final remote = await (db.select(db.categories)
            ..where((c) => c.clientId.equals('cat:older')))
          .getSingle();

      await handler.upsertAllLocal([remote.copyWith(clientId: 'cat:fresh')]);

      final tags = await db.categorizables.all().get();
      expect(tags.map((t) => t.categoryClientId), everyElement('cat:fresh'));
      expect(tags.map((t) => t.categorizableId), containsAll(['t-1', 't-2']));
    });
  });
}
