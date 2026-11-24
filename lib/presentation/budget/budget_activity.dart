import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class BudgetWeek {
  final DateTime start;
  final DateTime end;
  final double amount;

  /// True when the period is longer than a month and buckets are calendar
  /// months instead of weeks.
  final bool byMonth;

  const BudgetWeek({
    required this.start,
    required this.end,
    required this.amount,
    this.byMonth = false,
  });
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whether [t] counts against [budget]: an expense (not a transfer leg) that
/// hits any of the budget's targets, or any expense when it has none.
bool budgetMatchesTransaction(BudgetEntity budget, TransactionCompleteEntity t) {
  final tx = t.transaction;
  if (tx.type != TransactionType.expense || tx.isTransferLeg) return false;
  if (budget.targets.isEmpty) return true;
  for (final target in budget.targets) {
    bool same(String? clientId, int? id) =>
        (target.clientId != null && target.clientId == clientId) ||
        (target.id != null && target.id == id);
    switch (target.type) {
      case BudgetTargetType.category:
        if (t.categories.any((c) => same(c.clientId, c.id))) return true;
      case BudgetTargetType.wallet:
        if (same(t.wallet.clientId, t.wallet.id)) return true;
      case BudgetTargetType.group:
        if (same(tx.groupClientId ?? t.group?.clientId, t.group?.id)) {
          return true;
        }
    }
  }
  return false;
}

/// Converts [t]'s amount from its wallet currency into [currency] using
/// [rates] (both expressed against the rates' base). Without rates the raw
/// amount is used.
double amountInCurrency(
  TransactionCompleteEntity t,
  String currency,
  ExchangeRateEntity? rates,
) {
  final amount = t.transaction.amount;
  final from = t.wallet.currencyCode;
  if (rates == null || from == currency) return amount;
  final fromRate = from == rates.baseCode ? 1.0 : (rates.rates[from] ?? 1);
  final toRate =
      currency == rates.baseCode ? 1.0 : (rates.rates[currency] ?? 1);
  return amount / fromRate * toRate;
}

/// Matching transactions inside `[start, end]`, newest first.
List<TransactionCompleteEntity> budgetTransactions(
  BudgetEntity budget,
  List<TransactionCompleteEntity> transactions,
  DateTime start,
  DateTime end,
) {
  final from = _day(start);
  final to = _day(end);
  return transactions.where((t) {
    final d = _day(t.transaction.datetime);
    return !d.isBefore(from) &&
        !d.isAfter(to) &&
        budgetMatchesTransaction(budget, t);
  }).toList()
    ..sort((a, b) => b.transaction.datetime.compareTo(a.transaction.datetime));
}

/// Splits the period into week buckets of seven days from [start] (days
/// 1 to 7, 8 to 14, 15 to 21) with the last bucket running from day 22 to
/// the end. Periods shorter than four weeks are split into plain seven day
/// buckets. The final bucket stops at [today] when the period is still
/// running. Periods longer than 31 days are bucketed by calendar month
/// instead. Each transaction amount comes from [amountOf].
List<BudgetWeek> bucketBudgetWeeks({
  required List<TransactionCompleteEntity> transactions,
  required DateTime start,
  required DateTime end,
  required double Function(TransactionCompleteEntity t) amountOf,
  DateTime? today,
}) {
  final from = _day(start);
  var to = _day(end);
  final now = today == null ? null : _day(today);
  if (now != null && now.isBefore(to) && !now.isBefore(from)) to = now;
  if (to.isBefore(from)) return const [];

  final totalDays = to.difference(from).inDays + 1;
  final ranges = <(DateTime, DateTime)>[];
  final byMonth = totalDays > 31;
  var cursor = from;
  while (byMonth && !cursor.isAfter(to)) {
    final monthEnd = DateTime(cursor.year, cursor.month + 1, 0);
    ranges.add((cursor, monthEnd.isAfter(to) ? to : monthEnd));
    cursor = DateTime(cursor.year, cursor.month + 1, 1);
  }
  while (!byMonth && !cursor.isAfter(to)) {
    final isFourth = ranges.length == 3;
    final bucketEnd = isFourth || totalDays - ranges.length * 7 <= 7
        ? to
        : DateTime(cursor.year, cursor.month, cursor.day + 6);
    ranges.add((cursor, bucketEnd.isAfter(to) ? to : bucketEnd));
    if (!bucketEnd.isBefore(to)) break;
    cursor = DateTime(bucketEnd.year, bucketEnd.month, bucketEnd.day + 1);
    if (ranges.length == 4) break;
  }

  final sums = List<double>.filled(ranges.length, 0);
  for (final t in transactions) {
    final d = _day(t.transaction.datetime);
    for (var i = 0; i < ranges.length; i++) {
      if (!d.isBefore(ranges[i].$1) && !d.isAfter(ranges[i].$2)) {
        sums[i] += amountOf(t);
        break;
      }
    }
  }
  return [
    for (var i = 0; i < ranges.length; i++)
      BudgetWeek(
        start: ranges[i].$1,
        end: ranges[i].$2,
        amount: sums[i],
        byMonth: byMonth,
      ),
  ];
}
