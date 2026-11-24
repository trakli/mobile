import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class TopByName {
  final String name;
  final double amount;
  const TopByName({required this.name, required this.amount});
}

class BiggestExpense {
  final double amount;
  final String party;
  final String? category;
  final DateTime date;

  const BiggestExpense({
    required this.amount,
    required this.party,
    this.category,
    required this.date,
  });
}

class NoSpendRun {
  final DateTime start;
  final int days;

  const NoSpendRun({required this.start, required this.days});

  DateTime get end => start.add(Duration(days: days - 1));
}

class MonthInReviewData {
  final DateTime? month;
  final String monthLabel;
  final double income;
  final double expense;
  final double net;
  final double savingsRate;
  final TopByName? topCategory;
  final TopByName? topPayee;
  final BiggestExpense? biggestExpense;
  final int transactionCount;
  final int daysInMonth;
  final NoSpendRun? longestNoSpendRun;
  final bool noSpendRunIsYearBest;

  const MonthInReviewData({
    this.month,
    required this.monthLabel,
    required this.income,
    required this.expense,
    required this.net,
    required this.savingsRate,
    required this.topCategory,
    required this.topPayee,
    required this.biggestExpense,
    required this.transactionCount,
    required this.daysInMonth,
    this.longestNoSpendRun,
    this.noSpendRunIsYearBest = false,
  });
}

DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

NoSpendRun? _longestRun(Set<DateTime> spendDays, DateTime from, DateTime to) {
  NoSpendRun? best;
  DateTime? runStart;
  var runLen = 0;
  for (var d = from; !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
    if (spendDays.contains(d)) {
      runStart = null;
      runLen = 0;
      continue;
    }
    runStart ??= d;
    runLen++;
    if (best == null || runLen > best.days) {
      best = NoSpendRun(start: runStart, days: runLen);
    }
  }
  return best;
}

/// Longest stretch of consecutive days without spending inside [month],
/// counting only finished days ([now] excluded) on or after the first
/// recorded transaction. [isYearBest] is true when no earlier stretch in the
/// same year was longer.
({NoSpendRun? run, bool isYearBest}) longestNoSpendRun(
  List<TransactionCompleteEntity> transactions, {
  required DateTime month,
  required DateTime now,
}) {
  final real =
      transactions.where((t) => !t.transaction.isTransferLeg).toList();
  if (real.isEmpty) return (run: null, isYearBest: false);
  final first = real
      .map((t) => _dayOf(t.transaction.datetime))
      .reduce((a, b) => a.isBefore(b) ? a : b);
  final spendDays = {
    for (final t in real)
      if (t.transaction.type == TransactionType.expense)
        _dayOf(t.transaction.datetime),
  };
  final yesterday = _dayOf(now).subtract(const Duration(days: 1));
  final monthStart = DateTime(month.year, month.month, 1);
  final monthEnd = DateTime(month.year, month.month + 1, 0);
  final from = first.isAfter(monthStart) ? first : monthStart;
  final to = yesterday.isBefore(monthEnd) ? yesterday : monthEnd;
  if (to.isBefore(from)) return (run: null, isYearBest: false);
  final run = _longestRun(spendDays, from, to);
  if (run == null) return (run: null, isYearBest: false);

  final yearStart = DateTime(month.year, 1, 1);
  final yearFrom = first.isAfter(yearStart) ? first : yearStart;
  final earlierEnd = monthStart.subtract(const Duration(days: 1));
  final earlier = earlierEnd.isBefore(yearFrom)
      ? null
      : _longestRun(spendDays, yearFrom, earlierEnd);
  return (run: run, isYearBest: earlier == null || run.days >= earlier.days);
}

/// Computes a recap for the month [offsetMonths] before the current one
/// (0 = the current month), matching the web recap. Transfer legs are
/// excluded; returns null when the target month has no activity.
MonthInReviewData? buildMonthInReview(
  List<TransactionCompleteEntity> transactions, {
  int offsetMonths = 0,
}) {
  if (transactions.isEmpty) return null;

  final now = DateTime.now();
  final target = DateTime(now.year, now.month - offsetMonths, 1);
  final monthEnd = DateTime(target.year, target.month + 1, 0);

  bool sameMonth(DateTime d) =>
      d.year == target.year && d.month == target.month;

  final inMonth = transactions.where((t) {
    return !t.transaction.isTransferLeg && sameMonth(t.transaction.datetime);
  }).toList();

  double income = 0;
  double expense = 0;
  final catMap = <String, double>{};
  final payeeMap = <String, double>{};
  BiggestExpense? biggest;

  for (final t in inMonth) {
    final amount = t.transaction.amount;
    if (t.transaction.type == TransactionType.income) {
      income += amount;
    } else {
      expense += amount;
      // Tally by category names (a transaction can have multiple).
      if (t.categories.isEmpty) {
        catMap['Uncategorized'] = (catMap['Uncategorized'] ?? 0) + amount;
      } else {
        for (final c in t.categories) {
          catMap[c.name] = (catMap[c.name] ?? 0) + amount;
        }
      }
      final partyName = t.party?.name ?? 'Anonymous';
      payeeMap[partyName] = (payeeMap[partyName] ?? 0) + amount;
      if (biggest == null || amount > biggest.amount) {
        biggest = BiggestExpense(
          amount: amount,
          party: partyName,
          category: t.categories.isNotEmpty ? t.categories.first.name : null,
          date: t.transaction.datetime,
        );
      }
    }
  }

  if (income == 0 && expense == 0) return null;

  final net = income - expense;
  final savingsRate = income > 0 ? net / income : 0;

  TopByName? top(Map<String, double> map) {
    if (map.isEmpty) return null;
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final e = entries.first;
    return TopByName(name: e.key, amount: e.value);
  }

  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  final noSpend = longestNoSpendRun(transactions, month: target, now: now);

  return MonthInReviewData(
    month: target,
    longestNoSpendRun: noSpend.run,
    noSpendRunIsYearBest: noSpend.isYearBest,
    monthLabel: '${months[target.month - 1]} ${target.year}',
    income: income,
    expense: expense,
    net: net,
    savingsRate: savingsRate.toDouble(),
    topCategory: top(catMap),
    topPayee: top(payeeMap),
    biggestExpense: biggest,
    transactionCount: inMonth.length,
    daysInMonth: monthEnd.day,
  );
}
