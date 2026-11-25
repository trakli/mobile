import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/activity/activity_grouping.dart';
import 'package:trakli/presentation/home/home_summary.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';

void main() {
  final t0 = DateTime(2025, 1, 1);
  WalletEntity wallet(String id, String currency) => WalletEntity(
        clientId: id,
        type: WalletType.bank,
        name: id,
        balance: 0,
        currencyCode: currency,
        createdAt: t0,
        updatedAt: t0,
      );
  final eur = wallet('Main', 'EUR');
  final xaf = wallet('MoMo', 'XAF');
  final rates = {'EUR': 1.0, 'XAF': 655.957};
  var seq = 0;
  TransactionCompleteEntity tx(
      DateTime when, double amount, TransactionType type,
      {WalletEntity? w,
      String? transferId,
      PartyEntity? party,
      String desc = ''}) {
    final wal = w ?? eur;
    return TransactionCompleteEntity(
      transaction: TransactionEntity(
        clientId: 'tx${seq++}',
        amount: amount,
        description: desc,
        createdAt: when,
        updatedAt: when,
        datetime: when,
        type: type,
        walletClientId: wal.clientId,
        transferClientId: transferId,
      ),
      categories: const [],
      wallet: wal,
      party: party,
    );
  }

  const inc = TransactionType.income;
  const exp = TransactionType.expense;

  group('activity day grouping', () {
    final list = [
      tx(DateTime(2025, 11, 24, 9), 8.40, exp),
      tx(DateTime(2025, 11, 24, 13), 12.50, exp),
      tx(DateTime(2025, 11, 22, 10), 380, inc),
      tx(DateTime(2025, 11, 22, 11), 18.20, exp),
      tx(DateTime(2025, 11, 21, 9), 5000, exp, w: xaf),
      tx(DateTime(2025, 11, 21, 9), 500, exp, transferId: 'tr1'),
      tx(DateTime(2025, 11, 21, 9), 500, inc, transferId: 'tr1'),
    ];
    final days = groupActivityByDay(list, currency: 'EUR', rates: rates);

    test('newest day first, newest entry first', () {
      expect(days.map((d) => d.day.day), [24, 22, 21]);
      expect(days.first.transactions.first.transaction.amount, 12.50);
    });

    test('day net is income minus spending in the display currency', () {
      expect(days[0].net, closeTo(-20.90, 1e-9));
      expect(days[1].net, closeTo(361.80, 1e-9));
    });

    test('transfer legs are listed but do not move the day total', () {
      expect(days[2].transactions, hasLength(3));
      expect(days[2].net, closeTo(-5000 / 655.957, 1e-9));
    });

    test('filters', () {
      final tomas = PartyEntity(
          clientId: 'p', name: 'Tomás', createdAt: t0, updatedAt: t0);
      final withParty = [
        ...list,
        tx(DateTime(2025, 11, 20), 40, inc, party: tomas, desc: 'paid back')
      ];
      expect(
          withParty
              .where(const ActivityFilter(type: ActivityFilterType.spending)
                  .matches)
              .length,
          4);
      expect(
          withParty
              .where(
                  const ActivityFilter(type: ActivityFilterType.income).matches)
              .length,
          2);
      expect(
          withParty
              .where(
                  const ActivityFilter(type: ActivityFilterType.people).matches)
              .length,
          1);
      expect(
          withParty
              .where(ActivityFilter(
                      type: ActivityFilterType.wallet,
                      walletClientId: xaf.clientId)
                  .matches)
              .length,
          1);
      expect(
          withParty.where(const ActivityFilter(query: 'tomás').matches).length,
          1);
    });
  });

  group('home recent by month', () {
    test('groups newest month first with entries newest first', () {
      final months = transactionsByMonth([
        tx(DateTime(2025, 10, 3), 20, exp),
        tx(DateTime(2025, 11, 2), 5, exp),
        tx(DateTime(2025, 11, 20), 7, exp),
        tx(DateTime(2024, 12, 31), 1, exp),
      ], currency: 'EUR', rates: rates);

      expect(months.map((m) => m.month), [
        DateTime(2025, 11),
        DateTime(2025, 10),
        DateTime(2024, 12),
      ]);
      expect(
        months.first.transactions.map((t) => t.transaction.datetime.day),
        [20, 2],
      );
    });

    test('nets income against spending in the display currency', () {
      final months = transactionsByMonth([
        tx(DateTime(2025, 11, 1), 100, inc),
        tx(DateTime(2025, 11, 2), 30, exp),
        tx(DateTime(2025, 11, 3), 6559.57, exp, w: xaf),
      ], currency: 'EUR', rates: rates);

      expect(months.single.net, closeTo(60, 1e-6));
    });

    test('lists transfer legs but leaves them out of the net', () {
      final months = transactionsByMonth([
        tx(DateTime(2025, 11, 5), 500, exp, transferId: 'tr'),
        tx(DateTime(2025, 11, 5), 500, inc, transferId: 'tr'),
        tx(DateTime(2025, 11, 6), 12, exp),
      ], currency: 'EUR', rates: rates);

      expect(months.single.transactions, hasLength(3));
      expect(months.single.net, closeTo(-12, 1e-9));
    });

    test('returns nothing for no transactions', () {
      expect(transactionsByMonth([], currency: 'EUR'), isEmpty);
    });
  });

  group('home summary', () {
    final now = DateTime(2025, 11, 24, 18);

    test('kept this month and pace against the same days last month', () {
      final s = buildHomeSummary([
        tx(DateTime(2025, 11, 1), 3600, inc),
        tx(DateTime(2025, 11, 1), 1050, exp),
        tx(DateTime(2025, 11, 20), 6559.57, exp, w: xaf),
        tx(DateTime(2025, 11, 15), 500, exp, transferId: 't'),
        tx(DateTime(2025, 10, 2), 1000, exp),
        tx(DateTime(2025, 10, 20), 70, exp),
        tx(DateTime(2025, 10, 28), 999, exp),
      ], now: now, currency: 'EUR', rates: rates);
      expect(s.kept, closeTo(3600 - 1050 - 10, 1e-6));
      expect(s.paceDelta, closeTo(1070 - 1060, 1e-6));
      expect(s.month, DateTime(2025, 11));
      expect(s.previousMonth, DateTime(2025, 10));
    });

    test('no spending last month gives no pace', () {
      final s = buildHomeSummary([tx(DateTime(2025, 11, 3), 10, exp)],
          now: now, currency: 'EUR', rates: rates);
      expect(s.paceDelta, isNull);
    });

    test('upcoming bills take the amount of the last matching transaction', () {
      ReminderEntity r(String title, DateTime due,
              {String status = ReminderStatus.active}) =>
          ReminderEntity(
              clientId: title,
              title: title,
              dueAt: due,
              status: status,
              createdAt: t0,
              updatedAt: t0);
      final bills = upcomingBills(
        [
          r('Rent', DateTime(2025, 12, 1)),
          r('Spotify', DateTime(2025, 11, 28)),
          r('Old', DateTime(2025, 11, 1)),
          r('Done', DateTime(2025, 11, 26), status: ReminderStatus.completed),
        ],
        [
          tx(DateTime(2025, 10, 1), 1000, exp, desc: 'rent'),
          tx(DateTime(2025, 11, 1), 1050, exp, desc: 'Rent'),
        ],
        now: now,
      );
      expect(bills.map((b) => b.reminder.title), ['Spotify', 'Rent']);
      expect(bills[0].amount, isNull);
      expect(bills[1].amount, 1050);
      expect(bills[1].currency, 'EUR');
    });
  });

  test('money formatting', () {
    expect(LedgerMoney.format(1781.65, 'EUR', sign: true), '+€1,781.65');
    expect(LedgerMoney.format(-12.5, 'EUR'), '−€12.50');
    expect(LedgerMoney.format(184500, 'XAF'), '184,500 XAF');
    expect(LedgerMoney.format(1050, 'EUR', short: true), '€1,050');
    expect(ledgerConvert(655.957, 'XAF', 'EUR', {'EUR': 1, 'XAF': 655.957}),
        closeTo(1, 1e-9));
  });
}
