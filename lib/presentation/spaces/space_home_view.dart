import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/space_budget_screen.dart';
import 'package:trakli/presentation/spaces/space_format.dart';
import 'package:trakli/presentation/spaces/space_switcher_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Home for the active shared space. Renders nothing on the personal ledger.
class SpaceHomeView extends StatefulWidget {
  /// Fixes "this month"; defaults to the clock.
  final DateTime? now;

  const SpaceHomeView({super.key, this.now});

  @override
  State<SpaceHomeView> createState() => _SpaceHomeViewState();
}

class _SpaceHomeViewState extends State<SpaceHomeView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<SpaceCubit>();
    final s = cubit.state;
    if (!s.isPersonal && s.overview == null && !s.isLoadingSpace) {
      cubit.loadActive();
    }
    if (!s.hasLoadedSpaces && !s.isLoadingSpaces) cubit.loadSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceCubit, SpaceState>(
      builder: (context, state) {
        if (state.isPersonal) return const SizedBox.shrink();
        return RefreshIndicator(
          onRefresh: () => context.read<SpaceCubit>().loadActive(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 24.lx),
            children: _children(context, state),
          ),
        );
      },
    );
  }

  List<Widget> _children(BuildContext context, SpaceState state) {
    final t = context.tones;
    final space = state.activeSpace;
    final overview = state.overview;
    final header = Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _SpaceButton(
              name: space?.name ?? '',
              onTap: () => showSpaceSwitcherSheet(context),
            ),
          ),
        ),
        SizedBox(width: 10.lx),
        _MemberFaces(members: state.members),
      ],
    );

    if (overview == null) {
      final failed = !state.isLoadingSpace &&
          state.failure != const Failure.none();
      return [
        header,
        SizedBox(height: 40.lx),
        if (failed) ...[
          Text(
            state.failure.customMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
          ),
          SizedBox(height: 12.lx),
          Center(
            child: LedgerButton(
              label: LocaleKeys.retry.tr(),
              icon: LucideIcons.refreshCw,
              style: LedgerButtonStyle.outline,
              onPressed: () => context.read<SpaceCubit>().loadActive(),
            ),
          ),
        ] else
          Center(child: CircularProgressIndicator(color: t.brandText)),
      ];
    }

    final now = widget.now ?? DateTime.now();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final spending = spaceSpendingByCurrency(state.monthTransactions);
    final budgets = overview.budgets.where((b) => b.isActive).toList();
    final currency = spending.isNotEmpty
        ? (budgets.isNotEmpty &&
                spending.any((e) => e.key == budgets.first.currency)
            ? budgets.first.currency
            : spending.first.key)
        : (budgets.isNotEmpty
            ? budgets.first.currency
            : (overview.wallets.isNotEmpty
                ? overview.wallets.first.currency
                : 'EUR'));
    final primary = spending
        .firstWhere((e) => e.key == currency,
            orElse: () => MapEntry(currency, 0))
        .value;
    final others = spending.where((e) => e.key != currency).toList();
    final sameCur = budgets.where((b) => b.currency == currency).toList();
    final left = sameCur.fold<double>(0, (s, b) => s + b.remaining);

    String? budgetLine;
    if (sameCur.isNotEmpty) {
      final amount = LedgerMoney.format(left.abs(), currency);
      budgetLine = left < 0
          ? LocaleKeys.spaceOverAcrossBudgets.tr(namedArgs: {'amount': amount})
          : sameCur.length == 1
              ? LocaleKeys.spaceLeftInOneBudget
                  .tr(namedArgs: {'amount': amount})
              : LocaleKeys.spaceLeftAcrossBudgets.tr(namedArgs: {
                  'amount': amount,
                  'count': '${sameCur.length}',
                });
    }

    return [
      header,
      SizedBox(height: 14.lx),
      if (space != null && space.readOnly) ...[
        LedgerInsight(
          icon: LucideIcons.pause,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.spaceReadOnlyTitle
                    .tr(namedArgs: {'name': space.name}),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                space.role == SpaceRole.owner
                    ? LocaleKeys.spaceReadOnlyOwner.tr()
                    : LocaleKeys.spaceReadOnlyMember.tr(),
                style: TextStyle(color: t.textSecondary),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.lx),
      ],
      Text(
        LocaleKeys.spaceSharedSpendingIn.tr(namedArgs: {
          'month': DateFormat.MMMM(locale).format(now),
        }),
        style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
      ),
      SizedBox(height: 6.lx),
      LedgerBigNumber(LedgerMoney.format(primary, currency)),
      if (others.isNotEmpty) ...[
        SizedBox(height: 6.lx),
        Text(
          LocaleKeys.spaceAlsoInOtherCurrencies.tr(namedArgs: {
            'amounts':
                others.map((e) => LedgerMoney.format(e.value, e.key)).join(', '),
          }),
          style: LedgerText.money(size: 12.lx, color: t.textSecondary),
        ),
      ],
      if (budgetLine != null) ...[
        SizedBox(height: 6.lx),
        Text(
          budgetLine,
          style: TextStyle(
            fontSize: 12.5.lx,
            color: left < 0 ? t.expenseColor : t.brandText,
          ),
        ),
      ],
      SizedBox(height: 14.lx),
      LedgerCard(
        child: budgets.isEmpty
            ? Text(
                LocaleKeys.spaceNoBudgets.tr(),
                style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
              )
            : Column(
                children: [
                  for (var i = 0; i < budgets.length; i++)
                    _BudgetLine(
                      budget: budgets[i],
                      last: i == budgets.length - 1,
                      onTap: () => _openBudget(context, budgets[i]),
                    ),
                ],
              ),
      ),
      SizedBox(height: 12.lx),
      LedgerCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LedgerH6(LocaleKeys.spaceLatest.tr()),
            SizedBox(height: 4.lx),
            if (state.latest.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.lx),
                child: Text(
                  LocaleKeys.spaceNoActivity.tr(),
                  style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                ),
              ),
            for (var i = 0; i < state.latest.length && i < 8; i++)
              _LatestRow(
                tx: state.latest[i],
                overview: overview,
                divider: i < state.latest.length - 1 && i < 7,
              ),
          ],
        ),
      ),
    ];
  }

  void _openBudget(BuildContext context, SpaceBudgetEntity budget) {
    final cubit = context.read<SpaceCubit>();
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SpaceBudgetScreen(budgetId: budget.id),
      ),
    ));
  }
}

class _SpaceButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _SpaceButton({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Material(
      color: t.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        side: BorderSide(color: t.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.lx, vertical: 7.lx),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.lx,
                height: 8.lx,
                decoration: BoxDecoration(
                  color: t.accentWarm,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 8.lx),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5.lx,
                    fontWeight: FontWeight.w700,
                    color: t.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 6.lx),
              Icon(LucideIcons.chevronDown, size: 16.lx, color: t.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberFaces extends StatelessWidget {
  final List<SpaceMemberEntity> members;

  const _MemberFaces({required this.members});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final shown = members.take(4).toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final m in shown)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: t.bgPage, width: 1.5),
              borderRadius: BorderRadius.circular(AppRadii.sm + 1),
            ),
            child: m.name == null
                ? const LedgerCoin(icon: LucideIcons.user, size: 22)
                : LedgerInitials(m.name!, size: 22),
          ),
        if (members.length > shown.length)
          Padding(
            padding: EdgeInsets.only(left: 4.lx),
            child: Text(
              '+${members.length - shown.length}',
              style: TextStyle(fontSize: 11.lx, color: t.textMuted),
            ),
          ),
      ],
    );
  }
}

class _BudgetLine extends StatelessWidget {
  final SpaceBudgetEntity budget;
  final bool last;
  final VoidCallback onTap;

  const _BudgetLine({
    required this.budget,
    required this.last,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final ratio = spaceBudgetRatio(budget);
    final cur = budget.currency;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 12.lx),
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
                    style: TextStyle(fontSize: 13.lx, color: t.textPrimary),
                  ),
                ),
                LedgerAmount(
                  '${LedgerMoney.format(budget.spent, cur, short: true)} / '
                  '${LedgerMoney.format(budget.limit, cur, short: true)}',
                  size: 12.5,
                ),
              ],
            ),
            SizedBox(height: 6.lx),
            LedgerBar(value: ratio, color: spaceBudgetColor(t, ratio)),
          ],
        ),
      ),
    );
  }
}

class _LatestRow extends StatelessWidget {
  final SpaceTransactionEntity tx;
  final SpaceOverviewEntity overview;
  final bool divider;

  const _LatestRow({
    required this.tx,
    required this.overview,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final who = spaceContributorName(tx.contributor);
    final label = spaceTransactionLabel(tx, overview);
    return LedgerRow(
      leading: tx.contributor.trim().isEmpty
          ? const LedgerCoin(icon: LucideIcons.user, size: 26)
          : LedgerInitials(who, size: 26),
      title: spaceTransactionTitle(tx, overview),
      subtitle: [who, if (label != null && label.isNotEmpty) label].join(' · '),
      divider: divider,
      verticalPadding: 9,
      trailing: LedgerAmount(
        spaceSignedAmount(tx),
        color: tx.isIncome ? t.incomeColor : t.expenseColor,
      ),
    );
  }
}
