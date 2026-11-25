import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/budget/budget_activity.dart';
import 'package:trakli/presentation/utils/enums.dart';

final _t0 = DateTime(2025, 1, 1);

final _eating = CategoryEntity(
  clientId: 'c-eat',
  type: TransactionType.expense,
  name: 'Eating out',
  createdAt: _t0,
);

final _groceries = CategoryEntity(
  clientId: 'c-groc',
  type: TransactionType.expense,
  name: 'Groceries',
  createdAt: _t0,
);

WalletEntity _wallet(String currency) => WalletEntity(
      clientId: 'w-$currency',
      type: WalletType.bank,
      name: currency,
      balance: 0,
      currencyCode: currency,
      createdAt: _t0,
      updatedAt: _t0,
    );

var _seq = 0;
TransactionCompleteEntity _tx(
  DateTime when,
  double amount, {
  CategoryEntity? category,
  TransactionType type = TransactionType.expense,
  String currency = 'EUR',
  String? transferClientId,
}) {
  _seq++;
  return TransactionCompleteEntity(
    transaction: TransactionEntity(
      clientId: 't$_seq',
      amount: amount,
      description: '',
      createdAt: when,
      updatedAt: when,
      datetime: when,
      type: type,
      walletClientId: 'w-$currency',
      transferClientId: transferClientId,
    ),
    categories: category == null ? const [] : [category],
    wallet: _wallet(currency),
  );
}

BudgetEntity _budget({List<BudgetTargetEntity> targets = const []}) =>
    BudgetEntity(
      clientId: 'b',
      name: 'Eating out',
      amount: 180,
      currency: 'EUR',
      periodType: BudgetPeriodType.monthly,
      startDate: DateTime(2025, 11, 1),
      targets: targets,
      createdAt: _t0,
    );

void main() {
  final start = DateTime(2025, 11, 1);
  final end = DateTime(2025, 11, 30);

  group('bucketBudgetWeeks', () {
    test('a month splits into 1-7, 8-14, 15-21 and 22 to the end', () {
      final weeks = bucketBudgetWeeks(
        transactions: [
          _tx(DateTime(2025, 11, 1), 10),
          _tx(DateTime(2025, 11, 7, 23), 5),
          _tx(DateTime(2025, 11, 8), 20),
          _tx(DateTime(2025, 11, 21), 30),
          _tx(DateTime(2025, 11, 22), 1),
          _tx(DateTime(2025, 11, 30), 2),
        ],
        start: start,
        end: end,
        amountOf: (t) => t.transaction.amount,
      );

      expect(weeks.map((w) => '${w.start.day}-${w.end.day}'),
          ['1-7', '8-14', '15-21', '22-30']);
      expect(weeks.map((w) => w.amount), [15, 20, 30, 3]);
    });

    test('a running period stops the last bucket at today', () {
      final weeks = bucketBudgetWeeks(
        transactions: [_tx(DateTime(2025, 11, 24), 12.5)],
        start: start,
        end: end,
        amountOf: (t) => t.transaction.amount,
        today: DateTime(2025, 11, 24, 15),
      );

      expect(weeks.last.start.day, 22);
      expect(weeks.last.end.day, 24);
      expect(weeks.last.amount, 12.5);
    });

    test('early in the month only the elapsed weeks are shown', () {
      final weeks = bucketBudgetWeeks(
        transactions: const [],
        start: start,
        end: end,
        amountOf: (t) => t.transaction.amount,
        today: DateTime(2025, 11, 10),
      );

      expect(weeks.map((w) => '${w.start.day}-${w.end.day}'), ['1-7', '8-10']);
    });

    test('periods longer than a month are bucketed by calendar month', () {
      final weeks = bucketBudgetWeeks(
        transactions: [
          _tx(DateTime(2025, 1, 15), 10),
          _tx(DateTime(2025, 3, 2), 7),
        ],
        start: DateTime(2025, 1, 1),
        end: DateTime(2025, 3, 31),
        amountOf: (t) => t.transaction.amount,
      );

      expect(weeks.length, 3);
      expect(weeks.every((w) => w.byMonth), isTrue);
      expect(weeks.map((w) => w.amount), [10, 0, 7]);
    });
  });

  group('budgetTransactions', () {
    test('keeps expenses in the period that hit a target', () {
      final budget = _budget(targets: const [
        BudgetTargetEntity(type: BudgetTargetType.category, clientId: 'c-eat'),
      ]);
      final result = budgetTransactions(
        budget,
        [
          _tx(DateTime(2025, 11, 3), 12, category: _eating),
          _tx(DateTime(2025, 11, 4), 40, category: _groceries),
          _tx(DateTime(2025, 10, 31), 9, category: _eating),
          _tx(DateTime(2025, 11, 5), 70,
              category: _eating, type: TransactionType.income),
          _tx(DateTime(2025, 11, 6), 30,
              category: _eating, transferClientId: 'tr1'),
          _tx(DateTime(2025, 11, 9), 21, category: _eating),
        ],
        start,
        end,
      );

      expect(result.map((t) => t.transaction.amount), [21, 12]);
    });

    test('a budget without targets counts every expense', () {
      final result = budgetTransactions(
        _budget(),
        [
          _tx(DateTime(2025, 11, 3), 12, category: _eating),
          _tx(DateTime(2025, 11, 4), 40, category: _groceries),
        ],
        start,
        end,
      );
      expect(result.length, 2);
    });
  });

  test('amountInCurrency converts through the rates base', () {
    final rates = ExchangeRateEntity(
      provider: 't',
      baseCode: 'EUR',
      rates: const {'EUR': 1, 'XAF': 655.957},
      timeLastUpdated: _t0,
      timeNextUpdated: _t0,
    );
    final tx = _tx(DateTime(2025, 11, 3), 6559.57, currency: 'XAF');
    expect(amountInCurrency(tx, 'EUR', rates), closeTo(10, 1e-6));
    expect(amountInCurrency(tx, 'XAF', rates), 6559.57);
  });
}
