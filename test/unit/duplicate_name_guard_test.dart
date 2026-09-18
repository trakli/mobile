import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/group/group_local_datasource.dart';
import 'package:trakli/data/datasources/party/party_local_datasource.dart';
import 'package:trakli/data/datasources/wallet/wallet_local_datasource.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// `adopt*ServerId` is recovery, not prevention: a second wallet named like
/// one the user already has still syncs and still folds into the first, which
/// reads as the new one vanishing. These guards refuse the write up front,
/// comparing names as the API does (`utf8mb4_unicode_ci`).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('wallets', () {
    late WalletLocalDataSourceImpl source;

    setUp(() async {
      source = WalletLocalDataSourceImpl(database: db);
      await db.wallets.insertOne(WalletsCompanion.insert(
        name: 'Cash',
        type: WalletType.cash,
        currency: 'USD',
        clientId: const Value('device:cash'),
      ));
    });

    for (final name in ['Cash', 'cash', 'CASH ', '  cash  ']) {
      test('insert rejects "$name" in the same currency', () {
        expect(
          () => source.insertWallet(name, WalletType.bank, 0, 'USD'),
          throwsA(isA<DuplicateException>()),
        );
      });
    }

    // SQLite's lower() folds ASCII only, so comparing a Dart-folded literal
    // against a SQL-folded column never matched for non-ASCII names: 'CAFÉ'
    // lowered to 'cafÉ' in SQL but 'café' in Dart. The duplicate was written
    // locally and folded on sync, which is the symptom the guard prevents.
    test('insert rejects a name differing only in an accented letter\'s case',
        () async {
      await db.wallets.insertOne(WalletsCompanion.insert(
        name: 'CAFÉ',
        type: WalletType.cash,
        currency: 'USD',
        clientId: const Value('device:cafe'),
      ));

      expect(
        () => source.insertWallet('café', WalletType.bank, 0, 'USD'),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('insert rejects a currency differing only in case', () {
      expect(
        () => source.insertWallet('Cash', WalletType.cash, 0, 'usd'),
        throwsA(isA<DuplicateException>()),
      );
    });

    // The API keys on name *and* currency, so this is a genuinely new wallet.
    test('insert allows the same name in another currency', () async {
      final created =
          await source.insertWallet('Cash', WalletType.cash, 0, 'XAF');

      expect(created.currency, 'XAF');
      expect(await db.wallets.all().get(), hasLength(2));
    });

    test('insert stores a genuinely different name, trimmed', () async {
      final created =
          await source.insertWallet('Savings ', WalletType.bank, 0, 'USD');

      expect(created.name, 'Savings');
    });

    test('rename rejects a collision with another wallet', () async {
      await db.wallets.insertOne(WalletsCompanion.insert(
        name: 'Savings',
        type: WalletType.bank,
        currency: 'USD',
        clientId: const Value('device:savings'),
      ));

      expect(
        () => source.updateWallet('device:savings', name: 'cash '),
        throwsA(isA<DuplicateException>()),
      );
    });

    // Name and currency identify the wallet together, so a currency change
    // can collide just as a rename can.
    test('a currency change onto an existing pair is rejected', () async {
      await db.wallets.insertOne(WalletsCompanion.insert(
        name: 'Cash',
        type: WalletType.cash,
        currency: 'XAF',
        clientId: const Value('device:cash-xaf'),
      ));

      expect(
        () => source.updateWallet('device:cash-xaf', currency: 'USD'),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('a wallet can still be renamed to a variant of its own name',
        () async {
      final updated = await source.updateWallet('device:cash', name: 'CASH');

      expect(updated.name, 'CASH');
    });

    test('an unrelated edit is untouched by the guard', () async {
      final updated = await source.updateWallet('device:cash', balance: 250);

      expect(updated.balance, 250);
      expect(updated.name, 'Cash');
    });
  });

  group('groups', () {
    late GroupLocalDataSourceImpl source;

    setUp(() async {
      source = GroupLocalDataSourceImpl(database: db);
      await db.groups.insertOne(GroupsCompanion.insert(
        name: 'Household',
        clientId: const Value('device:household'),
      ));
    });

    for (final name in ['Household', 'household', 'HOUSEHOLD ']) {
      test('insert rejects "$name"', () {
        expect(
          () => source.insertGroup(name),
          throwsA(isA<DuplicateException>()),
        );
      });
    }

    test('insert stores a genuinely different name, trimmed', () async {
      final created = await source.insertGroup('Work ');

      expect(created.name, 'Work');
    });

    test('rename rejects a collision with another group', () async {
      await db.groups.insertOne(GroupsCompanion.insert(
        name: 'Work',
        clientId: const Value('device:work'),
      ));

      expect(
        () => source.updateGroup('device:work', name: 'household '),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('a group can still be renamed to a variant of its own name',
        () async {
      final updated =
          await source.updateGroup('device:household', name: 'HouseHold');

      expect(updated.name, 'HouseHold');
    });
  });

  group('parties', () {
    late PartyLocalDataSourceImpl source;

    setUp(() async {
      source = PartyLocalDataSourceImpl(db);
      await db.parties.insertOne(PartiesCompanion.insert(
        name: 'Jane Doe',
        type: const Value(PartyType.individual),
        clientId: const Value('device:jane'),
      ));
    });

    for (final name in ['Jane Doe', 'jane doe', 'JANE DOE ']) {
      test('insert rejects "$name"', () {
        expect(
          () => source.insertParty(name),
          throwsA(isA<DuplicateException>()),
        );
      });
    }

    // The API compares the name alone, so a different type is not a different
    // party to it.
    test('insert rejects the same name under another type', () {
      expect(
        () => source.insertParty('jane doe', type: PartyType.organization),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('insert stores a genuinely different name, trimmed', () async {
      final created = await source.insertParty('Acme Ltd ');

      expect(created.name, 'Acme Ltd');
    });

    test('rename rejects a collision with another party', () async {
      await db.parties.insertOne(PartiesCompanion.insert(
        name: 'Acme Ltd',
        clientId: const Value('device:acme'),
      ));

      expect(
        () => source.updateParty('device:acme', name: 'jane doe '),
        throwsA(isA<DuplicateException>()),
      );
    });

    test('a party can still be renamed to a variant of its own name',
        () async {
      final updated =
          await source.updateParty('device:jane', name: 'jane Doe');

      expect(updated.name, 'jane Doe');
    });
  });
}
