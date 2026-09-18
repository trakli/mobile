import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/category/category_local_datasource.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late CategoryLocalDataSourceImpl dataSource;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    dataSource = CategoryLocalDataSourceImpl(db);

    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'WhileSmart',
      slug: 'whilesmart',
      type: TransactionType.income,
      clientId: const Value('device:existing'),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  // The API's collation is case-insensitive and ignores trailing spaces, so
  // these all come back as "Category already exists" — HTTP 200 carrying the
  // category the user already had, whose server id then folds this device's
  // older copy away and drops whatever was typed here. Reject them instead.
  for (final name in ['Whilesmart ', 'whilesmart', '  WhileSmart  ']) {
    test('insert rejects "$name" as a duplicate of "WhileSmart"', () {
      expect(
        () => dataSource.insertCategory(
          name,
          'whilesmart',
          TransactionType.income,
        ),
        throwsA(isA<DuplicateException>()),
      );
    });
  }

  // The server checks the name alone, without filtering on type.
  test('insert rejects a same-name category of the other type', () {
    expect(
      () => dataSource.insertCategory(
        'whilesmart',
        'whilesmart',
        TransactionType.expense,
      ),
      throwsA(isA<DuplicateException>()),
    );
  });

  test('insert stores a genuinely different name, trimmed', () async {
    final created = await dataSource.insertCategory(
      'Rent ',
      'rent-',
      TransactionType.expense,
    );

    expect(created.name, 'Rent');
    expect(created.slug, 'rent-');
  });

  test('rename rejects a name that collides with another category', () async {
    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'Rent',
      slug: 'rent',
      type: TransactionType.expense,
      clientId: const Value('device:rent'),
    ));

    expect(
      () => dataSource.updateCategory('device:rent', name: 'whilesmart '),
      throwsA(isA<DuplicateException>()),
    );
  });

  test('rename trims the stored name and slug', () async {
    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'Rent',
      slug: 'rent',
      type: TransactionType.expense,
      clientId: const Value('device:rent'),
    ));

    final updated = await dataSource.updateCategory(
      'device:rent',
      name: 'Housing ',
      slug: 'housing-',
    );

    expect(updated.name, 'Housing');
    expect(updated.slug, 'housing-');
  });

  test('a category can still be renamed to a variant of its own name',
      () async {
    final updated =
        await dataSource.updateCategory('device:existing', name: 'Whilesmart');

    expect(updated.name, 'Whilesmart');
  });
}
