import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Spending per day of [month] (1-based day keys). Transfer legs are not
/// spending and are skipped. [convert] returns the amount in the display
/// currency.
Map<int, double> dailySpend(
  List<TransactionCompleteEntity> transactions, {
  required DateTime month,
  required double Function(TransactionCompleteEntity) convert,
}) {
  final out = <int, double>{};
  for (final t in transactions) {
    final tx = t.transaction;
    if (tx.isTransferLeg || tx.type != TransactionType.expense) continue;
    final d = tx.datetime;
    if (d.year != month.year || d.month != month.month) continue;
    out[d.day] = (out[d.day] ?? 0) + convert(t);
  }
  return out;
}

/// Net total (income minus spending) of the transactions on [day].
double dayNet(
  List<TransactionCompleteEntity> transactions, {
  required DateTime day,
  required double Function(TransactionCompleteEntity) convert,
}) {
  final target = _day(day);
  var total = 0.0;
  for (final t in transactions) {
    if (t.transaction.isTransferLeg) continue;
    if (_day(t.transaction.datetime) != target) continue;
    final v = convert(t);
    total += t.transaction.type == TransactionType.income ? v : -v;
  }
  return total;
}

/// Past days of [month] with no spending, up to and excluding [today].
Set<int> noSpendDays(
  Map<int, double> spend, {
  required DateTime month,
  required DateTime today,
}) {
  final last = DateTime(month.year, month.month + 1, 0).day;
  final out = <int>{};
  for (var d = 1; d <= last; d++) {
    final date = DateTime(month.year, month.month, d);
    if (!date.isBefore(_day(today))) break;
    if ((spend[d] ?? 0) <= 0) out.add(d);
  }
  return out;
}

DateTime? reminderDate(ReminderEntity r) =>
    r.nextTriggerAt ?? r.dueAt ?? r.triggerAt;

bool _isLive(ReminderEntity r) =>
    r.status == ReminderStatus.active || r.status == ReminderStatus.snoozed;

/// Days of [month] that have a live reminder due.
Set<int> reminderDays(List<ReminderEntity> reminders, DateTime month) {
  final out = <int>{};
  for (final r in reminders) {
    if (!_isLive(r)) continue;
    final d = reminderDate(r);
    if (d == null) continue;
    final local = d.toLocal();
    if (local.year == month.year && local.month == month.month) {
      out.add(local.day);
    }
  }
  return out;
}

class NextBill {
  final ReminderEntity reminder;
  final DateTime date;
  final WalletEntity wallet;

  /// Amount of the matched past payment in [wallet]'s currency, or null when
  /// no earlier transaction matches the reminder.
  final double? amount;

  const NextBill({
    required this.reminder,
    required this.date,
    required this.wallet,
    required this.amount,
  });

  double get balanceAfter => wallet.balance - (amount ?? 0);
}

/// The next live reminder due on or after [now] (bill reminders first) and
/// the wallet balance once it is paid. Reminders carry no amount or wallet,
/// so both come from the most recent expense whose description names the
/// reminder. Without a match the [defaultWalletId] wallet (or the first
/// wallet) is used and nothing is subtracted.
NextBill? findNextBill({
  required List<ReminderEntity> reminders,
  required List<TransactionCompleteEntity> transactions,
  required List<WalletEntity> wallets,
  required DateTime now,
  String? defaultWalletId,
}) {
  if (wallets.isEmpty) return null;
  final today = _day(now);
  final upcoming = <(ReminderEntity, DateTime)>[];
  for (final r in reminders) {
    if (!_isLive(r)) continue;
    final d = reminderDate(r);
    if (d == null) continue;
    final local = d.toLocal();
    if (_day(local).isBefore(today)) continue;
    upcoming.add((r, local));
  }
  if (upcoming.isEmpty) return null;

  int rank(ReminderEntity r) => r.type == ReminderType.billDue ? 0 : 1;
  upcoming.sort((a, b) {
    final byType = rank(a.$1).compareTo(rank(b.$1));
    if (byType != 0) return byType;
    return a.$2.compareTo(b.$2);
  });
  final (reminder, date) = upcoming.first;

  final title = reminder.title.trim().toLowerCase();
  final expenses = transactions
      .where((t) =>
          !t.transaction.isTransferLeg &&
          t.transaction.type == TransactionType.expense)
      .toList()
    ..sort((a, b) => b.transaction.datetime.compareTo(a.transaction.datetime));

  TransactionCompleteEntity? match;
  if (title.isNotEmpty) {
    for (final t in expenses) {
      if (t.transaction.description.trim().toLowerCase() == title) {
        match = t;
        break;
      }
    }
    if (match == null) {
      final word = RegExp('\\b${RegExp.escape(title)}\\b');
      for (final t in expenses) {
        if (word.hasMatch(t.transaction.description.toLowerCase())) {
          match = t;
          break;
        }
      }
    }
  }

  if (match != null) {
    final wallet = wallets.firstWhere(
      (w) => w.clientId == match!.transaction.walletClientId,
      orElse: () => match!.wallet,
    );
    return NextBill(
      reminder: reminder,
      date: date,
      wallet: wallet,
      amount: match.transaction.amount,
    );
  }

  final fallback = wallets.firstWhere(
    (w) => w.clientId == defaultWalletId,
    orElse: () => wallets.first,
  );
  return NextBill(
    reminder: reminder,
    date: date,
    wallet: fallback,
    amount: null,
  );
}
