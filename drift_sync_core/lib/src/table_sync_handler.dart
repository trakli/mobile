import 'package:drift/drift.dart';

// Provides a mixin to simplify common database operations for tables. It leverages Drift's capabilities for inserting, updating, and deleting rows.
mixin TableSyncHandler<Tbl extends Table, Row extends Insertable<Row>> {
  TableInfo<Tbl, Row> get table;

  Future<void> deleteLocal(Row entity) async {
    await table.deleteOne(entity);
  }

  Future<void> upsertLocal(Row entity) async {
    await table.insertOne(entity, mode: InsertMode.insertOrReplace);
  }

  Future<void> upsertAllLocal(List<Row> list) async {
    await table.insertAll(list, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }
}
