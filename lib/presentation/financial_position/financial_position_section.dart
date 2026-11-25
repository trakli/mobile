import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/financial_position/cubit/financial_position_cubit.dart';
import 'package:trakli/presentation/financial_position/financial_position_drill_bottom_sheet.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/holdings/holdings_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/draggable_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

String _money(double value, String? currency, {bool sign = false}) =>
    LedgerMoney.format(value, currency ?? '', sign: sign).trim();

/// Server-computed net worth page body. Provides its own
/// [FinancialPositionCubit].
class FinancialPositionSection extends StatelessWidget {
  const FinancialPositionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FinancialPositionCubit>(),
      child: const _FinancialPositionView(),
    );
  }
}

class _FinancialPositionView extends StatelessWidget {
  const _FinancialPositionView();

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return BlocBuilder<FinancialPositionCubit, FinancialPositionState>(
      builder: (context, state) {
        final position = state.position;
        return ListView(
          padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
          children: [
            LedgerSeg<FinancialPositionPreset>(
              options: [
                for (final p in FinancialPositionPreset.values)
                  LedgerSegOption(p, p.label.tr()),
              ],
              selected: state.preset,
              onChanged: (p) =>
                  context.read<FinancialPositionCubit>().setPreset(p),
            ),
            SizedBox(
              height: 2.lx,
              child: state.isLoading && position != null
                  ? LinearProgressIndicator(
                      minHeight: 2.lx,
                      color: t.brandFill,
                      backgroundColor: Colors.transparent,
                    )
                  : null,
            ),
            SizedBox(height: 12.lx),
            if (position == null)
              _EmptyOrError(state: state)
            else
              _PositionBody(position: position, preset: state.preset),
          ],
        );
      },
    );
  }
}

class _EmptyOrError extends StatelessWidget {
  final FinancialPositionState state;
  const _EmptyOrError({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.lx),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final message = state.failure.hasError
        ? state.failure.customMessage
        : LocaleKeys.fpEmpty.tr();
    return LedgerCard(
      child: Text(
        message,
        style: TextStyle(fontSize: 13.lx, color: context.tones.textMuted),
      ),
    );
  }
}

class _PositionBody extends StatelessWidget {
  final FinancialPositionEntity position;
  final FinancialPositionPreset preset;

  const _PositionBody({required this.position, required this.preset});

  void _openHoldings(BuildContext context) {
    AppNavigator.push(
      context,
      BlocProvider(
        create: (_) => getIt<HoldingCubit>(),
        child: const HoldingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final currency = position.currency;
    final building = position.netWorthDelta >= 0;

    final moneyIn = <_LedgerRow>[
      _LedgerRow(LocaleKeys.fpEarnedIncome.tr(), position.earnedIncome, true,
          type: TransactionType.income, intent: TransactionIntent.regular),
      _LedgerRow(
          LocaleKeys.fpInvestmentReturns.tr(), position.investmentReturns, true,
          type: TransactionType.income,
          intent: TransactionIntent.investmentReturn),
      _LedgerRow(LocaleKeys.fpGiftsReceived.tr(), position.giftsReceived, true,
          type: TransactionType.income, intent: TransactionIntent.gift),
      _LedgerRow(LocaleKeys.fpLoanReceived.tr(), position.loanReceived, false,
          type: TransactionType.income, intent: TransactionIntent.loanReceived),
      _LedgerRow(LocaleKeys.fpDebtRepaidToYou.tr(), position.debtOwed, false,
          type: TransactionType.income, intent: TransactionIntent.debtOwed),
    ].where((r) => r.amount > 0).toList();

    final moneyOut = <_LedgerRow>[
      _LedgerRow(LocaleKeys.fpDiscretionarySpend.tr(),
          position.discretionarySpend, true,
          type: TransactionType.expense, intent: TransactionIntent.regular),
      _LedgerRow(
          LocaleKeys.fpInvested.tr(), position.investmentPrincipal, false,
          type: TransactionType.expense,
          intent: TransactionIntent.investmentBuy),
      _LedgerRow(LocaleKeys.fpLoanRepayment.tr(), position.loanRepayment, false,
          type: TransactionType.expense,
          intent: TransactionIntent.loanRepayment),
      _LedgerRow(LocaleKeys.fpDebtSettled.tr(), position.debtSettled, false,
          type: TransactionType.expense, intent: TransactionIntent.debtSettled),
    ].where((r) => r.amount > 0).toList();

    final totalIn = moneyIn.fold<double>(0, (sum, r) => sum + r.amount);
    final totalOut = moneyOut.fold<double>(0, (sum, r) => sum + r.amount);
    final accent = building ? t.incomeColor : t.expenseColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.fpNetWorthChange.tr(),
              style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
            ),
            SizedBox(width: 8.lx),
            LedgerChip(
              building
                  ? LocaleKeys.fpBuilding.tr()
                  : LocaleKeys.fpShrinking.tr(),
              icon:
                  building ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              tone: building ? LedgerChipTone.good : LedgerChipTone.bad,
            ),
          ],
        ),
        SizedBox(height: 4.lx),
        LedgerBigNumber(
          _money(position.netWorthDelta, currency, sign: true),
          color: accent,
        ),
        SizedBox(height: 12.lx),
        Row(
          children: [
            Expanded(
              child: LedgerTotalTile(
                label: LocaleKeys.fpMoneyIn.tr(),
                value: _money(totalIn, currency),
                color: t.incomeColor,
              ),
            ),
            SizedBox(width: 8.lx),
            Expanded(
              child: LedgerTotalTile(
                label: LocaleKeys.fpMoneyOut.tr(),
                value: _money(totalOut, currency),
                color: t.expenseColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.lx),
        LedgerCard(
          onTap: () => _openHoldings(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LedgerH6(
                LocaleKeys.fpTotalNetWorth.tr(),
                actionLabel: LocaleKeys.fpViewHoldings.tr(),
                onAction: () => _openHoldings(context),
              ),
              SizedBox(height: 4.lx),
              LedgerAmount(
                _money(position.totalNetWorth, currency),
                size: 24,
                weight: FontWeight.w600,
                color:
                    position.totalNetWorth < 0 ? t.expenseColor : t.textPrimary,
              ),
              SizedBox(height: 10.lx),
              Row(
                children: [
                  Expanded(
                    child: _Split(
                      label: LocaleKeys.fpCash.tr(),
                      value: _money(position.cashBalance, currency),
                    ),
                  ),
                  Expanded(
                    child: _Split(
                      label: LocaleKeys.fpHoldings.tr(),
                      value: _money(position.holdingsValue, currency),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (moneyIn.isNotEmpty) ...[
          SizedBox(height: 16.lx),
          _LedgerGroup(
            title: LocaleKeys.fpMoneyIn.tr(),
            rows: moneyIn,
            currency: currency,
            preset: preset,
          ),
        ],
        if (moneyOut.isNotEmpty) ...[
          SizedBox(height: 16.lx),
          _LedgerGroup(
            title: LocaleKeys.fpMoneyOut.tr(),
            rows: moneyOut,
            currency: currency,
            preset: preset,
          ),
        ],
        if (position.asOf != null) ...[
          SizedBox(height: 12.lx),
          Text(
            '${LocaleKeys.fpAsOf.tr()} ${DateFormat('dd MMM, HH:mm').format(position.asOf!.toLocal())}',
            style: TextStyle(fontSize: 11.lx, color: t.textMuted),
          ),
        ],
      ],
    );
  }
}

class _Split extends StatelessWidget {
  final String label;
  final String value;
  const _Split({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.lx, color: t.textMuted)),
        LedgerAmount(value, size: 13, color: t.textSecondary),
      ],
    );
  }
}

class _LedgerRow {
  final String label;
  final double amount;
  final bool countsTowardNetWorth;

  /// The transaction type + intent this bucket aggregates, used to drill into
  /// the underlying transactions. Mirrors `StatsService::getFinancialPosition`.
  final TransactionType type;
  final TransactionIntent intent;

  _LedgerRow(
    this.label,
    this.amount,
    this.countsTowardNetWorth, {
    required this.type,
    required this.intent,
  });
}

class _LedgerGroup extends StatelessWidget {
  final String title;
  final List<_LedgerRow> rows;
  final String? currency;
  final FinancialPositionPreset preset;

  const _LedgerGroup({
    required this.title,
    required this.rows,
    required this.currency,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LedgerH6(title),
        SizedBox(height: 6.lx),
        LedgerCard(
          padding: EdgeInsets.symmetric(horizontal: 12.lx),
          child: Column(
            children: [
              for (final r in rows)
                _LedgerTile(
                  row: r,
                  currency: currency,
                  preset: preset,
                  divider: r != rows.last,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LedgerTile extends StatelessWidget {
  final _LedgerRow row;
  final String? currency;
  final FinancialPositionPreset preset;
  final bool divider;

  const _LedgerTile({
    required this.row,
    required this.currency,
    required this.preset,
    required this.divider,
  });

  void _openDrill(BuildContext context) {
    final isIncome = row.type == TransactionType.income;
    final transactionCubit = context.read<TransactionCubit>();
    showDraggableBottomSheet(
      context,
      backgroundColor: context.tones.bgSurface,
      builder: (context, controller) => BlocProvider.value(
        value: transactionCubit,
        child: FinancialPositionDrillBottomSheet(
          controller: controller,
          label: row.label,
          eyebrow:
              (isIncome ? LocaleKeys.fpMoneyIn : LocaleKeys.fpMoneyOut).tr(),
          totalLabel: _money(row.amount, currency),
          type: row.type,
          intent: row.intent,
          preset: preset,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final income = row.type == TransactionType.income;
    final counts = row.countsTowardNetWorth;
    return LedgerRow(
      title: row.label,
      subtitle: counts ? null : LocaleKeys.fpCashNotNetWorth.tr(),
      divider: divider,
      onTap: () => _openDrill(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LedgerAmount(
            _money(income ? row.amount : -row.amount, currency, sign: income),
            color: counts
                ? (income ? t.incomeColor : t.expenseColor)
                : t.textSecondary,
          ),
          SizedBox(width: 4.lx),
          Icon(LucideIcons.chevronRight, size: 15.lx, color: t.textMuted),
        ],
      ),
    );
  }
}
