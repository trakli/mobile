// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  }, skip: true);

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldWalletsData = <v1.WalletsData>[];
    final expectedNewWalletsData = <v2.WalletsData>[];

    final oldPartiesData = <v1.PartiesData>[];
    final expectedNewPartiesData = <v2.PartiesData>[];

    final oldGroupsData = <v1.GroupsData>[];
    final expectedNewGroupsData = <v2.GroupsData>[];

    final oldTransactionsData = <v1.TransactionsData>[];
    final expectedNewTransactionsData = <v2.TransactionsData>[];

    final oldCategoriesData = <v1.CategoriesData>[];
    final expectedNewCategoriesData = <v2.CategoriesData>[];

    final oldConfigsData = <v1.ConfigsData>[];
    final expectedNewConfigsData = <v2.ConfigsData>[];

    final oldUsersData = <v1.UsersData>[];
    final expectedNewUsersData = <v2.UsersData>[];

    final oldLocalChangesData = <v1.LocalChangesData>[];
    final expectedNewLocalChangesData = <v2.LocalChangesData>[];

    final oldSyncMetadataData = <v1.SyncMetadataData>[];
    final expectedNewSyncMetadataData = <v2.SyncMetadataData>[];

    final oldCategorizablesData = <v1.CategorizablesData>[];
    final expectedNewCategorizablesData = <v2.CategorizablesData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.wallets, oldWalletsData);
        batch.insertAll(oldDb.parties, oldPartiesData);
        batch.insertAll(oldDb.groups, oldGroupsData);
        batch.insertAll(oldDb.transactions, oldTransactionsData);
        batch.insertAll(oldDb.categories, oldCategoriesData);
        batch.insertAll(oldDb.configs, oldConfigsData);
        batch.insertAll(oldDb.users, oldUsersData);
        batch.insertAll(oldDb.localChanges, oldLocalChangesData);
        batch.insertAll(oldDb.syncMetadata, oldSyncMetadataData);
        batch.insertAll(oldDb.categorizables, oldCategorizablesData);
      },
      validateItems: (newDb) async {
        expect(expectedNewWalletsData, await newDb.select(newDb.wallets).get());
        expect(expectedNewPartiesData, await newDb.select(newDb.parties).get());
        expect(expectedNewGroupsData, await newDb.select(newDb.groups).get());
        expect(expectedNewTransactionsData,
            await newDb.select(newDb.transactions).get());
        expect(expectedNewCategoriesData,
            await newDb.select(newDb.categories).get());
        expect(expectedNewConfigsData, await newDb.select(newDb.configs).get());
        expect(expectedNewUsersData, await newDb.select(newDb.users).get());
        expect(expectedNewLocalChangesData,
            await newDb.select(newDb.localChanges).get());
        expect(expectedNewSyncMetadataData,
            await newDb.select(newDb.syncMetadata).get());
        expect(expectedNewCategorizablesData,
            await newDb.select(newDb.categorizables).get());
      },
    );
  }, skip: true);
}
