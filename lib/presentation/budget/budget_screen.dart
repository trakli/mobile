import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/budget/budget_detail_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _onlyActive = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<BudgetCubit>().loadBudgets();
  }

  void _add() {
    AppNavigator.push(context, const AddBudgetScreen());
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.budgetPageTitle.tr(),
        showBack: false,
        onSearchChanged: (v) => setState(() => _query = v),
        searchHint: LocaleKeys.searchBudgets.tr(),
        actions: [
          PageAppBarAction(icon: LucideIcons.plus, onTap: _add, primary: true),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            if (state.isLoading && state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final q = _query.trim().toLowerCase();
            final filtered = state.budgets.where((b) {
              if (_onlyActive && !b.isActive) return false;
              if (q.isEmpty) return true;
              return '${b.name} ${b.description ?? ''}'
                  .toLowerCase()
                  .contains(q);
            }).toList();

            if (state.budgets.isEmpty) {
              return _EmptyState(onAdd: _add);
            }

            return ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 120.lx),
              children: [
                LedgerChipRow(
                  children: [
                    LedgerFilterChip(
                      label: LocaleKeys.filterAll.tr(),
                      selected: !_onlyActive,
                      onTap: () => setState(() => _onlyActive = false),
                    ),
                    LedgerFilterChip(
                      label: LocaleKeys.filterActive.tr(),
                      selected: _onlyActive,
                      onTap: () => setState(() => _onlyActive = true),
                    ),
                  ],
                ),
                SizedBox(height: 10.lx),
                if (filtered.isEmpty)
                  _NoMatches(query: _query)
                else
                  for (final budget in filtered) ...[
                    _BudgetCard(
                      budget: budget,
                      onTap: () => AppNavigator.push(
                        context,
                        BudgetDetailScreen(budget: budget),
                      ),
                      onEdit: () => AppNavigator.push(
                        context,
                        AddBudgetScreen(budget: budget),
                      ),
                      onDelete: () => context
                          .read<BudgetCubit>()
                          .deleteBudget(budget.clientId),
                    ),
                    SizedBox(height: 8.lx),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetEntity budget;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  String _periodLabel() {
    return switch (budget.periodType) {
      BudgetPeriodType.weekly => LocaleKeys.periodWeekly.tr(),
      BudgetPeriodType.monthly => LocaleKeys.periodMonthly.tr(),
      BudgetPeriodType.yearly => LocaleKeys.periodYearly.tr(),
      BudgetPeriodType.custom => LocaleKeys.periodCustom.tr(),
    };
  }

  List<String> _scopeLabels() {
    if (budget.targets.isEmpty) return [LocaleKeys.scopeAllTransactions.tr()];
    final byType = <BudgetTargetType, int>{};
    for (final t in budget.targets) {
      byType[t.type] = (byType[t.type] ?? 0) + 1;
    }
    return byType.entries.map((e) {
      return switch (e.key) {
        BudgetTargetType.category =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeCategorySingular.tr() : LocaleKeys.categories.tr()}',
        BudgetTargetType.wallet =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeWalletSingular.tr() : LocaleKeys.wallets.tr()}',
        BudgetTargetType.group =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeGroupSingular.tr() : LocaleKeys.groups.tr()}',
      };
    }).toList();
  }

  Color _barColor(AppTones t, BudgetStatus? status) => switch (status) {
        BudgetStatus.overBudget => t.expenseColor,
        BudgetStatus.forecastBreach || BudgetStatus.nearLimit => t.accentWarm,
        BudgetStatus.onTrack => t.incomeColor,
        null => t.textMuted,
      };

  LedgerChipTone _statusTone(BudgetStatus? status) => switch (status) {
        BudgetStatus.overBudget => LedgerChipTone.bad,
        BudgetStatus.forecastBreach ||
        BudgetStatus.nearLimit =>
          LedgerChipTone.warm,
        BudgetStatus.onTrack => LedgerChipTone.good,
        null => LedgerChipTone.neutral,
      };

  String _statusLabel(BudgetStatus? status) {
    return switch (status) {
      BudgetStatus.overBudget => LocaleKeys.budgetStatusOverBudget.tr(),
      BudgetStatus.forecastBreach => LocaleKeys.budgetStatusForecastBreach.tr(),
      BudgetStatus.nearLimit => LocaleKeys.budgetStatusNearLimit.tr(),
      BudgetStatus.onTrack => LocaleKeys.budgetStatusOnTrack.tr(),
      null => LocaleKeys.budgetStatusAwaitingSync.tr(),
    };
  }

  String _money(double value) => LedgerMoney.format(value, budget.currency);

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final progress = budget.progress;
    final spent = progress?.netSpent ?? 0.0;
    final limit = progress?.effectiveLimit ?? budget.amount;
    final refunds = progress?.refunds ?? 0.0;
    final isOver = spent > limit;
    final locale = Localizations.localeOf(context).toString();
    final meta = [
      progress != null
          ? '${_periodLabel()} · ${DateFormat.MMMd(locale).format(progress.periodStart)}'
          : _periodLabel(),
      ..._scopeLabels(),
    ].join(' · ');

    return LedgerCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  budget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5.lx,
                    fontWeight: FontWeight.w600,
                    color: t.textPrimary,
                  ),
                ),
              ),
              if (!budget.isActive) ...[
                LedgerChip(LocaleKeys.statusInactive.tr()),
                SizedBox(width: 6.lx),
              ],
              LedgerChip(
                _statusLabel(progress?.status),
                tone: _statusTone(progress?.status),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                tooltip: LocaleKeys.budgetDetailMore.tr(),
                icon: Icon(
                  LucideIcons.ellipsisVertical,
                  size: 16.lx,
                  color: t.textMuted,
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(LocaleKeys.edit.tr()),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(LocaleKeys.delete.tr()),
                  ),
                ],
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
              ),
            ],
          ),
          Text(
            meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.lx, color: t.textMuted),
          ),
          SizedBox(height: 10.lx),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              LedgerAmount(
                _money(spent),
                size: 18,
                weight: FontWeight.w600,
                color: isOver ? t.expenseColor : t.textPrimary,
              ),
              SizedBox(width: 6.lx),
              Expanded(
                child: Text(
                  isOver
                      ? LocaleKeys.budgetDetailOfLimitOver.tr(namedArgs: {
                          'limit': _money(limit),
                          'amount': _money(spent - limit),
                        })
                      : LocaleKeys.budgetDetailOfLimitLeft.tr(namedArgs: {
                          'limit': _money(limit),
                          'amount': _money(limit - spent),
                        }),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.lx),
          SizedBox(
            width: double.infinity,
            child: LedgerBar(
              value: limit > 0 ? spent / limit : 0,
              color: _barColor(t, progress?.status),
            ),
          ),
          if (refunds > 0) ...[
            SizedBox(height: 8.lx),
            Align(
              alignment: Alignment.centerLeft,
              child: LedgerChip(
                _money(refunds),
                icon: LucideIcons.undo2,
                tone: LedgerChipTone.good,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.lx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LedgerCoin(icon: LucideIcons.target, size: 48),
            SizedBox(height: 14.lx),
            Text(
              LocaleKeys.noBudgetsYet.tr(),
              style: TextStyle(
                fontSize: 17.lx,
                fontWeight: FontWeight.w700,
                color: t.textPrimary,
              ),
            ),
            SizedBox(height: 6.lx),
            Text(
              LocaleKeys.noBudgetsDescription.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
            ),
            SizedBox(height: 18.lx),
            LedgerButton(
              label: LocaleKeys.createBudget.tr(),
              icon: LucideIcons.plus,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  final String query;
  const _NoMatches({required this.query});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.lx),
      child: Text(
        query.isEmpty
            ? LocaleKeys.noBudgetsMatchFilter.tr()
            : LocaleKeys.noMatchesForQuery.tr().replaceFirst('{0}', query),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
      ),
    );
  }
}
