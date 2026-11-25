import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/statistics/cubit/statistics_filter_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

/// Sample ledger used only to render screenshots. Dates are relative to
/// [ShotData.now] so "today" and "this month" sections always have content.
class ShotData {
  ShotData._();

  static final DateTime now = DateTime.now();
  static DateTime day(int daysAgo, [int hour = 12]) {
    final d = now.subtract(Duration(days: daysAgo));
    return DateTime(d.year, d.month, d.day, hour);
  }

  static final DateTime _t0 = DateTime(2025, 1, 1);

  static MediaEntity _icon(String name) =>
      MediaEntity(mediaType: MediaType.icon, content: name);

  static CategoryEntity _cat(String id, String name, TransactionType type,
          [String? icon]) =>
      CategoryEntity(
        clientId: id,
        type: type,
        name: name,
        createdAt: _t0,
        icon: icon == null ? null : _icon(icon),
      );

  static final rent = _cat('c-rent', 'Rent', TransactionType.expense, 'home');
  static final groceries =
      _cat('c-groc', 'Groceries', TransactionType.expense, 'shoppingCart');
  static final eating =
      _cat('c-eat', 'Eating out', TransactionType.expense, 'cake');
  static final transport =
      _cat('c-trans', 'Transport', TransactionType.expense, 'truck');
  static final subs =
      _cat('c-subs', 'Subscriptions', TransactionType.expense, 'arrowPath');
  static final shopping =
      _cat('c-shop', 'Shopping', TransactionType.expense, 'shoppingBag');
  static final utilities =
      _cat('c-util', 'Utilities', TransactionType.expense, 'bolt');
  static final salary =
      _cat('c-sal', 'Salary', TransactionType.income, 'briefcase');
  static final freelance =
      _cat('c-free', 'Freelance', TransactionType.income, 'pencil');
  static final refunds =
      _cat('c-ref', 'Refunds', TransactionType.income, 'arrowUturnLeft');

  static final categories = [
    rent,
    groceries,
    eating,
    transport,
    subs,
    shopping,
    utilities,
    salary,
    freelance,
    refunds,
  ];

  static WalletEntity _wallet(String id, String name, WalletType type,
          String currency, double balance) =>
      WalletEntity(
        clientId: id,
        type: type,
        name: name,
        balance: balance,
        currencyCode: currency,
        createdAt: _t0,
        updatedAt: _t0,
      );

  static final main =
      _wallet('w-main', 'Main account', WalletType.bank, 'EUR', 3412.80);
  static final savings =
      _wallet('w-sav', 'Savings', WalletType.bank, 'EUR', 8950);
  static final momo =
      _wallet('w-momo', 'MTN MoMo', WalletType.mobile, 'XAF', 184500);
  static final cash = _wallet('w-cash', 'Cash', WalletType.cash, 'EUR', 62.50);
  static final wallets = [main, savings, momo, cash];

  static PartyEntity _party(String id, String name, [PartyType? type]) =>
      PartyEntity(
        clientId: id,
        name: name,
        createdAt: _t0,
        updatedAt: _t0,
        type: type ?? PartyType.individual,
      );

  static final tomas = _party('p-tomas', 'Tomás Reyes');
  static final lucas = _party('p-lucas', 'Lucas Martin');
  static final chezLou = _party('p-chez', 'Chez Lou', PartyType.business);
  static final studio = _party('p-studio', 'Studio Nka', PartyType.business);
  static final parties = [tomas, lucas, chezLou, studio];

  static final household = GroupEntity(
    clientId: 'g-house',
    name: 'Household',
    createdAt: _t0,
    updatedAt: _t0,
  );
  static final groups = [household];

  static int _seq = 0;
  static TransactionCompleteEntity tx(
    int daysAgo,
    String desc,
    double amount,
    TransactionType type,
    WalletEntity wallet, {
    CategoryEntity? category,
    PartyEntity? party,
    TransactionIntent intent = TransactionIntent.regular,
    int hour = 12,
  }) {
    _seq++;
    final when = day(daysAgo, hour);
    return TransactionCompleteEntity(
      transaction: TransactionEntity(
        clientId: 'tx-$_seq',
        id: _seq,
        amount: amount,
        description: desc,
        createdAt: when,
        updatedAt: when,
        datetime: when,
        type: type,
        intent: intent,
        walletClientId: wallet.clientId,
        partyClientId: party?.clientId,
      ),
      categories: category == null ? const [] : [category],
      wallet: wallet,
      party: party,
    );
  }

  static const _e = TransactionType.expense;
  static const _i = TransactionType.income;

  static final List<TransactionCompleteEntity> transactions = [
    tx(0, 'Lunch at Chez Lou', 12.50, _e, cash,
        category: eating, party: chezLou, hour: 13),
    tx(0, 'Bolt ride home', 8.40, _e, main, category: transport, hour: 9),
    tx(1, 'Carrefour Market', 64.30, _e, main, category: groceries),
    tx(1, 'Netflix', 13.99, _e, main, category: subs),
    tx(2, 'Logo for Studio Nka', 380, _i, main,
        category: freelance, party: studio),
    tx(2, 'Pharmacie du Centre', 18.20, _e, main, category: shopping),
    tx(3, 'Tomás paid back', 40, _i, cash,
        party: tomas, intent: TransactionIntent.debtOwed),
    tx(3, 'MTN airtime', 5000, _e, momo, category: utilities),
    tx(4, 'Zara', 79.95, _e, main, category: shopping),
    tx(4, 'Café Nuit', 21.40, _e, cash, category: eating),
    tx(5, 'Carrefour Market', 52.10, _e, main, category: groceries),
    tx(5, 'Uber Eats', 27.80, _e, main, category: eating),
    tx(6, 'EDF electricity', 96, _e, main, category: utilities),
    tx(6, 'Navigo monthly pass', 75, _e, main, category: transport),
    tx(7, 'Zara return', 70, _i, main, category: refunds),
    tx(10, 'Spotify', 10.99, _e, main, category: subs),
    tx(12, 'Lent to Tomás', 120, _e, cash,
        party: tomas, intent: TransactionIntent.debtSettled),
    tx(13, 'Uber Eats', 43.40, _e, main, category: eating),
    tx(15, 'Chez Lou', 41.50, _e, cash, category: eating, party: chezLou),
    tx(17, 'Carrefour Market', 88.20, _e, main, category: groceries),
    tx(19, 'Café Nuit', 38.60, _e, cash, category: eating),
    tx(22, 'Salary, Atelier Vert', 3600, _i, main, category: salary),
    tx(22, 'Monthly rent', 1050, _e, main, category: rent),
    tx(35, 'Carrefour Market', 98.10, _e, main, category: groceries),
    tx(40, 'Uber Eats', 33.10, _e, main, category: eating),
    tx(52, 'Salary, Atelier Vert', 3600, _i, main, category: salary),
    tx(52, 'Monthly rent', 1050, _e, main, category: rent),
  ];

  static final budgetEating = BudgetEntity(
    clientId: 'b-eat',
    id: 1,
    name: 'Eating out',
    amount: 180,
    currency: 'EUR',
    periodType: BudgetPeriodType.monthly,
    startDate: DateTime(now.year, now.month, 1),
    targets: const [
      BudgetTargetEntity(
        type: BudgetTargetType.category,
        clientId: 'c-eat',
        name: 'Eating out',
      ),
    ],
    progress: BudgetProgressEntity(
      periodStart: DateTime(now.year, now.month, 1),
      periodEnd: DateTime(now.year, now.month + 1, 0),
      limit: 180,
      grossSpent: 214.60,
      refunds: 0,
      netSpent: 214.60,
      rolloverIn: 0,
      effectiveLimit: 180,
      remaining: -34.60,
      percentUsed: 119.2,
      projectedSpend: 268,
      status: BudgetStatus.overBudget,
      isThresholdCrossed: true,
      isForecastBreach: true,
    ),
    createdAt: _t0,
  );

  static final budgets = [budgetEating];

  static List<ReminderEntity> get reminders => [
        ReminderEntity(
          clientId: 'r-spotify',
          title: 'Spotify',
          description: 'Subscriptions',
          type: ReminderType.billDue,
          dueAt: day(-4),
          nextTriggerAt: day(-4),
          createdAt: _t0,
          updatedAt: _t0,
        ),
        ReminderEntity(
          clientId: 'r-rent',
          title: 'Rent',
          description: 'Main account',
          type: ReminderType.billDue,
          dueAt: day(-7),
          nextTriggerAt: day(-7),
          createdAt: _t0,
          updatedAt: _t0,
        ),
      ];

  static final exchangeRate = ExchangeRateEntity(
    provider: 'test',
    baseCode: 'EUR',
    rates: const {'EUR': 1.0, 'XAF': 655.957, 'USD': 1.08},
    timeLastUpdated: _t0,
    timeNextUpdated: _t0,
  );

  static final configs = [
    ConfigEntity(
      id: 1,
      userId: 1,
      key: ConfigConstants.defaultCurrency,
      type: ConfigType.string,
      value: 'EUR',
      createdAt: _t0,
      updatedAt: _t0,
    ),
    ConfigEntity(
      id: 2,
      userId: 1,
      key: ConfigConstants.defaultWallet,
      type: ConfigType.string,
      value: 'w-main',
      createdAt: _t0,
      updatedAt: _t0,
    ),
  ];

  static const user = UserEntity(
    id: 1,
    firstName: 'Maya',
    lastName: 'Achu',
    email: 'maya@example.com',
  );
}

class MockTransactionCubit extends Mock implements TransactionCubit {}

class MockWalletCubit extends Mock implements WalletCubit {}

class MockCategoryCubit extends Mock implements CategoryCubit {}

class MockPartyCubit extends Mock implements PartyCubit {}

class MockGroupCubit extends Mock implements GroupCubit {}

class MockConfigCubit extends Mock implements ConfigCubit {}

class MockCurrencyCubit extends Mock implements CurrencyCubit {}

class MockExchangeRateCubit extends Mock implements ExchangeRateCubit {}

class MockAuthCubit extends Mock implements AuthCubit {}

class MockBudgetCubit extends Mock implements BudgetCubit {}

class MockReminderCubit extends Mock implements ReminderCubit {}

class MockStatisticsFilterCubit extends Mock implements StatisticsFilterCubit {}

T _stub<T extends StateStreamableSource<S>, S>(T cubit, S state) {
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  return cubit;
}

/// Mocked app-level cubits populated from [ShotData]. Extra providers for a
/// specific screen can be passed in [extra].
Widget withShotProviders(
  Widget child, {
  List<TransactionCompleteEntity>? transactions,
  List<BlocProvider> extra = const [],
}) {
  final txs = transactions ?? ShotData.transactions;
  return MultiBlocProvider(
    providers: [
      BlocProvider<TransactionCubit>.value(
        value: _stub(
          MockTransactionCubit(),
          TransactionState.initial()
              .copyWith(transactions: txs, wallets: ShotData.wallets),
        ),
      ),
      BlocProvider<WalletCubit>.value(
        value: _stub(
          MockWalletCubit(),
          WalletState.initial().copyWith(wallets: ShotData.wallets),
        ),
      ),
      BlocProvider<CategoryCubit>.value(
        value: _stub(
          MockCategoryCubit(),
          CategoryState.initial().copyWith(categories: ShotData.categories),
        ),
      ),
      BlocProvider<PartyCubit>.value(
        value: _stub(
          MockPartyCubit(),
          PartyState.initial().copyWith(parties: ShotData.parties),
        ),
      ),
      BlocProvider<GroupCubit>.value(
        value: _stub(MockGroupCubit(), GroupState(groups: ShotData.groups)),
      ),
      BlocProvider<ConfigCubit>.value(
        value: _stub(
          MockConfigCubit(),
          ConfigState.initial().copyWith(configs: ShotData.configs),
        ),
      ),
      BlocProvider<CurrencyCubit>.value(
        value: _stub(
          MockCurrencyCubit(),
          CurrencyState.loaded(CurrencyService().findByCode('EUR')!),
        ),
      ),
      BlocProvider<ExchangeRateCubit>.value(
        value: _stub(
          MockExchangeRateCubit(),
          ExchangeRateState.success(ShotData.exchangeRate),
        ),
      ),
      BlocProvider<AuthCubit>.value(
        value: _stub(
          MockAuthCubit(),
          const AuthState.authenticated(ShotData.user),
        ),
      ),
      BlocProvider<BudgetCubit>.value(
        value: _stub(
          MockBudgetCubit(),
          BudgetState.initial().copyWith(budgets: ShotData.budgets),
        ),
      ),
      BlocProvider<ReminderCubit>.value(
        value: _stub(
          MockReminderCubit(),
          ReminderState.initial().copyWith(reminders: ShotData.reminders),
        ),
      ),
      BlocProvider<StatisticsFilterCubit>.value(
        value: _stub(
          MockStatisticsFilterCubit(),
          const StatisticsFilterState(),
        ),
      ),
      ...extra,
    ],
    child: child,
  );
}
