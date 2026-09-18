import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  /// The category the API accepted, and the local duplicate it keeps
  /// rejecting with "Category already exists".
  const winner = 'device:winner';
  const loser = 'device:loser';

  Future<void> tag(String transactionClientId, String categoryClientId) {
    return db.categorizables.insertOne(CategorizablesCompanion.insert(
      categorizableId: transactionClientId,
      categorizableType: CategorizableType.transaction,
      categoryClientId: categoryClientId,
    ));
  }

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'WhileSmart',
      slug: 'whilesmart',
      type: TransactionType.income,
      id: const Value(41),
      clientId: const Value(winner),
    ));
    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'Whilesmart ',
      slug: 'whilesmart-',
      type: TransactionType.income,
      clientId: const Value(loser),
    ));
    await db.localChanges.insertOne(LocalChangesCompanion.insert(
      entityType: 'category',
      entityId: loser,
      entityRev: '1',
      deleted: false,
      data: const {'name': 'Whilesmart '},
      createAt: DateTime(2026, 7, 9),
      concluded: false,
      dismissed: false,
      quarantinedAt: Value(DateTime(2026, 8, 17)),
      error: const Value('HTTP 400 — Category already exists'),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  test('re-tags the duplicate\'s transactions onto the surviving category',
      () async {
    await tag('txn-1', loser);
    await tag('txn-2', loser);

    final retagged = await db.mergeDuplicateCategory(
      loserClientId: loser,
      winnerClientId: winner,
    );

    expect(retagged, 2);
    final rows = await db.categorizables.all().get();
    expect(rows.map((r) => r.categoryClientId), everyElement(winner));
    expect(rows.map((r) => r.categorizableId), containsAll(['txn-1', 'txn-2']));
  });

  test('drops the duplicate and its quarantined change', () async {
    await tag('txn-1', loser);

    await db.mergeDuplicateCategory(
      loserClientId: loser,
      winnerClientId: winner,
    );

    final remaining = await db.categories.all().get();
    expect(remaining.map((c) => c.clientId), [winner]);
    expect(await db.localChanges.all().get(), isEmpty);
  });

  // A transaction carrying both categories would otherwise collide on the
  // (source, type, category) primary key.
  test('collapses a transaction already tagged with both', () async {
    await tag('txn-1', loser);
    await tag('txn-1', winner);

    final retagged = await db.mergeDuplicateCategory(
      loserClientId: loser,
      winnerClientId: winner,
    );

    expect(retagged, 1);
    final rows = await db.categorizables.all().get();
    expect(rows, hasLength(1));
    expect(rows.single.categoryClientId, winner);
  });

  test('leaves other categories and their tags alone', () async {
    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'Groceries',
      slug: 'groceries',
      type: TransactionType.expense,
      id: const Value(42),
      clientId: const Value('device:groceries'),
    ));
    await tag('txn-9', 'device:groceries');
    await tag('txn-1', loser);

    await db.mergeDuplicateCategory(
      loserClientId: loser,
      winnerClientId: winner,
    );

    final groceryTags = await (db.select(db.categorizables)
          ..where((c) => c.categoryClientId.equals('device:groceries')))
        .get();
    expect(groceryTags, hasLength(1));
    expect(await db.categories.all().get(), hasLength(2));
  });

  test('refuses a merge into itself', () {
    expect(
      () => db.mergeDuplicateCategory(
        loserClientId: loser,
        winnerClientId: loser,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('refuses an unknown target and changes nothing', () async {
    await tag('txn-1', loser);

    await expectLater(
      db.mergeDuplicateCategory(
        loserClientId: loser,
        winnerClientId: 'device:nope',
      ),
      throwsA(isA<StateError>()),
    );

    expect(await db.categories.all().get(), hasLength(2));
    expect(await db.categorizables.all().get(), hasLength(1));
  });
}
