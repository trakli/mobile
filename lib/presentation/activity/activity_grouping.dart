import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';

enum ActivityFilterType { all, spending, income, wallet, people }

class ActivityFilter {
  final ActivityFilterType type;
  final String? walletClientId;
  final String query;

  const ActivityFilter({
    this.type = ActivityFilterType.all,
    this.walletClientId,
    this.query = '',
  });

  bool matches(TransactionCompleteEntity t) {
    final tx = t.transaction;
    final ok = switch (type) {
      ActivityFilterType.all => true,
      ActivityFilterType.spending =>
        tx.type == TransactionType.expense && !tx.isTransferLeg,
      ActivityFilterType.income =>
        tx.type == TransactionType.income && !tx.isTransferLeg,
      ActivityFilterType.wallet => tx.walletClientId == walletClientId,
      ActivityFilterType.people => t.party != null,
    };
    if (!ok) return false;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return tx.description.toLowerCase().contains(q) ||
        (t.party?.name.toLowerCase().contains(q) ?? false) ||
        t.wallet.name.toLowerCase().contains(q) ||
        t.categories.any((c) => c.name.toLowerCase().contains(q));
  }
}

class ActivityDay {
  final DateTime day;
  final List<TransactionCompleteEntity> transactions;

  /// Income minus spending for the day in the display currency. Transfer
  /// legs move money between the user's own wallets and are left out.
  final double net;

  const ActivityDay({
    required this.day,
    required this.transactions,
    required this.net,
  });
}

/// Groups transactions by calendar day, newest day first, newest entry first
/// within a day.
List<ActivityDay> groupActivityByDay(
  Iterable<TransactionCompleteEntity> transactions, {
  required String currency,
  Map<String, double>? rates,
}) {
  final byDay = <DateTime, List<TransactionCompleteEntity>>{};
  for (final t in transactions) {
    final d = t.transaction.datetime;
    byDay.putIfAbsent(DateTime(d.year, d.month, d.day), () => []).add(t);
  }
  final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final day in days)
      () {
        final list = byDay[day]!
          ..sort((a, b) =>
              b.transaction.datetime.compareTo(a.transaction.datetime));
        var net = 0.0;
        for (final t in list) {
          if (t.transaction.isTransferLeg) continue;
          final v = ledgerConvert(
            t.transaction.amount,
            t.wallet.currencyCode,
            currency,
            rates,
          );
          net += t.transaction.type == TransactionType.income ? v : -v;
        }
        return ActivityDay(day: day, transactions: list, net: net);
      }(),
  ];
}
