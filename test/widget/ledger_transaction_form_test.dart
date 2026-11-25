import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_form.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/theme.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class _MockTransactionCubit extends MockCubit<TransactionState>
    implements TransactionCubit {}

class _MockGroupCubit extends MockCubit<GroupState> implements GroupCubit {}

class _MockPartyCubit extends MockCubit<PartyState> implements PartyCubit {}

class _MockCategoryCubit extends MockCubit<CategoryState>
    implements CategoryCubit {}

class _MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class _MockConfigCubit extends MockCubit<ConfigState> implements ConfigCubit {}

void main() {
  final now = DateTime(2026, 1, 1);
  WalletEntity wallet(String id, String name, WalletType type) => WalletEntity(
        clientId: id,
        type: type,
        name: name,
        balance: 0,
        currencyCode: 'EUR',
        createdAt: now,
        updatedAt: now,
      );
  final main = wallet('w-main', 'Main account', WalletType.bank);
  final cash = wallet('w-cash', 'Cash', WalletType.cash);
  final groceries = CategoryEntity(
    clientId: 'c-groc',
    type: TransactionType.expense,
    name: 'Groceries',
    createdAt: now,
  );
  final paidBack = CategoryEntity(
    clientId: 'c-back',
    type: TransactionType.income,
    name: 'Paid back',
    createdAt: now,
  );
  final tomas = PartyEntity(
    clientId: 'p-tomas',
    name: 'Tomás Reyes',
    createdAt: now,
    updatedAt: now,
  );
  final household = GroupEntity(
    clientId: 'g-house',
    name: 'Household',
    createdAt: now,
    updatedAt: now,
  );
  final business = GroupEntity(
    clientId: 'g-biz',
    name: 'Business',
    createdAt: now,
    updatedAt: now,
  );

  late _MockTransactionCubit transactionCubit;
  late _MockGroupCubit groupCubit;
  late _MockPartyCubit partyCubit;
  late _MockCategoryCubit categoryCubit;
  late _MockWalletCubit walletCubit;
  late _MockConfigCubit configCubit;

  setUpAll(() {
    registerFallbackValue(TransactionType.expense);
    registerFallbackValue(TransactionIntent.regular);
    registerFallbackValue(now);
    registerFallbackValue(const RecurrenceInput(period: 'monthly'));
  });

  setUp(() {
    transactionCubit = _MockTransactionCubit();
    groupCubit = _MockGroupCubit();
    partyCubit = _MockPartyCubit();
    categoryCubit = _MockCategoryCubit();
    walletCubit = _MockWalletCubit();
    configCubit = _MockConfigCubit();

    when(() => transactionCubit.state).thenReturn(
        TransactionState.initial().copyWith(selectedGroup: household));
    when(() => groupCubit.state)
        .thenReturn(GroupState(groups: [household, business]));
    when(() => partyCubit.state)
        .thenReturn(PartyState.initial().copyWith(parties: [tomas]));
    when(() => categoryCubit.state).thenReturn(
        CategoryState.initial().copyWith(categories: [groceries, paidBack]));
    when(() => walletCubit.state)
        .thenReturn(WalletState.initial().copyWith(wallets: [main, cash]));
    when(() => configCubit.state).thenReturn(
      ConfigState.initial().copyWith(configs: [
        ConfigEntity(
          id: 1,
          userId: 1,
          key: ConfigConstants.defaultWallet,
          type: ConfigType.string,
          value: main.clientId,
          createdAt: now,
          updatedAt: now,
        ),
      ]),
    );
    when(() => transactionCubit.addTransaction(
          amount: any(named: 'amount'),
          description: any(named: 'description'),
          categoryIds: any(named: 'categoryIds'),
          type: any(named: 'type'),
          intent: any(named: 'intent'),
          datetime: any(named: 'datetime'),
          walletClientId: any(named: 'walletClientId'),
          partyClientId: any(named: 'partyClientId'),
          groupClientId: any(named: 'groupClientId'),
          attachedFilePaths: any(named: 'attachedFilePaths'),
          recurrence: any(named: 'recurrence'),
          isRefund: any(named: 'isRefund'),
          refundOfClientId: any(named: 'refundOfClientId'),
        )).thenAnswer((_) async {});
    when(() => transactionCubit.updateTransaction(
          id: any(named: 'id'),
          amount: any(named: 'amount'),
          description: any(named: 'description'),
          categoryIds: any(named: 'categoryIds'),
          datetime: any(named: 'datetime'),
          walletClientId: any(named: 'walletClientId'),
          intent: any(named: 'intent'),
          partyClientId: any(named: 'partyClientId'),
          groupClientId: any(named: 'groupClientId'),
          attachedFilePaths: any(named: 'attachedFilePaths'),
          recurrence: any(named: 'recurrence'),
          clearRecurrence: any(named: 'clearRecurrence'),
          isRefund: any(named: 'isRefund'),
          refundOfClientId: any(named: 'refundOfClientId'),
        )).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, Widget form) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TransactionCubit>.value(value: transactionCubit),
          BlocProvider<GroupCubit>.value(value: groupCubit),
          BlocProvider<PartyCubit>.value(value: partyCubit),
          BlocProvider<CategoryCubit>.value(value: categoryCubit),
          BlocProvider<WalletCubit>.value(value: walletCubit),
          BlocProvider<ConfigCubit>.value(value: configCubit),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, __) => MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(body: form),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> pick(WidgetTester tester, String rowKey, String item) async {
    await tester.tap(find.byKey(ValueKey(rowKey)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(item).last);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('ledger-tx-save')));
    await tester.pump();
  }

  void verifyAdd({
    double? amount,
    String? description,
    List<String>? categoryIds,
    TransactionType? type,
    TransactionIntent? intent,
    String? walletClientId,
    String? partyClientId,
    String? groupClientId,
  }) {
    verify(() => transactionCubit.addTransaction(
          amount: amount ?? any(named: 'amount'),
          description: description ?? any(named: 'description'),
          categoryIds: categoryIds ?? any(named: 'categoryIds'),
          type: type ?? any(named: 'type'),
          intent: intent ?? any(named: 'intent'),
          datetime: any(named: 'datetime'),
          walletClientId: walletClientId ?? any(named: 'walletClientId'),
          partyClientId: partyClientId ?? any(named: 'partyClientId'),
          groupClientId: groupClientId ?? any(named: 'groupClientId'),
          attachedFilePaths: any(named: 'attachedFilePaths'),
          recurrence: any(named: 'recurrence'),
          isRefund: any(named: 'isRefund'),
          refundOfClientId: any(named: 'refundOfClientId'),
        )).called(1);
  }

  testWidgets('saves every picked field through addTransaction',
      (tester) async {
    await pump(
      tester,
      const LedgerTransactionForm(transactionType: TransactionType.income),
    );

    await tester.enterText(
        find.byKey(const ValueKey('ledger-tx-amount')), '40');
    await pick(tester, 'ledger-tx-category', 'Paid back');
    await pick(tester, 'ledger-tx-wallet', 'Cash');
    await pick(tester, 'ledger-tx-party', 'Tomás Reyes');
    await pick(tester, 'transaction-group-picker', 'Business');
    await tester.tap(find.byKey(const ValueKey('ledger-intent-debt_owed')));
    await tester.pump();
    await tester.enterText(
        find.byKey(const ValueKey('ledger-tx-note')), 'First half');
    await save(tester);

    verifyAdd(
      amount: 40,
      description: 'First half',
      categoryIds: ['c-back'],
      type: TransactionType.income,
      intent: TransactionIntent.debtOwed,
      walletClientId: 'w-cash',
      partyClientId: 'p-tomas',
      groupClientId: 'g-biz',
    );
  });

  testWidgets('adding a new party opens the add party screen',
      (tester) async {
    await pump(
      tester,
      const LedgerTransactionForm(transactionType: TransactionType.expense),
    );

    await tester.tap(find.byKey(const ValueKey('ledger-tx-party')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(LocaleKeys.txFormAddNew.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(AddPartyScreen), findsOneWidget);
  });

  testWidgets('a new transaction defaults to the active group and wallet',
      (tester) async {
    await pump(tester, const LedgerTransactionForm());
    expect(find.text('Household'), findsOneWidget);

    await tester.enterText(
        find.byKey(const ValueKey('ledger-tx-amount')), '12.5');
    await pick(tester, 'ledger-tx-category', 'Groceries');
    await save(tester);

    verifyAdd(
      amount: 12.5,
      categoryIds: ['c-groc'],
      type: TransactionType.expense,
      intent: TransactionIntent.regular,
      walletClientId: 'w-main',
      groupClientId: 'g-house',
    );
  });

  testWidgets('only offers intents valid for the type', (tester) async {
    await pump(tester, const LedgerTransactionForm());
    expect(find.byKey(const ValueKey('ledger-intent-debt_settled')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey('ledger-intent-debt_owed')), findsNothing);
  });

  testWidgets('does not save without a category', (tester) async {
    await pump(tester, const LedgerTransactionForm());
    await tester.enterText(
        find.byKey(const ValueKey('ledger-tx-amount')), '12');
    await save(tester);
    verifyNever(() => transactionCubit.addTransaction(
          amount: any(named: 'amount'),
          description: any(named: 'description'),
          categoryIds: any(named: 'categoryIds'),
          type: any(named: 'type'),
          intent: any(named: 'intent'),
          datetime: any(named: 'datetime'),
          walletClientId: any(named: 'walletClientId'),
          partyClientId: any(named: 'partyClientId'),
          groupClientId: any(named: 'groupClientId'),
          attachedFilePaths: any(named: 'attachedFilePaths'),
          recurrence: any(named: 'recurrence'),
          isRefund: any(named: 'isRefund'),
          refundOfClientId: any(named: 'refundOfClientId'),
        ));
  });

  testWidgets('prefills from the initial values', (tester) async {
    await pump(
      tester,
      LedgerTransactionForm(
        transactionType: TransactionType.income,
        initialParty: tomas,
        initialIntent: TransactionIntent.debtOwed,
        initialAmount: 80,
        initialCategory: paidBack,
        initialWallet: cash,
      ),
    );
    await save(tester);
    verifyAdd(
      amount: 80,
      intent: TransactionIntent.debtOwed,
      walletClientId: 'w-cash',
      partyClientId: 'p-tomas',
      categoryIds: ['c-back'],
    );
  });

  testWidgets('editing keeps the transaction group and updates it',
      (tester) async {
    final existing = TransactionCompleteEntity(
      transaction: TransactionEntity(
        clientId: 'tx-1',
        amount: 25,
        description: 'Supplies',
        createdAt: now,
        updatedAt: now,
        datetime: now,
        type: TransactionType.expense,
        walletClientId: main.clientId,
        groupClientId: business.clientId,
      ),
      categories: [groceries],
      wallet: main,
      group: business,
    );
    await pump(
      tester,
      LedgerTransactionForm(
        transactionType: TransactionType.expense,
        transactionCompleteEntity: existing,
      ),
    );
    await save(tester);
    final group = verify(() => transactionCubit.updateTransaction(
          id: any(named: 'id'),
          amount: any(named: 'amount'),
          description: any(named: 'description'),
          categoryIds: any(named: 'categoryIds'),
          datetime: any(named: 'datetime'),
          walletClientId: any(named: 'walletClientId'),
          intent: any(named: 'intent'),
          partyClientId: any(named: 'partyClientId'),
          groupClientId: captureAny(named: 'groupClientId'),
          attachedFilePaths: any(named: 'attachedFilePaths'),
          recurrence: any(named: 'recurrence'),
          clearRecurrence: any(named: 'clearRecurrence'),
          isRefund: any(named: 'isRefund'),
          refundOfClientId: any(named: 'refundOfClientId'),
        )).captured.single;
    expect(group, business.clientId);
  });
}
