import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/budget/budget_activity.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs.dart'
    show showDeleteConfirmationDialog, showConfirmationDialog;
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, formatDateYmd;
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

enum _BudgetAction { edit, closePeriod, delete }

class BudgetDetailScreen extends StatefulWidget {
  final BudgetEntity budget;
  const BudgetDetailScreen({super.key, required this.budget});

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<BudgetCubit>();
    cubit.watchBudget(widget.budget.clientId);
  }

  BudgetEntity _currentBudget(BudgetState state) {
    return state.budgets.firstWhere(
      (b) => b.clientId == widget.budget.clientId,
      orElse: () => widget.budget,
    );
  }

  bool _budgetWasDeleted(BudgetState state) {
    return state.budgets.length < (_currentBudget(state).id != null ? 1 : 0);
  }

  Future<void> _confirmDelete(BudgetEntity budget) async {
    final confirm = await showDeleteConfirmationDialog(
      context,
      title: LocaleKeys.deleteBudget.tr(),
      message:
          LocaleKeys.deleteBudgetConfirm.tr(namedArgs: {'name': budget.name}),
    );
    if (!confirm || !mounted) return;

    if (mounted) {
      context.read<BudgetCubit>().deleteBudget(budget.clientId);
    }
  }

  Future<void> _confirmClosePeriod(BudgetEntity budget) async {
    final id = budget.id;
    if (id == null) return;
    final confirm = await showConfirmationDialog(
      context,
      title: LocaleKeys.closePeriodTitle.tr(),
      message: LocaleKeys.closePeriodMessage.tr(),
      confirmText: LocaleKeys.closePeriodConfirm.tr(),
    );
    if (!confirm || !mounted) return;

    if (mounted) {
      context.read<BudgetCubit>().closeBudgetPeriod(id);
    }
  }

  void _onAction(_BudgetAction action, BudgetEntity budget) {
    switch (action) {
      case _BudgetAction.edit:
        AppNavigator.push(context, AddBudgetScreen(budget: budget));
      case _BudgetAction.closePeriod:
        _confirmClosePeriod(budget);
      case _BudgetAction.delete:
        _confirmDelete(budget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      body: SafeArea(
        child: BlocListener<BudgetCubit, BudgetState>(
          listenWhen: (prev, curr) {
            final deletionCompleted = prev.isDeleting && !curr.isDeleting;
            final closingCompleted =
                prev.isClosingPeriod && !curr.isClosingPeriod;
            return deletionCompleted || closingCompleted;
          },
          listener: (context, state) {
            if (state.isDeleting || state.isClosingPeriod) return;

            if (state.failure != const Failure.none()) {
              showSnackBar(
                message: state.isDeleting
                    ? LocaleKeys.deleteBudgetError.tr()
                    : LocaleKeys.closePeriodError.tr(),
              );
              return;
            }

            if (_budgetWasDeleted(state)) {
              showSnackBar(
                message: LocaleKeys.deleteBudgetSuccess.tr(),
                isSuccess: true,
              );
              AppNavigator.pop(context);
            } else {
              showSnackBar(
                message: LocaleKeys.closePeriodSuccess.tr(),
                isSuccess: true,
              );
            }
          },
          child: BlocBuilder<BudgetCubit, BudgetState>(
            builder: (context, state) {
              final budget = _currentBudget(state);
              final canClose = budget.rolloverEnabled && budget.id != null;
              return ListView(
                padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 24.lx),
                children: [
                  LedgerScreenBar(
                    leadingIcon: LucideIcons.chevronLeft,
                    title: budget.name,
                    actions: [
                      PopupMenuButton<_BudgetAction>(
                        tooltip: LocaleKeys.budgetDetailMore.tr(),
                        onSelected: (a) => _onAction(a, budget),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: _BudgetAction.edit,
                            child: _MenuLabel(
                              icon: LucideIcons.pencil,
                              text: LocaleKeys.edit.tr(),
                            ),
                          ),
                          if (canClose)
                            PopupMenuItem(
                              value: _BudgetAction.closePeriod,
                              enabled: !state.isClosingPeriod,
                              child: _MenuLabel(
                                icon: LucideIcons.lock,
                                text: LocaleKeys.closePeriod.tr(),
                              ),
                            ),
                          PopupMenuItem(
                            value: _BudgetAction.delete,
                            child: _MenuLabel(
                              icon: LucideIcons.trash2,
                              text: LocaleKeys.delete.tr(),
                              color: tones.expenseColor,
                            ),
                          ),
                        ],
                        child: const LedgerIconButton(
                          icon: LucideIcons.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.lx),
                  _BudgetBody(
                    budget: budget,
                    periods: state.selectedBudgetPeriodStates,
                    isClosingPeriod: state.isClosingPeriod,
                    onClosePeriod:
                        canClose ? () => _confirmClosePeriod(budget) : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _MenuLabel({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.tones.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 16.lx, color: c),
        SizedBox(width: 10.lx),
        Text(text, style: TextStyle(fontSize: 13.5.lx, color: c)),
      ],
    );
  }
}

class _BudgetBody extends StatelessWidget {
  final BudgetEntity budget;
  final List<BudgetPeriodStateEntity> periods;
  final bool isClosingPeriod;
  final VoidCallback? onClosePeriod;

  const _BudgetBody({
    required this.budget,
    required this.periods,
    required this.isClosingPeriod,
    required this.onClosePeriod,
  });

  (DateTime, DateTime) _period(BudgetProgressEntity? progress) {
    if (progress != null) return (progress.periodStart, progress.periodEnd);
    final now = DateTime.now();
    final start = budget.startDate;
    final end = budget.endDate ??
        switch (budget.periodType) {
          BudgetPeriodType.weekly => start.add(const Duration(days: 6)),
          BudgetPeriodType.monthly => DateTime(now.year, now.month + 1, 0),
          BudgetPeriodType.yearly => DateTime(start.year, 12, 31),
          BudgetPeriodType.custom => now,
        };
    final monthlyStart = budget.periodType == BudgetPeriodType.monthly
        ? DateTime(now.year, now.month, 1)
        : start;
    return (monthlyStart, end);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final progress = budget.progress;
    final transactions = context.watch<TransactionCubit>().state.transactions;
    final rates = context.watch<ExchangeRateCubit>().state.entity;
    final (start, end) = _period(progress);
    final matching = budgetTransactions(budget, transactions, start, end);
    double amountOf(TransactionCompleteEntity tx) =>
        amountInCurrency(tx, budget.currency, rates);

    final limit = progress?.effectiveLimit ?? budget.amount;
    final spent = progress?.netSpent ??
        matching.fold<double>(0, (sum, tx) => sum + amountOf(tx));
    final status = progress?.status;
    final isOver = status == BudgetStatus.overBudget || spent > limit;
    final isWarm = !isOver &&
        (status == BudgetStatus.nearLimit ||
            status == BudgetStatus.forecastBreach);
    final overPace = isOver ||
        (progress != null && progress.projectedSpend > progress.effectiveLimit);

    String money(double v, {int? decimals}) =>
        LedgerMoney.format(v, budget.currency, decimals: decimals);

    final weeks = bucketBudgetWeeks(
      transactions: matching,
      start: start,
      end: end,
      amountOf: amountOf,
      today: DateTime.now(),
    );
    final maxWeek =
        weeks.fold<double>(0, (m, w) => w.amount > m ? w.amount : m);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LedgerBigNumber(
          money(spent),
          color: isOver ? t.expenseColor : t.textPrimary,
        ),
        SizedBox(height: 4.lx),
        Text(
          isOver
              ? LocaleKeys.budgetDetailOfLimitOver.tr(namedArgs: {
                  'limit': money(limit),
                  'amount': money(spent - limit),
                })
              : LocaleKeys.budgetDetailOfLimitLeft.tr(namedArgs: {
                  'limit': money(limit),
                  'amount': money(limit - spent),
                }),
          style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
        ),
        SizedBox(height: 12.lx),
        LedgerBar(
          value: limit <= 0 ? (spent > 0 ? 1 : 0) : spent / limit,
          height: 10,
          color: isOver
              ? t.expenseColor
              : isWarm
                  ? t.accentWarm
                  : t.brandFill,
        ),
        SizedBox(height: 12.lx),
        LedgerCard(
          padding: EdgeInsets.fromLTRB(12.lx, 10.lx, 12.lx, 10.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerH6(
                weeks.isNotEmpty && weeks.first.byMonth
                    ? LocaleKeys.budgetDetailByMonth.tr()
                    : LocaleKeys.budgetDetailByWeek.tr(),
              ),
              SizedBox(height: 6.lx),
              LedgerWeekBars(
                bars: [
                  for (final w in weeks)
                    LedgerWeekBar(
                      label: w.byMonth
                          ? DateFormat.MMM().format(w.start)
                          : w.start.day == w.end.day
                              ? '${w.start.day}'
                              : '${w.start.day}–${w.end.day}',
                      value: w.amount,
                      valueLabel: money(w.amount, decimals: 0),
                      hot: overPace && maxWeek > 0 && w.amount == maxWeek,
                    ),
                ],
              ),
            ],
          ),
        ),
        if (progress != null) ...[
          SizedBox(height: 12.lx),
          LedgerInsight(
            icon: LucideIcons.trendingUp,
            child: _PaceText(
              budget: budget,
              progress: progress,
              amount: money(progress.projectedSpend, decimals: 0),
            ),
          ),
        ] else if (budget.id == null) ...[
          SizedBox(height: 12.lx),
          LedgerInsight(
            icon: LucideIcons.info,
            child: Text(LocaleKeys.budgetNoProgress.tr()),
          ),
        ],
        SizedBox(height: 6.lx),
        if (matching.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.lx),
            child: Text(
              LocaleKeys.budgetDetailNoSpending.tr(),
              style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
            ),
          )
        else
          for (var i = 0; i < matching.length && i < 3; i++)
            LedgerRow(
              verticalPadding: 7,
              divider: i < 2 && i < matching.length - 1,
              title: matching[i].transaction.description.isNotEmpty
                  ? matching[i].transaction.description
                  : (matching[i].categories.isNotEmpty
                      ? matching[i].categories.first.name
                      : LocaleKeys.noDescription.tr()),
              subtitle:
                  '${DateFormat.MMMd().format(matching[i].transaction.datetime)} · ${matching[i].wallet.name}',
              trailing: LedgerAmount(
                LedgerMoney.format(
                  -matching[i].transaction.amount,
                  matching[i].wallet.currencyCode,
                ),
              ),
            ),
        SizedBox(height: 20.lx),
        _DetailsSection(
          budget: budget,
          progress: progress,
          rates: rates,
        ),
        SizedBox(height: 20.lx),
        LedgerH6(LocaleKeys.budgetTargetsLabel.tr()),
        SizedBox(height: 8.lx),
        _TargetsBlock(budget: budget),
        if (budget.rolloverEnabled) ...[
          SizedBox(height: 20.lx),
          LedgerH6(LocaleKeys.budgetPeriodHistoryLabel.tr()),
          SizedBox(height: 8.lx),
          _PeriodHistoryBlock(periods: periods),
        ],
        if (onClosePeriod != null) ...[
          SizedBox(height: 20.lx),
          LedgerButton(
            label: LocaleKeys.closePeriod.tr(),
            icon: LucideIcons.lock,
            large: true,
            busy: isClosingPeriod,
            onPressed: isClosingPeriod ? null : onClosePeriod,
          ),
        ],
      ],
    );
  }
}

class _PaceText extends StatelessWidget {
  final BudgetEntity budget;
  final BudgetProgressEntity progress;
  final String amount;

  const _PaceText({
    required this.budget,
    required this.progress,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    const marker = '\u0000';
    final sentence = budget.periodType == BudgetPeriodType.monthly
        ? LocaleKeys.budgetDetailPaceMonth.tr(namedArgs: {
            'month': DateFormat.MMMM().format(progress.periodEnd),
            'amount': marker,
          })
        : LocaleKeys.budgetDetailPacePeriod.tr(namedArgs: {'amount': marker});
    final parts = sentence.split(marker);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: amount,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (parts.length > 1) TextSpan(text: parts.sublist(1).join()),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final BudgetEntity budget;
  final BudgetProgressEntity? progress;
  final ExchangeRateEntity? rates;

  const _DetailsSection({
    required this.budget,
    required this.progress,
    required this.rates,
  });

  String _statusLabel(BudgetStatus? status) {
    return switch (status) {
      BudgetStatus.overBudget => LocaleKeys.budgetStatusOverBudget.tr(),
      BudgetStatus.forecastBreach => LocaleKeys.budgetStatusForecastBreach.tr(),
      BudgetStatus.nearLimit => LocaleKeys.budgetStatusNearLimit.tr(),
      BudgetStatus.onTrack => LocaleKeys.budgetStatusOnTrack.tr(),
      null => LocaleKeys.budgetStatusAwaitingSync.tr(),
    };
  }

  LedgerChipTone _statusTone(BudgetStatus? status) {
    return switch (status) {
      BudgetStatus.overBudget => LedgerChipTone.bad,
      BudgetStatus.forecastBreach ||
      BudgetStatus.nearLimit =>
        LedgerChipTone.warm,
      BudgetStatus.onTrack => LedgerChipTone.good,
      null => LedgerChipTone.neutral,
    };
  }

  String _periodLabel() {
    final start = budget.startDate;
    if (budget.periodType == BudgetPeriodType.custom &&
        budget.endDate != null) {
      return '${formatDateYmd(start)} → ${formatDateYmd(budget.endDate!)}';
    }
    return switch (budget.periodType) {
      BudgetPeriodType.weekly =>
        '${LocaleKeys.budgetPeriodWeekly.tr()} ${formatDateYmd(start)}',
      BudgetPeriodType.monthly =>
        '${LocaleKeys.budgetPeriodMonthly.tr()} ${formatDateYmd(start)}',
      BudgetPeriodType.yearly =>
        '${LocaleKeys.budgetPeriodYearly.tr()} ${formatDateYmd(start)}',
      BudgetPeriodType.custom => formatDateYmd(start),
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final p = progress;
    String money(double v) => LedgerMoney.format(v, budget.currency);
    final cells = p == null
        ? const <(String, String)>[]
        : [
            (LocaleKeys.budgetKpiRemaining.tr(), money(p.remaining)),
            (LocaleKeys.budgetKpiProjected.tr(), money(p.projectedSpend)),
            (LocaleKeys.budgetKpiRefunds.tr(), money(p.refunds)),
            (LocaleKeys.budgetKpiRolloverIn.tr(), money(p.rolloverIn)),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LedgerH6(LocaleKeys.budgetDetailDetails.tr()),
        SizedBox(height: 8.lx),
        Wrap(
          spacing: 8.lx,
          runSpacing: 6.lx,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LedgerChip(
              _statusLabel(p?.status),
              tone: _statusTone(p?.status),
            ),
            Text(
              _periodLabel(),
              style: TextStyle(fontSize: 12.lx, color: t.textMuted),
            ),
          ],
        ),
        if (budget.description != null && budget.description!.isNotEmpty) ...[
          SizedBox(height: 8.lx),
          Text(
            budget.description!,
            style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
          ),
        ],
        if (cells.isNotEmpty) ...[
          SizedBox(height: 10.lx),
          for (var row = 0; row < cells.length; row += 2) ...[
            if (row > 0) SizedBox(height: 8.lx),
            Row(
              children: [
                for (var i = row; i < row + 2 && i < cells.length; i++) ...[
                  if (i > row) SizedBox(width: 8.lx),
                  Expanded(
                    child: LedgerCard(
                      padding: EdgeInsets.all(10.lx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cells[i].$1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.lx,
                              color: t.textMuted,
                            ),
                          ),
                          SizedBox(height: 2.lx),
                          LedgerAmount(
                            cells[i].$2,
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ],
    );
  }
}

class _TargetsBlock extends StatelessWidget {
  final BudgetEntity budget;
  const _TargetsBlock({required this.budget});

  String _typeLabel(BudgetTargetType type) {
    return switch (type) {
      BudgetTargetType.category => LocaleKeys.budgetTargetCategory.tr(),
      BudgetTargetType.wallet => LocaleKeys.budgetTargetWallet.tr(),
      BudgetTargetType.group => LocaleKeys.budgetTargetGroup.tr(),
    };
  }

  IconData _iconFor(BudgetTargetType type) {
    return switch (type) {
      BudgetTargetType.category => LucideIcons.tag,
      BudgetTargetType.wallet => LucideIcons.wallet,
      BudgetTargetType.group => LucideIcons.folder,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    if (budget.targets.isEmpty) {
      return LedgerCard(
        child: Text(
          LocaleKeys.budgetTargetsApplyAll.tr(),
          style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
        ),
      );
    }
    return LedgerCard(
      padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 2.lx),
      child: Column(
        children: [
          for (var i = 0; i < budget.targets.length; i++)
            LedgerRow(
              leading: LedgerCoin(icon: _iconFor(budget.targets[i].type)),
              title: budget.targets[i].name ??
                  LocaleKeys.budgetTargetUnnamed.tr(),
              subtitle: _typeLabel(budget.targets[i].type),
              divider: i != budget.targets.length - 1,
            ),
        ],
      ),
    );
  }
}

class _PeriodHistoryBlock extends StatelessWidget {
  final List<BudgetPeriodStateEntity> periods;
  const _PeriodHistoryBlock({required this.periods});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    if (periods.isEmpty) {
      return LedgerCard(
        child: Text(
          LocaleKeys.budgetNoPeriods.tr(),
          style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
        ),
      );
    }
    return LedgerCard(
      padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 2.lx),
      child: Column(
        children: [
          for (var i = 0; i < periods.length; i++)
            LedgerRow(
              title:
                  '${formatDateYmd(periods[i].periodStart)} → ${formatDateYmd(periods[i].periodEnd)}',
              subtitle: 'Spent ${periods[i].netSpent.toStringAsFixed(2)}'
                  ' · rollover in ${periods[i].rolloverIn.toStringAsFixed(2)}'
                  ' · rollover out ${periods[i].rolloverOut.toStringAsFixed(2)}',
              trailing: periods[i].closedAt == null
                  ? LedgerChip(
                      LocaleKeys.budgetPeriodOpen.tr(),
                      tone: LedgerChipTone.good,
                    )
                  : null,
              divider: i != periods.length - 1,
            ),
        ],
      ),
    );
  }
}
