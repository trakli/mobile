import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

enum FlowNodeType { income, expense, kept, shortfall }

class FlowNode {
  /// Category client id, or a synthetic key for [uncategorizedKey],
  /// [otherKey], [keptKey] and [shortfallKey].
  final String key;
  final String label;
  final double amount;
  final FlowNodeType type;
  final CategoryEntity? category;

  const FlowNode({
    required this.key,
    required this.label,
    required this.amount,
    required this.type,
    this.category,
  });
}

class FlowData {
  final DateTime month;
  final List<FlowNode> sources;
  final List<FlowNode> sinks;
  final double totalIn;
  final double totalOut;

  const FlowData({
    required this.month,
    required this.sources,
    required this.sinks,
    required this.totalIn,
    required this.totalOut,
  });

  double get kept => totalIn - totalOut;

  /// Height of the middle node: the larger of what came in and what went out.
  double get through => totalIn > totalOut ? totalIn : totalOut;

  bool get isEmpty => totalIn <= 0 && totalOut <= 0;
}

class FlowStreamDetail {
  final List<TransactionCompleteEntity> transactions;
  final double total;
  final double previousTotal;

  const FlowStreamDetail({
    required this.transactions,
    required this.total,
    required this.previousTotal,
  });
}

const String uncategorizedKey = '__uncategorized';
const String otherKey = '__other';
const String keptKey = '__kept';
const String shortfallKey = '__shortfall';

bool _inMonth(DateTime d, DateTime month) =>
    d.year == month.year && d.month == month.month;

String _streamKey(TransactionCompleteEntity t) => t.categories.isEmpty
    ? uncategorizedKey
    : t.categories.first.clientId;

/// Builds the money-flow for [month]: income streams on the left, spending
/// streams plus what was kept on the right. Each transaction counts once,
/// under its first category, so both sides add up to the same total. Transfer
/// legs move money between the user's own wallets and are left out. [convert]
/// returns a transaction's amount in the display currency.
FlowData buildFlowData(
  List<TransactionCompleteEntity> transactions, {
  required DateTime month,
  required double Function(TransactionCompleteEntity) convert,
  required String uncategorizedLabel,
  required String otherLabel,
  required String keptLabel,
  required String shortfallLabel,
  int maxSinks = 6,
}) {
  final incomeTotals = <String, double>{};
  final expenseTotals = <String, double>{};
  final categories = <String, CategoryEntity>{};

  for (final t in transactions) {
    if (t.transaction.isTransferLeg) continue;
    if (!_inMonth(t.transaction.datetime, month)) continue;
    final key = _streamKey(t);
    if (t.categories.isNotEmpty) categories[key] = t.categories.first;
    final amount = convert(t);
    final target = t.transaction.type == TransactionType.income
        ? incomeTotals
        : expenseTotals;
    target[key] = (target[key] ?? 0) + amount;
  }

  FlowNode node(String key, double amount, FlowNodeType type) => FlowNode(
        key: key,
        label: key == uncategorizedKey
            ? uncategorizedLabel
            : categories[key]?.name ?? uncategorizedLabel,
        amount: amount,
        type: type,
        category: categories[key],
      );

  List<MapEntry<String, double>> ranked(Map<String, double> m) =>
      m.entries.where((e) => e.value > 0).toList()
        ..sort((a, b) => b.value.compareTo(a.value));

  final totalIn = incomeTotals.values.fold<double>(0, (s, v) => s + v);
  final totalOut = expenseTotals.values.fold<double>(0, (s, v) => s + v);

  final sources = [
    for (final e in ranked(incomeTotals))
      node(e.key, e.value, FlowNodeType.income),
  ];
  if (totalOut > totalIn) {
    sources.add(FlowNode(
      key: shortfallKey,
      label: shortfallLabel,
      amount: totalOut - totalIn,
      type: FlowNodeType.shortfall,
    ));
  }

  final spend = ranked(expenseTotals);
  final sinks = <FlowNode>[];
  if (spend.length > maxSinks) {
    for (final e in spend.take(maxSinks - 1)) {
      sinks.add(node(e.key, e.value, FlowNodeType.expense));
    }
    final rest =
        spend.skip(maxSinks - 1).fold<double>(0, (s, e) => s + e.value);
    sinks.add(FlowNode(
      key: otherKey,
      label: otherLabel,
      amount: rest,
      type: FlowNodeType.expense,
    ));
  } else {
    for (final e in spend) {
      sinks.add(node(e.key, e.value, FlowNodeType.expense));
    }
  }
  if (totalIn > totalOut) {
    sinks.add(FlowNode(
      key: keptKey,
      label: keptLabel,
      amount: totalIn - totalOut,
      type: FlowNodeType.kept,
    ));
  }

  return FlowData(
    month: DateTime(month.year, month.month),
    sources: sources,
    sinks: sinks,
    totalIn: totalIn,
    totalOut: totalOut,
  );
}

/// Transactions behind one stream of [buildFlowData] for [month], newest
/// first, with the same stream's total for the month before.
/// [otherExcluded] lists the stream keys shown on their own when [key] is
/// [otherKey].
FlowStreamDetail flowStreamDetail(
  List<TransactionCompleteEntity> transactions, {
  required String key,
  required FlowNodeType type,
  required DateTime month,
  required double Function(TransactionCompleteEntity) convert,
  Set<String> otherExcluded = const {},
}) {
  final txType = type == FlowNodeType.income
      ? TransactionType.income
      : TransactionType.expense;
  final previous = DateTime(month.year, month.month - 1);

  bool matches(TransactionCompleteEntity t) {
    if (t.transaction.isTransferLeg) return false;
    if (t.transaction.type != txType) return false;
    final k = _streamKey(t);
    return key == otherKey ? !otherExcluded.contains(k) : k == key;
  }

  final current = transactions
      .where((t) => matches(t) && _inMonth(t.transaction.datetime, month))
      .toList()
    ..sort((a, b) => b.transaction.datetime.compareTo(a.transaction.datetime));
  final previousTotal = transactions
      .where((t) => matches(t) && _inMonth(t.transaction.datetime, previous))
      .fold<double>(0, (s, t) => s + convert(t));

  return FlowStreamDetail(
    transactions: current,
    total: current.fold<double>(0, (s, t) => s + convert(t)),
    previousTotal: previousTotal,
  );
}
