import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/add_transaction_form_compact_layout.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/forms/add_transaction_form.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class _MockTransactionCubit extends MockCubit<TransactionState>
    implements TransactionCubit {}

class _MockGroupCubit extends MockCubit<GroupState> implements GroupCubit {}

class _MockPartyCubit extends MockCubit<PartyState> implements PartyCubit {}

class _MockCategoryCubit extends MockCubit<CategoryState>
    implements CategoryCubit {}

class _MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class _MockConfigCubit extends MockCubit<ConfigState> implements ConfigCubit {}

class _MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

void main() {
  final now = DateTime(2026, 1, 1);
  final household = GroupEntity(
    clientId: 'group-household',
    name: 'Household',
    createdAt: now,
    updatedAt: now,
  );
  final business = GroupEntity(
    clientId: 'group-business',
    name: 'Business',
    createdAt: now,
    updatedAt: now,
  );
  final wallet = WalletEntity(
    clientId: 'wallet-1',
    type: WalletType.cash,
    name: 'Cash',
    balance: 0,
    currencyCode: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(TransactionType.expense);
    registerFallbackValue(TransactionIntent.regular);
    registerFallbackValue(now);
    registerFallbackValue(const RecurrenceInput(period: 'monthly'));
  });

  final groceries = CategoryEntity(
    clientId: 'category-1',
    type: TransactionType.expense,
    name: 'Groceries',
    createdAt: now,
    updatedAt: now,
  );
  final defaultWalletConfig = ConfigEntity(
    id: 1,
    userId: 1,
    key: ConfigConstants.defaultWallet,
    type: ConfigType.string,
    value: wallet.clientId,
    createdAt: now,
    updatedAt: now,
  );

  late _MockTransactionCubit transactionCubit;
  late _MockGroupCubit groupCubit;
  late _MockPartyCubit partyCubit;
  late _MockCategoryCubit categoryCubit;
  late _MockWalletCubit walletCubit;
  late _MockConfigCubit configCubit;
  late _MockCurrencyCubit currencyCubit;

  setUp(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .views
        .first;
    view.physicalSize = const Size(600, 2400);
    view.devicePixelRatio = 1.0;

    transactionCubit = _MockTransactionCubit();
    groupCubit = _MockGroupCubit();
    partyCubit = _MockPartyCubit();
    categoryCubit = _MockCategoryCubit();
    walletCubit = _MockWalletCubit();
    configCubit = _MockConfigCubit();
    currencyCubit = _MockCurrencyCubit();

    when(() => transactionCubit.state)
        .thenReturn(TransactionState.initial().copyWith(
      selectedGroup: household,
    ));
    when(() => groupCubit.state)
        .thenReturn(GroupState(groups: [household, business]));
    when(() => partyCubit.state).thenReturn(PartyState.initial());
    when(() => categoryCubit.state)
        .thenReturn(CategoryState.initial().copyWith(categories: [groceries]));
    when(() => walletCubit.state)
        .thenReturn(WalletState.initial().copyWith(wallets: [wallet]));
    when(() => configCubit.state).thenReturn(
        ConfigState.initial().copyWith(configs: [defaultWalletConfig]));
    when(() => currencyCubit.state).thenReturn(const CurrencyState.initial());
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

  tearDown(() {
    final view = TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .views
        .first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  TransactionCompleteEntity existingTransaction(GroupEntity? group) {
    return TransactionCompleteEntity(
      transaction: TransactionEntity(
        clientId: 'tx-1',
        amount: 25,
        description: 'Supplies',
        createdAt: now,
        updatedAt: now,
        datetime: now,
        type: TransactionType.expense,
        walletClientId: wallet.clientId,
        groupClientId: group?.clientId,
      ),
      categories: [groceries],
      wallet: wallet,
      group: group,
    );
  }

  Future<void> pumpForm(WidgetTester tester, Widget form) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(600, 2400),
        builder: (context, _) => MaterialApp(
          theme: ThemeData(
            extensions: const [AppTones.light, AppElevations.light],
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<TransactionCubit>.value(value: transactionCubit),
              BlocProvider<GroupCubit>.value(value: groupCubit),
              BlocProvider<PartyCubit>.value(value: partyCubit),
              BlocProvider<CategoryCubit>.value(value: categoryCubit),
              BlocProvider<WalletCubit>.value(value: walletCubit),
              BlocProvider<ConfigCubit>.value(value: configCubit),
              BlocProvider<CurrencyCubit>.value(value: currencyCubit),
            ],
            child: Scaffold(body: form),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> tapSave(WidgetTester tester) async {
    final save = find.byType(ElevatedButton).last;
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pump();
  }

  String? capturedAddGroup() => verify(() => transactionCubit.addTransaction(
        amount: any(named: 'amount'),
        description: any(named: 'description'),
        categoryIds: any(named: 'categoryIds'),
        type: any(named: 'type'),
        intent: any(named: 'intent'),
        datetime: any(named: 'datetime'),
        walletClientId: any(named: 'walletClientId'),
        partyClientId: any(named: 'partyClientId'),
        groupClientId: captureAny(named: 'groupClientId'),
        attachedFilePaths: any(named: 'attachedFilePaths'),
        recurrence: any(named: 'recurrence'),
        isRefund: any(named: 'isRefund'),
        refundOfClientId: any(named: 'refundOfClientId'),
      )).captured.single as String?;

  String? capturedUpdateGroup() =>
      verify(() => transactionCubit.updateTransaction(
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
          )).captured.single as String?;

  Finder groupField() => find.descendant(
        of: find.byKey(const ValueKey('transaction-group-picker')),
        matching: find.byType(TextField),
      );

  group('compact layout', () {
    testWidgets('a new transaction defaults to the active group',
        (tester) async {
      await pumpForm(
        tester,
        const AddTransactionFormCompactLayout(accentColor: Colors.red),
      );

      expect(
          tester.widget<TextField>(groupField()).controller!.text, 'Household');

      await tester.enterText(find.byType(TextFormField).first, '12');
      await tapSave(tester);

      expect(capturedAddGroup(), household.clientId);
    });

    testWidgets('a group picked on the form is saved with a new transaction',
        (tester) async {
      await pumpForm(
        tester,
        const AddTransactionFormCompactLayout(accentColor: Colors.red),
      );

      await tester.ensureVisible(groupField());
      await tester.enterText(groupField(), 'Bus');
      await tester.pump();
      await tester.tap(find.widgetWithText(ListTile, 'Business'));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).first, '12');
      await tapSave(tester);

      expect(capturedAddGroup(), business.clientId);
    });

    testWidgets('editing pre-fills and keeps the transaction group',
        (tester) async {
      await pumpForm(
        tester,
        AddTransactionFormCompactLayout(
          accentColor: Colors.red,
          transactionType: TransactionType.expense,
          transactionCompleteEntity: existingTransaction(business),
        ),
      );

      expect(
          tester.widget<TextField>(groupField()).controller!.text, 'Business');

      await tapSave(tester);

      expect(capturedUpdateGroup(), business.clientId);
    });

    testWidgets('the picker is hidden when there are no groups',
        (tester) async {
      when(() => groupCubit.state).thenReturn(GroupState.initial());
      await pumpForm(
        tester,
        const AddTransactionFormCompactLayout(accentColor: Colors.red),
      );

      expect(
          find.byKey(const ValueKey('transaction-group-picker')), findsNothing);
    });
  });

  group('full form', () {
    testWidgets('editing pre-fills and keeps the transaction group',
        (tester) async {
      await pumpForm(
        tester,
        AddTransactionForm(
          accentColor: Colors.red,
          transactionType: TransactionType.expense,
          transactionCompleteEntity: existingTransaction(business),
        ),
      );

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('transaction-group-picker')),
          matching: find.text('Business'),
        ),
        findsOneWidget,
      );

      await tapSave(tester);

      expect(capturedUpdateGroup(), business.clientId);
    });

    testWidgets('a new transaction defaults to the active group',
        (tester) async {
      await pumpForm(
        tester,
        const AddTransactionForm(accentColor: Colors.red),
      );

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('transaction-group-picker')),
          matching: find.text('Household'),
        ),
        findsOneWidget,
      );
    });
  });
}
