import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/datasources/category/category_remote_datasource.dart';
import 'package:trakli/data/datasources/configuration/configuration_remote_datasource.dart';
import 'package:trakli/data/datasources/group/group_remote_datasource.dart';
import 'package:trakli/data/datasources/party/party_remote_datasource.dart';
import 'package:trakli/data/datasources/reminder/reminder_remote_datasource.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/datasources/transfer/transfer_remote_datasource.dart';
import 'package:trakli/data/datasources/wallet/wallet_remote_datasource.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockDio extends Mock implements Dio {}

/// Thrown by the stubs once the request body has been captured: these tests
/// are about what goes out, not what comes back.
class _Captured implements Exception {}

/// A record remembers exactly one client id, so it belongs to the create call
/// and the dedicated claim request, nowhere else. Sending it on an ordinary
/// update lets a routine edit repoint a record another device is tracking —
/// which is how two local rows end up fighting over one server id.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _MockDio dio;
  Map<String, dynamic>? sent;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dio = _MockDio();
    sent = null;
  });

  tearDown(() async {
    await db.close();
  });

  Never capture(Invocation invocation) {
    sent = invocation.namedArguments[const Symbol('data')]
        as Map<String, dynamic>?;
    throw _Captured();
  }

  void stubPost() {
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((i) async => capture(i));
  }

  void stubPut() {
    when(() => dio.put(any(), data: any(named: 'data')))
        .thenAnswer((i) async => capture(i));
  }

  Future<void> expectCaptured(Future<void> Function() call) {
    return expectLater(call(), throwsA(isA<_Captured>()));
  }

  group('wallets', () {
    late Wallet wallet;

    setUp(() async {
      wallet = await db.wallets.insertReturning(WalletsCompanion.insert(
        name: 'Cash',
        type: WalletType.cash,
        currency: 'USD',
        id: const Value(41),
        clientId: const Value('device:wallet'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = WalletRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertWallet(wallet));

      expect(sent!['client_id'], 'device:wallet');
    });

    test('update does not', () async {
      stubPut();
      final source = WalletRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateWallet(wallet));

      expect(sent, isNot(contains('client_id')));
    });

    test('claiming still does', () async {
      stubPut();
      final source = WalletRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.claimClientId(
            id: 41,
            clientId: 'device:wallet',
            updatedAt: DateTime(2026, 9, 9),
          ));

      expect(sent!['client_id'], 'device:wallet');
    });
  });

  group('groups', () {
    late Group group;

    setUp(() async {
      group = await db.groups.insertReturning(GroupsCompanion.insert(
        name: 'Household',
        id: const Value(5),
        clientId: const Value('device:group'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = GroupRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertGroup(group));

      expect(sent!['client_id'], 'device:group');
    });

    test('update does not', () async {
      stubPut();
      final source = GroupRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateGroup(group));

      expect(sent, isNot(contains('client_id')));
    });
  });

  group('parties', () {
    late Party party;

    setUp(() async {
      party = await db.parties.insertReturning(PartiesCompanion.insert(
        name: 'Jane Doe',
        id: const Value(7),
        clientId: const Value('device:party'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = PartyRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertParty(party));

      expect(sent!['client_id'], 'device:party');
    });

    test('update does not', () async {
      stubPut();
      final source = PartyRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateParty(party));

      expect(sent, isNot(contains('client_id')));
    });
  });

  group('categories', () {
    late Category category;

    setUp(() async {
      category = await db.categories.insertReturning(CategoriesCompanion.insert(
        name: 'Rent',
        slug: 'rent',
        type: TransactionType.expense,
        id: const Value(9),
        clientId: const Value('device:category'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = CategoryRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertCategory(category));

      expect(sent!['client_id'], 'device:category');
    });

    test('update does not', () async {
      stubPut();
      final source = CategoryRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateCategory(category));

      expect(sent, isNot(contains('client_id')));
    });
  });

  group('configurations', () {
    late Config config;

    setUp(() async {
      config = await db.configs.insertReturning(ConfigsCompanion.insert(
        key: 'wallets.allow_negative_balance',
        type: ConfigType.bool,
        value: true,
        id: const Value(3),
        clientId: const Value('device:config'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = ConfigRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertConfig(config));

      expect(sent!['client_id'], 'device:config');
    });

    test('update does not', () async {
      stubPut();
      final source = ConfigRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateConfig(config));

      expect(sent, isNot(contains('client_id')));
    });

    test('claiming still does', () async {
      stubPut();
      final source = ConfigRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.claimClientId(
            key: config.key,
            clientId: 'device:config',
            updatedAt: DateTime(2026, 9, 9),
            value: config.value,
          ));

      expect(sent!['client_id'], 'device:config');
      // PUT /configurations/{key} documents `value` as required, so the claim
      // must carry it or the validator rejects it before the id is recorded.
      expect(sent!['value'], config.value);
    });
  });

  group('reminders', () {
    late Reminder reminder;

    setUp(() async {
      reminder = await db.reminders.insertReturning(RemindersCompanion.insert(
        title: 'Log today',
        id: const Value(4),
        clientId: const Value('device:reminder'),
      ));
    });

    test('create sends the client id', () async {
      stubPost();
      final source = ReminderRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.insertReminder(reminder));

      expect(sent!['client_id'], 'device:reminder');
    });

    test('update does not', () async {
      stubPut();
      final source = ReminderRemoteDataSourceImpl(dio: dio);

      await expectCaptured(() => source.updateReminder(reminder));

      expect(sent, isNot(contains('client_id')));
    });
  });

  group('transfers', () {
    test('the create body carries the client id, the update body does not',
        () async {
      final transfer = await db.transfers.insertReturning(
        TransfersCompanion.insert(
          amount: 25,
          datetime: DateTime(2026, 9, 9),
          id: const Value(12),
          clientId: const Value('device:transfer'),
        ),
      );

      final source = TransferRemoteDataSourceImpl(dio: dio);

      stubPost();
      await expectCaptured(() => source.insertTransfer(transfer));
      expect(sent!['client_id'], 'device:transfer');

      stubPut();
      await expectCaptured(() => source.updateTransfer(transfer));
      expect(sent, isNot(contains('client_id')));

      stubPut();
      await expectCaptured(() => source.claimClientId(
            id: transfer.id!,
            clientId: transfer.clientId,
            updatedAt: DateTime(2026, 9, 9),
          ));
      expect(sent!['client_id'], 'device:transfer');
    });
  });

  group('budgets', () {
    test('the create body carries the client id, the update body does not',
        () async {
      final budget = await db.budgets.insertReturning(BudgetsCompanion.insert(
        name: 'Groceries',
        slug: 'groceries',
        amount: 500,
        currency: 'USD',
        periodType: BudgetPeriodType.monthly,
        startDate: DateTime(2026, 9),
        id: const Value(21),
        clientId: const Value('device:budget'),
      ));
      final dto = BudgetCompleteDto(budget: budget);

      final source = BudgetRemoteDataSourceImpl(dio: dio);

      stubPost();
      await expectCaptured(() => source.insertBudget(dto));
      expect(sent!['client_id'], 'device:budget');

      stubPut();
      await expectCaptured(() => source.updateBudget(dto));
      expect(sent, isNot(contains('client_id')));
    });
  });

  group('transactions', () {
    test('the create body carries the client id, the update body does not',
        () async {
      final wallet = await db.wallets.insertReturning(WalletsCompanion.insert(
        name: 'Cash',
        type: WalletType.cash,
        currency: 'USD',
        id: const Value(41),
        clientId: const Value('device:wallet'),
      ));
      final transaction = await db.transactions.insertReturning(
        TransactionsCompanion.insert(
          amount: 10,
          type: TransactionType.expense,
          walletClientId: wallet.clientId,
          id: const Value(31),
          clientId: const Value('device:transaction'),
        ),
      );
      final dto = TransactionCompleteDto(
        transaction: transaction,
        wallet: wallet,
      );

      final source = TransactionRemoteDataSourceImpl(dio: dio);

      stubPost();
      await expectCaptured(() => source.insertTransaction(dto));
      expect(sent!['client_id'], 'device:transaction');

      stubPut();
      await expectCaptured(() => source.updateTransaction(dto));
      expect(sent, isNot(contains('client_id')));
      // The drift row spread names it client_generated_id; neither spelling
      // may ride along on an update.
      expect(sent, isNot(contains('client_generated_id')));
    });
  });
}
