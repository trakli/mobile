import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/space_format.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class SpaceBudgetScreen extends StatefulWidget {
  final int budgetId;

  /// Fixes "today" for the days-left figure; defaults to the clock.
  final DateTime? now;

  const SpaceBudgetScreen({super.key, required this.budgetId, this.now});

  @override
  State<SpaceBudgetScreen> createState() => _SpaceBudgetScreenState();
}

class _SpaceBudgetScreenState extends State<SpaceBudgetScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<SpaceCubit>();
    if (!cubit.state.budgetTransactions.containsKey(widget.budgetId)) {
      cubit.loadBudget(widget.budgetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      body: SafeArea(
        child: BlocBuilder<SpaceCubit, SpaceState>(
          builder: (context, state) {
            SpaceBudgetEntity? budget;
            for (final b in state.overview?.budgets ?? <SpaceBudgetEntity>[]) {
              if (b.id == widget.budgetId) budget = b;
            }
            final space = state.activeSpace;
            return ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 24.lx),
              children: [
                LedgerScreenBar(
                  title: budget?.name ?? '',
                  leadingIcon: LucideIcons.chevronLeft,
                  actions: [
                    if (space != null)
                      LedgerChip(space.name, tone: LedgerChipTone.warm),
                  ],
                ),
                if (budget != null) ...[
                  SizedBox(height: 14.lx),
                  ..._content(context, state, budget, space),
                ] else if (state.isLoadingSpace)
                  Padding(
                    padding: EdgeInsets.only(top: 40.lx),
                    child: Center(
                      child: CircularProgressIndicator(color: t.brandText),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    SpaceState state,
    SpaceBudgetEntity budget,
    SpaceEntity? space,
  ) {
    final t = context.tones;
    final cur = budget.currency;
    final ratio = spaceBudgetRatio(budget);
    final limit = LedgerMoney.format(budget.limit, cur);
    final remaining = budget.remaining;
    final progress = budget.progress;
    final today = widget.now ?? DateTime.now();
    String detail;
    if (remaining < 0) {
      detail = LocaleKeys.spaceBudgetOfOver.tr(namedArgs: {
        'limit': limit,
        'over': LedgerMoney.format(-remaining, cur),
      });
    } else if (progress != null) {
      final end = DateTime(progress.periodEnd.year, progress.periodEnd.month,
          progress.periodEnd.day);
      final days =
          end.difference(DateTime(today.year, today.month, today.day)).inDays +
              1;
      final args = {'limit': limit, 'left': LedgerMoney.format(remaining, cur)};
      detail = days == 1
          ? LocaleKeys.spaceBudgetOfLeftOneDay.tr(namedArgs: args)
          : days > 1
              ? LocaleKeys.spaceBudgetOfLeftDays
                  .tr(namedArgs: {...args, 'days': '$days'})
              : LocaleKeys.spaceBudgetOfLeft.tr(namedArgs: args);
    } else {
      detail = LocaleKeys.spaceBudgetOfLeft.tr(namedArgs: {
        'limit': limit,
        'left': LedgerMoney.format(remaining, cur),
      });
    }

    final txs = state.budgetTransactions[budget.id];
    final people = <String, double>{};
    for (final tx in txs ?? <SpaceTransactionEntity>[]) {
      if (tx.isIncome && !tx.isRefund) continue;
      final who = spaceContributorName(tx.contributor);
      final delta = tx.isRefund ? -tx.amount : tx.amount;
      people.update(who, (v) => v + delta, ifAbsent: () => delta);
    }
    final ranked = people.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = ranked.isEmpty ? 0.0 : ranked.first.value;
    final palette = [t.brandFill, t.accentWarm, t.textMuted];

    final locale = Localizations.localeOf(context).toLanguageTag();
    final notes = <String>[
      if (progress != null)
        LocaleKeys.spacePeriodCloses.tr(namedArgs: {
          'date': DateFormat.MMMd(locale).format(progress.periodEnd),
        }),
      if (budget.rolloverEnabled) LocaleKeys.spaceRolloverOn.tr(),
      if (space != null && space.canManage)
        LocaleKeys.spaceRolloverManager
            .tr(namedArgs: {'role': spaceRoleOf(space.role).toLowerCase()}),
    ];
    final canClose = space != null && space.canManage && space.canWrite;

    return [
      LedgerBigNumber(LedgerMoney.format(budget.spent, cur)),
      SizedBox(height: 6.lx),
      Text(detail, style: TextStyle(fontSize: 12.5.lx, color: t.textMuted)),
      SizedBox(height: 10.lx),
      LedgerBar(value: ratio, height: 10, color: spaceBudgetColor(t, ratio)),
      SizedBox(height: 14.lx),
      LedgerCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LedgerH6(LocaleKeys.spaceByPerson.tr()),
            SizedBox(height: 8.lx),
            if (txs == null && state.isLoadingBudget)
              Center(
                child: SizedBox(
                  width: 18.lx,
                  height: 18.lx,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: t.brandText,
                  ),
                ),
              )
            else if (ranked.isEmpty)
              Text(
                LocaleKeys.spaceBudgetNoSpending.tr(),
                style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
              ),
            for (var i = 0; i < ranked.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.lx),
                child: Row(
                  children: [
                    SizedBox(
                      width: 74.lx,
                      child: Text(
                        ranked[i].key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.lx,
                          color: t.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.lx),
                    Expanded(
                      child: LedgerBar(
                        value: top <= 0 ? 0 : ranked[i].value / top,
                        height: 8,
                        color: palette[i < palette.length ? i : 2],
                      ),
                    ),
                    SizedBox(
                      width: 78.lx,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: LedgerAmount(
                          LedgerMoney.format(ranked[i].value, cur),
                          size: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      if (notes.isNotEmpty) ...[
        SizedBox(height: 12.lx),
        LedgerInsight(
          icon: LucideIcons.calendarClock,
          child: Text(notes.join(' ')),
        ),
      ],
      if (canClose) ...[
        SizedBox(height: 12.lx),
        LedgerButton(
          label: LocaleKeys.spaceClosePeriod.tr(),
          icon: LucideIcons.calendarCheck,
          style: LedgerButtonStyle.outline,
          large: true,
          busy: state.isClosingPeriod,
          onPressed: () =>
              context.read<SpaceCubit>().closePeriod(budget.id),
        ),
      ],
    ];
  }
}
