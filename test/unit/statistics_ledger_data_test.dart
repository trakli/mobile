import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/statistics/calendar/calendar_data.dart';
import 'package:trakli/presentation/statistics/flow/flow_data.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/utils/enums.dart';

final _t0 = DateTime(2026, 1, 1);

WalletEntity _wallet(String id, {String currency = 'EUR', double balance = 0}) =>
    WalletEntity(
      clientId: id,
      type: WalletType.bank,
      name: id == 'main' ? 'Main account' : id,
      balance: balance,
      currencyCode: currency,
      createdAt: _t0,
      updatedAt: _t0,
    );

CategoryEntity _cat(String id, TransactionType type) => CategoryEntity(
      clientId: id,
      type: type,
      name: id,
      createdAt: _t0,
    );

var _n = 0;
TransactionCompleteEntity _tx(
  DateTime when,
  double amount,
  TransactionType type, {
  CategoryEntity? category,
  WalletEntity? wallet,
  String description = '',
  String? transferClientId,
}) {
  _n++;
  final w = wallet ?? _wallet('main');
  return TransactionCompleteEntity(
    transaction: TransactionEntity(
      clientId: 't$_n',
      amount: amount,
      description: description,
      createdAt: when,
      updatedAt: when,
      datetime: when,
      type: type,
      walletClientId: w.clientId,
      transferClientId: transferClientId,
    ),
    categories: category == null ? const [] : [category],
    wallet: w,
  );
}

ReminderEntity _reminder(String title, DateTime due,
        {String type = ReminderType.billDue,
        String status = ReminderStatus.active}) =>
    ReminderEntity(
      clientId: 'r-$title',
      title: title,
      type: type,
      status: status,
      nextTriggerAt: due,
      createdAt: _t0,
      updatedAt: _t0,
    );

const _inc = TransactionType.income;
const _exp = TransactionType.expense;
double _raw(TransactionCompleteEntity t) => t.transaction.amount;

FlowData _flow(List<TransactionCompleteEntity> txs, {int maxSinks = 6}) =>
    buildFlowData(
      txs,
      month: DateTime(2026, 3),
      convert: _raw,
      uncategorizedLabel: 'Uncategorized',
      otherLabel: 'Other',
      keptLabel: 'Kept',
      shortfallLabel: 'From balance',
      maxSinks: maxSinks,
    );

void main() {
  final salary = _cat('salary', _inc);
  final rent = _cat('rent', _exp);
  final food = _cat('food', _exp);

  group('buildFlowData', () {
    test('both sides add up and the remainder is kept', () {
      final data = _flow([
        _tx(DateTime(2026, 3, 1), 3000, _inc, category: salary),
        _tx(DateTime(2026, 3, 2), 1000, _exp, category: rent),
        _tx(DateTime(2026, 3, 3), 200, _exp, category: food),
        _tx(DateTime(2026, 3, 4), 50, _exp),
      ]);
      expect(data.totalIn, 3000);
      expect(data.totalOut, 1250);
      expect(data.kept, 1750);
      expect(data.sinks.map((s) => s.key),
          ['rent', 'food', uncategorizedKey, keptKey]);
      final right = data.sinks.fold<double>(0, (s, n) => s + n.amount);
      final left = data.sources.fold<double>(0, (s, n) => s + n.amount);
      expect(right, left);
    });

    test('other months and transfer legs are left out', () {
      final data = _flow([
        _tx(DateTime(2026, 2, 28), 999, _inc, category: salary),
        _tx(DateTime(2026, 3, 5), 400, _exp, transferClientId: 'tr1'),
        _tx(DateTime(2026, 3, 5), 100, _inc, category: salary),
      ]);
      expect(data.totalIn, 100);
      expect(data.totalOut, 0);
    });

    test('overspending adds a balance source and no kept stream', () {
      final data = _flow([
        _tx(DateTime(2026, 3, 1), 100, _inc, category: salary),
        _tx(DateTime(2026, 3, 2), 160, _exp, category: rent),
      ]);
      expect(data.sources.last.type, FlowNodeType.shortfall);
      expect(data.sources.last.amount, 60);
      expect(data.sinks.any((s) => s.type == FlowNodeType.kept), isFalse);
      expect(data.through, 160);
    });

    test('long tails fold into Other', () {
      final txs = [
        for (var i = 0; i < 8; i++)
          _tx(DateTime(2026, 3, 1 + i), 10.0 + i, _exp,
              category: _cat('c$i', _exp)),
      ];
      final data = _flow(txs, maxSinks: 4);
      expect(data.sinks.length, 4);
      expect(data.sinks.last.key, otherKey);
      expect(data.sinks.last.amount, 10 + 11 + 12 + 13 + 14);
    });
  });

  group('flowStreamDetail', () {
    test('lists the month and totals the month before', () {
      final txs = [
        _tx(DateTime(2026, 3, 3), 20, _exp, category: food),
        _tx(DateTime(2026, 3, 9), 30, _exp, category: food),
        _tx(DateTime(2026, 2, 9), 70, _exp, category: food),
        _tx(DateTime(2026, 3, 9), 500, _exp, category: rent),
      ];
      final d = flowStreamDetail(
        txs,
        key: 'food',
        type: FlowNodeType.expense,
        month: DateTime(2026, 3),
        convert: _raw,
      );
      expect(d.total, 50);
      expect(d.previousTotal, 70);
      expect(d.transactions.first.transaction.amount, 30);
    });

    test('Other collects everything not shown on its own', () {
      final txs = [
        _tx(DateTime(2026, 3, 3), 20, _exp, category: food),
        _tx(DateTime(2026, 3, 9), 500, _exp, category: rent),
      ];
      final d = flowStreamDetail(
        txs,
        key: otherKey,
        type: FlowNodeType.expense,
        month: DateTime(2026, 3),
        convert: _raw,
        otherExcluded: {'rent'},
      );
      expect(d.total, 20);
    });
  });

  group('calendar data', () {
    test('daily spend sums expenses per day and skips transfers', () {
      final spend = dailySpend([
        _tx(DateTime(2026, 3, 2, 9), 10, _exp),
        _tx(DateTime(2026, 3, 2, 18), 5.5, _exp),
        _tx(DateTime(2026, 3, 2), 100, _inc),
        _tx(DateTime(2026, 3, 3), 40, _exp, transferClientId: 'x'),
      ], month: DateTime(2026, 3), convert: _raw);
      expect(spend, {2: 15.5});
    });

    test('day net is income minus spending', () {
      final txs = [
        _tx(DateTime(2026, 3, 2, 9), 10, _exp),
        _tx(DateTime(2026, 3, 2, 12), 25, _inc),
        _tx(DateTime(2026, 3, 3), 99, _exp),
      ];
      expect(dayNet(txs, day: DateTime(2026, 3, 2), convert: _raw), 15);
    });

    test('no-spend days are past days without spending', () {
      final quiet = noSpendDays({1: 5, 3: 2},
          month: DateTime(2026, 3), today: DateTime(2026, 3, 5, 10));
      expect(quiet, {2, 4});
    });

    test('next bill subtracts the last matching payment from its wallet', () {
      final main = _wallet('main', balance: 3412.80);
      final cash = _wallet('cash', balance: 60);
      final bill = findNextBill(
        reminders: [
          _reminder('Gym', DateTime(2026, 3, 20), type: ReminderType.custom),
          _reminder('Rent', DateTime(2026, 4, 1)),
          _reminder('Old', DateTime(2026, 3, 1)),
        ],
        transactions: [
          _tx(DateTime(2026, 2, 1), 1000, _exp,
              wallet: main, description: 'February rent'),
          _tx(DateTime(2026, 3, 1), 1050, _exp,
              wallet: main, description: 'March rent'),
          _tx(DateTime(2026, 3, 2), 3, _exp,
              wallet: cash, description: 'Parent visit'),
        ],
        wallets: [main, cash],
        now: DateTime(2026, 3, 10),
      )!;
      expect(bill.reminder.title, 'Rent');
      expect(bill.wallet.clientId, 'main');
      expect(bill.amount, 1050);
      expect(bill.balanceAfter, closeTo(2362.80, 0.001));
    });

    test('without a matching payment the default wallet is shown as is', () {
      final main = _wallet('main', balance: 100);
      final cash = _wallet('cash', balance: 60);
      final bill = findNextBill(
        reminders: [_reminder('Insurance', DateTime(2026, 3, 12))],
        transactions: const [],
        wallets: [main, cash],
        now: DateTime(2026, 3, 10),
        defaultWalletId: 'cash',
      )!;
      expect(bill.wallet.clientId, 'cash');
      expect(bill.amount, isNull);
      expect(bill.balanceAfter, 60);
    });

    test('paused and past reminders are ignored', () {
      final bill = findNextBill(
        reminders: [
          _reminder('Rent', DateTime(2026, 3, 1)),
          _reminder('Gym', DateTime(2026, 3, 20),
              status: ReminderStatus.paused),
        ],
        transactions: const [],
        wallets: [_wallet('main')],
        now: DateTime(2026, 3, 10),
      );
      expect(bill, isNull);
    });

    test('reminder days mark due dates in the month', () {
      final days = reminderDays([
        _reminder('A', DateTime(2026, 3, 28)),
        _reminder('B', DateTime(2026, 4, 1)),
      ], DateTime(2026, 3));
      expect(days, {28});
    });
  });

  group('longestNoSpendRun', () {
    test('finds the longest gap inside the month', () {
      final txs = [
        _tx(DateTime(2026, 2, 27), 5, _exp),
        _tx(DateTime(2026, 3, 1), 5, _exp),
        _tx(DateTime(2026, 3, 2), 5, _exp),
        _tx(DateTime(2026, 3, 7), 5, _exp),
        _tx(DateTime(2026, 3, 9), 5, _inc),
        _tx(DateTime(2026, 3, 10), 5, _exp),
      ];
      final r = longestNoSpendRun(txs,
          month: DateTime(2026, 3), now: DateTime(2026, 3, 11));
      expect(r.run!.start, DateTime(2026, 3, 3));
      expect(r.run!.days, 4);
      expect(r.run!.end, DateTime(2026, 3, 6));
      expect(r.isYearBest, isTrue);
    });

    test('an earlier longer run this year is not beaten', () {
      final txs = [
        _tx(DateTime(2026, 1, 1), 5, _exp),
        _tx(DateTime(2026, 1, 20), 5, _exp),
        for (var d = 1; d <= 10; d++)
          if (d != 4 && d != 5) _tx(DateTime(2026, 2, d), 5, _exp),
      ];
      final r = longestNoSpendRun(txs,
          month: DateTime(2026, 2), now: DateTime(2026, 2, 11));
      expect(r.run!.days, 2);
      expect(r.isYearBest, isFalse);
    });

    test('days before the first record and today do not count', () {
      final txs = [_tx(DateTime(2026, 3, 8), 5, _exp)];
      final r = longestNoSpendRun(txs,
          month: DateTime(2026, 3), now: DateTime(2026, 3, 9));
      expect(r.run, isNull);
    });
  });
}
