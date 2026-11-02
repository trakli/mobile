import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v9.dart' as v9;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final verifier = SchemaVerifier(GeneratedHelper());

  test('ownership migration preserves records and pending offline changes',
      () async {
    final schema = await verifier.schemaAt(9);
    final old = v9.DatabaseAtV9(schema.newConnection());
    final rows = <String, Map<String, Object?>>{
      'wallets': {
        'name': 'Cash',
        'type': 'cash',
        'currency': 'USD',
        'balance': 123.4567
      },
      'parties': {'name': 'Shop'},
      'groups': {'name': 'Holiday'},
      'categories': {'name': 'Food', 'slug': 'food', 'type': 'expense'},
      'transactions': {'amount': 0.0001, 'type': 'expense'},
      'transfers': {'amount': 12.3456, 'datetime': '2026-11-02T10:00:00.000Z'},
      'reminders': {'title': 'Rent'},
    };
    for (final entry in rows.entries) {
      for (final userId in [17, 29]) {
        final values = {
          ...entry.value,
          if (entry.value.containsKey('name'))
            'name': '${entry.value['name']} $userId',
          if (entry.value.containsKey('slug'))
            'slug': '${entry.value['slug']}-$userId',
          'id': userId,
          'user_id': userId,
          'client_id': '${entry.key}-$userId',
          if (entry.key == 'transactions')
            'wallet_client_id': 'wallets-$userId',
          if (entry.key == 'transactions' && userId == 29)
            'deleted_at': '2026-10-01T10:00:00.000Z',
        };
        await old.customStatement(
          'INSERT INTO ${entry.key} (${values.keys.join(', ')}) '
          'VALUES (${values.keys.map((_) => '?').join(', ')})',
          values.values.toList(),
        );
      }
    }
    await old.customStatement(
      "INSERT INTO wallets (client_id, name, type, currency, balance) "
      "VALUES ('offline-wallet', 'Offline cash', 'cash', 'USD', 55.5)",
    );
    final pending = (await old
            .customSelect(
              "SELECT * FROM wallets WHERE client_id = 'offline-wallet'",
            )
            .getSingle())
        .data;
    await old.customStatement(
      'INSERT INTO local_changes '
      '(entity_type, entity_id, entity_rev, deleted, data, create_at, concluded, dismissed) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        'wallet',
        'offline-wallet',
        '1',
        false,
        jsonEncode(pending),
        '2026-11-02T10:00:00.000Z',
        false,
        false
      ],
    );
    final before = <String, List<Map<String, dynamic>>>{};
    for (final table in [...rows.keys, 'local_changes']) {
      before[table] = (await old.customSelect('SELECT * FROM $table').get())
          .map((row) => row.data)
          .toList();
    }
    await old.close();

    final db = AppDatabase(schema.newConnection());
    try {
      await verifier.migrateAndValidate(db, 10);
      for (final entry in before.entries) {
        final actual =
            (await db.customSelect('SELECT * FROM ${entry.key}').get())
                .map((row) => Map<String, dynamic>.from(row.data))
                .toList();
        if (entry.key != 'local_changes') {
          for (final row in actual) {
            expect(row.remove('owner_id'), row['user_id']);
            expect(row.remove('owner_type'),
                row['user_id'] == null ? null : r'App\Models\User');
          }
        }
        expect(actual, entry.value, reason: entry.key);
      }
    } finally {
      await db.close();
    }
  });
}
