import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/statistics/calendar/calendar_data.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class StatisticsCalendarTab extends StatefulWidget {
  final DateTime month;
  final VoidCallback? onOpenWallet;

  const StatisticsCalendarTab({
    super.key,
    required this.month,
    this.onOpenWallet,
  });

  @override
  State<StatisticsCalendarTab> createState() => _StatisticsCalendarTabState();
}

class _StatisticsCalendarTabState extends State<StatisticsCalendarTab> {
  int? _selectedDay;

  @override
  void didUpdateWidget(covariant StatisticsCalendarTab old) {
    super.didUpdateWidget(old);
    if (old.month != widget.month) _selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final month = widget.month;
    final isCurrent = month.year == now.year && month.month == now.month;
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final selected = _selectedDay ?? (isCurrent ? now.day : lastDay);

    final transactions = context.watch<TransactionCubit>().state.transactions;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final reminders = context.watch<ReminderCubit>().state.reminders;
    final defaultWalletId = context
        .watch<ConfigCubit>()
        .state
        .getConfigByKey(ConfigConstants.defaultWallet)
        ?.value as String?;
    final money = StatsMoney.of(context);

    final spend = dailySpend(transactions, month: month, convert: money.convert);
    final quiet = noSpendDays(spend, month: month, today: now);
    final due = reminderDays(reminders, month);
    final bill = findNextBill(
      reminders: reminders,
      transactions: transactions,
      wallets: wallets,
      now: now,
      defaultWalletId: defaultWalletId,
    );

    final selectedDate = DateTime(month.year, month.month, selected);
    final dayTxs = transactions
        .where((tx) =>
            !tx.transaction.isTransferLeg &&
            tx.transaction.datetime.year == selectedDate.year &&
            tx.transaction.datetime.month == selectedDate.month &&
            tx.transaction.datetime.day == selectedDate.day)
        .toList()
      ..sort((a, b) => b.transaction.datetime.compareTo(a.transaction.datetime));
    final isToday = isCurrent && selected == now.day;
    final dayLabel = DateFormat.MMMEd(locale).format(selectedDate);

    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 120.lx),
      children: [
        _MonthGrid(
          month: month,
          today: now,
          spend: spend,
          quiet: quiet,
          due: due,
          selected: selected,
          onSelect: (d) => setState(() => _selectedDay = d),
        ),
        if (bill != null) ...[
          SizedBox(height: 12.lx),
          LedgerCard(
            onTap: widget.onOpenWallet,
            padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 10.lx),
            child: Row(
              children: [
                const LedgerCoin(icon: LucideIcons.wallet),
                SizedBox(width: 10.lx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (bill.amount != null
                                ? LocaleKeys.statsCalendarAfter
                                : LocaleKeys.statsCalendarBefore)
                            .tr(namedArgs: {
                          'wallet': bill.wallet.name,
                          'bill': bill.reminder.title,
                          'date': DateFormat.MMMd(locale).format(bill.date),
                        }),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                      ),
                      LedgerAmount(
                        LedgerMoney.format(
                          bill.balanceAfter,
                          bill.wallet.currencyCode,
                        ),
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                if (widget.onOpenWallet != null)
                  Icon(LucideIcons.chevronRight,
                      size: 16.lx, color: t.textSecondary),
              ],
            ),
          ),
        ],
        SizedBox(height: 12.lx),
        LedgerCard(
          padding: EdgeInsets.fromLTRB(12.lx, 10.lx, 12.lx, 4.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LedgerH6(
                isToday
                    ? '${LocaleKeys.statsCalendarToday.tr()} · $dayLabel'
                    : dayLabel,
              ),
              if (dayTxs.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.lx),
                  child: Text(
                    LocaleKeys.statsCalendarNothing.tr(),
                    style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                  ),
                )
              else
                for (final tx in dayTxs)
                  LedgerRow(
                    verticalPadding: 7,
                    title: tx.transaction.description.isEmpty
                        ? (tx.party?.name ??
                            (tx.categories.isEmpty
                                ? tx.wallet.name
                                : tx.categories.first.name))
                        : tx.transaction.description,
                    trailing: LedgerAmount(
                      LedgerMoney.format(
                        tx.transaction.type == TransactionType.income
                            ? tx.transaction.amount
                            : -tx.transaction.amount,
                        tx.wallet.currencyCode,
                        sign: tx.transaction.type == TransactionType.income,
                      ),
                      color: tx.transaction.type == TransactionType.income
                          ? t.incomeColor
                          : null,
                    ),
                    divider: tx != dayTxs.last,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime today;
  final Map<int, double> spend;
  final Set<int> quiet;
  final Set<int> due;
  final int selected;
  final ValueChanged<int> onSelect;

  const _MonthGrid({
    required this.month,
    required this.today,
    required this.spend,
    required this.quiet,
    required this.due,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final locale = Localizations.localeOf(context).toString();
    final first = DateTime(month.year, month.month, 1);
    final lead = first.weekday - 1;
    final days = DateTime(month.year, month.month + 1, 0).day;
    final values = spend.values.where((v) => v > 0).toList()..sort();
    final ref = values.isEmpty
        ? 1.0
        : math.max(values[(values.length * 0.8).floor().clamp(0, values.length - 1)], 1.0);
    final todayDay = DateTime(today.year, today.month, today.day);
    final monday = DateTime(2024, 1, 1);
    final narrow = DateFormat.E(locale);

    final cells = <Widget>[
      for (var i = 0; i < 7; i++)
        Center(
          child: Text(
            narrow.format(monday.add(Duration(days: i))).characters.first.toUpperCase(),
            style: LedgerText.money(
              size: 9.5.lx,
              weight: FontWeight.w600,
              color: t.textMuted,
            ),
          ),
        ),
      for (var i = 0; i < lead; i++)
        Opacity(
          opacity: 0.3,
          child: Container(
            decoration: BoxDecoration(
              color: t.bgSurface,
              border: Border.all(color: t.borderLight),
              borderRadius: BorderRadius.circular(AppRadii.xs),
            ),
          ),
        ),
      for (var d = 1; d <= days; d++)
        _DayCell(
          day: d,
          intensity: () {
            final date = DateTime(month.year, month.month, d);
            final v = spend[d] ?? 0;
            if (v <= 0 || date.isAfter(todayDay)) return 0.0;
            return math.min(v / ref, 1.0) * 0.5 + 0.06;
          }(),
          isToday: DateTime(month.year, month.month, d) == todayDay,
          isFuture: DateTime(month.year, month.month, d).isAfter(todayDay),
          isQuiet: quiet.contains(d),
          isDue: due.contains(d),
          isSelected: d == selected,
          onTap: () => onSelect(d),
        ),
    ];

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 3.lx,
      crossAxisSpacing: 3.lx,
      children: cells,
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final double intensity;
  final bool isToday;
  final bool isFuture;
  final bool isQuiet;
  final bool isDue;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.intensity,
    required this.isToday,
    required this.isFuture,
    required this.isQuiet,
    required this.isDue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final borderColor = isToday
        ? t.accentWarm
        : (isSelected ? t.textMuted : t.borderLight);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: t.bgSurface,
          border: Border.all(
            color: borderColor,
            width: isToday ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadii.xs),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (isFuture)
              Positioned.fill(
                child: CustomPaint(
                  painter: _HatchPainter(color: t.surface2),
                ),
              ),
            if (intensity > 0)
              Positioned.fill(
                child: ColoredBox(
                  color: t.brandFill.withValues(alpha: intensity),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(3.lx, 2.lx, 3.lx, 2.lx),
              child: Text(
                '$day',
                style: LedgerText.money(
                  size: 9.5.lx,
                  color: t.textMuted,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            if (isQuiet || isDue)
              Positioned(
                right: 3.lx,
                bottom: 3.lx,
                child: Container(
                  width: 5.lx,
                  height: 5.lx,
                  decoration: BoxDecoration(
                    color: isDue ? t.accentWarm : t.brandText,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  final Color color;
  _HatchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    const step = 5.0;
    for (var x = -size.height; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HatchPainter old) => old.color != color;
}
