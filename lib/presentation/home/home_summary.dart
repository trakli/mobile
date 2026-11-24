import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';

class HomeSummary {
  /// Income minus spending this month, in the display currency.
  final double kept;

  /// Last month's spending up to the same day of month minus this month's
  /// spending so far. Positive means spending is under last month's pace.
  /// Null when last month has no spending to compare with.
  final double? paceDelta;

  final DateTime month;
  final DateTime previousMonth;

  const HomeSummary({
    required this.kept,
    required this.paceDelta,
    required this.month,
    required this.previousMonth,
  });
}

class UpcomingBill {
  final ReminderEntity reminder;
  final DateTime due;

  /// Amount and currency of the latest transaction whose description matches
  /// the reminder title; reminders carry no amount of their own.
  final double? amount;
  final String? currency;
  final String? walletName;

  const UpcomingBill({
    required this.reminder,
    required this.due,
    this.amount,
    this.currency,
    this.walletName,
  });
}

double _inDisplay(TransactionCompleteEntity t, String currency,
        Map<String, double>? rates) =>
    ledgerConvert(t.transaction.amount, t.wallet.currencyCode, currency, rates);

HomeSummary buildHomeSummary(
  List<TransactionCompleteEntity> transactions, {
  required DateTime now,
  required String currency,
  Map<String, double>? rates,
}) {
  final month = DateTime(now.year, now.month);
  final prev = DateTime(now.year, now.month - 1);
  final prevDays = DateTime(prev.year, prev.month + 1, 0).day;
  final prevCutoff = DateTime(
    prev.year,
    prev.month,
    now.day > prevDays ? prevDays : now.day,
    23,
    59,
    59,
  );

  double income = 0;
  double spent = 0;
  double prevSpent = 0;
  var prevHasSpending = false;
  for (final t in transactions) {
    if (t.transaction.isTransferLeg) continue;
    final d = t.transaction.datetime;
    final v = _inDisplay(t, currency, rates);
    final isExpense = t.transaction.type == TransactionType.expense;
    if (d.year == month.year && d.month == month.month && !d.isAfter(now)) {
      if (isExpense) {
        spent += v;
      } else {
        income += v;
      }
    } else if (d.year == prev.year && d.month == prev.month && isExpense) {
      prevHasSpending = true;
      if (!d.isAfter(prevCutoff)) prevSpent += v;
    }
  }
  return HomeSummary(
    kept: income - spent,
    paceDelta: prevHasSpending ? prevSpent - spent : null,
    month: month,
    previousMonth: prev,
  );
}

List<TransactionCompleteEntity> transactionsOnDay(
  List<TransactionCompleteEntity> transactions,
  DateTime day,
) {
  final list = transactions.where((t) {
    final d = t.transaction.datetime;
    return d.year == day.year && d.month == day.month && d.day == day.day;
  }).toList()
    ..sort((a, b) => b.transaction.datetime.compareTo(a.transaction.datetime));
  return list;
}

DateTime? reminderDueDate(ReminderEntity r) {
  if (r.status == ReminderStatus.completed ||
      r.status == ReminderStatus.cancelled) {
    return null;
  }
  return r.dueAt ?? r.nextTriggerAt ?? r.triggerAt;
}

/// Active reminders due from today on, soonest first, with an amount taken
/// from the latest transaction that shares the reminder's title.
List<UpcomingBill> upcomingBills(
  List<ReminderEntity> reminders,
  List<TransactionCompleteEntity> transactions, {
  required DateTime now,
  int limit = 2,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final bills = <UpcomingBill>[];
  for (final r in reminders) {
    final due = reminderDueDate(r);
    if (due == null || due.isBefore(today)) continue;
    final title = r.title.trim().toLowerCase();
    TransactionCompleteEntity? match;
    for (final t in transactions) {
      if (t.transaction.description.trim().toLowerCase() != title) continue;
      if (match == null ||
          t.transaction.datetime.isAfter(match.transaction.datetime)) {
        match = t;
      }
    }
    bills.add(UpcomingBill(
      reminder: r,
      due: due,
      amount: match?.transaction.amount,
      currency: match?.wallet.currencyCode,
      walletName: match?.wallet.name,
    ));
  }
  bills.sort((a, b) => a.due.compareTo(b.due));
  return bills.take(limit).toList();
}
