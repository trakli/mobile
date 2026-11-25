import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class StatsDay {
  final DateTime day;
  final double income;
  final double expense;

  const StatsDay(this.day, this.income, this.expense);
}

class StatsCategoryRow {
  /// Null for transactions without a category.
  final CategoryEntity? category;
  final double amount;
  final int count;

  const StatsCategoryRow({
    required this.category,
    required this.amount,
    required this.count,
  });
}

class StatsPersonRow {
  final PartyEntity party;

  /// Income minus spending with this party.
  final double net;
  final int count;

  const StatsPersonRow({
    required this.party,
    required this.net,
    required this.count,
  });
}

class StatsOverview {
  final double income;
  final double expense;
  final List<StatsDay> days;
  final List<StatsCategoryRow> incomeCategories;
  final List<StatsCategoryRow> expenseCategories;
  final List<StatsPersonRow> people;

  const StatsOverview({
    required this.income,
    required this.expense,
    required this.days,
    required this.incomeCategories,
    required this.expenseCategories,
    required this.people,
  });

  double get net => income - expense;
}

class _CategoryTally {
  final CategoryEntity? category;
  double amount = 0;
  int count = 0;

  _CategoryTally(this.category);
}

/// Totals, per-day bars, category and party breakdowns for [transactions],
/// with every amount passed through [convert]. A transaction with several
/// categories counts in full toward each of them.
StatsOverview buildStatsOverview(
  List<TransactionCompleteEntity> transactions,
  double Function(TransactionCompleteEntity) convert,
) {
  double income = 0;
  double expense = 0;
  final days = <DateTime, List<double>>{};
  final incomeCats = <String, _CategoryTally>{};
  final expenseCats = <String, _CategoryTally>{};
  final people = <String, (PartyEntity, double, int)>{};

  for (final t in transactions) {
    final v = convert(t);
    final isIncome = t.transaction.type == TransactionType.income;
    if (isIncome) {
      income += v;
    } else {
      expense += v;
    }

    final d = t.transaction.datetime.toLocal();
    final bucket =
        days.putIfAbsent(DateTime(d.year, d.month, d.day), () => [0, 0]);
    bucket[isIncome ? 0 : 1] += v;

    final cats = isIncome ? incomeCats : expenseCats;
    final targets = t.categories.isEmpty ? [null] : t.categories;
    for (final c in targets) {
      final tally =
          cats.putIfAbsent(c?.clientId ?? '', () => _CategoryTally(c));
      tally.amount += v;
      tally.count++;
    }

    final p = t.party;
    if (p != null) {
      final prev = people[p.clientId];
      people[p.clientId] = (
        p,
        (prev?.$2 ?? 0) + (isIncome ? v : -v),
        (prev?.$3 ?? 0) + 1,
      );
    }
  }

  List<StatsCategoryRow> rows(Map<String, _CategoryTally> m) => [
        for (final c in m.values)
          StatsCategoryRow(
            category: c.category,
            amount: c.amount,
            count: c.count,
          ),
      ]..sort((a, b) => b.amount.compareTo(a.amount));

  final dayKeys = days.keys.toList()..sort();
  return StatsOverview(
    income: income,
    expense: expense,
    days: [for (final k in dayKeys) StatsDay(k, days[k]![0], days[k]![1])],
    incomeCategories: rows(incomeCats),
    expenseCategories: rows(expenseCats),
    people: [
      for (final e in people.values)
        StatsPersonRow(party: e.$1, net: e.$2, count: e.$3),
    ]..sort((a, b) => b.net.abs().compareTo(a.net.abs())),
  );
}
