import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/cubit/report_stats_cubit.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_screen.dart';
import 'package:trakli/presentation/statistics/reports/charts/cashflow_chart.dart';
import 'package:trakli/presentation/statistics/reports/charts/category_ranking.dart';
import 'package:trakli/presentation/statistics/reports/charts/daily_bar_chart.dart';
import 'package:trakli/presentation/statistics/reports/charts/financial_ratios.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

/// Full reports surface: recap link, period totals, then cashflow,
/// category, daily and ratio cards.
///
/// Totals and category breakdowns come from server /stats when available
/// (matching web); daily-granularity charts and the recap are computed from
/// local transactions, exactly as the web's `useReportData` does. Local
/// numbers win while signed out, offline, or while transactions are still
/// waiting to sync.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PageAppBar(title: 'Reports'),
      body: ReportsView(),
    );
  }
}

/// The reports body, shown on its own route and as the Charts tab of the
/// statistics screen.
class ReportsView extends StatefulWidget {
  final EdgeInsetsGeometry? padding;

  const ReportsView({super.key, this.padding});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int _periodDays = 90;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportStatsCubit(
        remote: getIt<StatsRemoteDataSource>(),
        authService: getIt<AuthService>(),
        db: getIt<AppDatabase>(),
        syncStream: getIt<SynchAppDatabase>().syncStateStream,
      )..load(_periodDays),
      child: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          return BlocBuilder<ReportStatsCubit, ReportStatsState>(
            builder: (context, statsState) {
              final tones = context.tones;
              final data = buildReportData(
                state.transactions,
                periodDays: _periodDays,
              );
              final recap = buildMonthInReview(state.transactions);

              final server = statsState.stats;
              final totals = server == null
                  ? data.totals
                  : ReportTotals(
                      income: server.totalIncome,
                      expense: server.totalExpenses,
                      net: server.netCashFlow,
                      savingsRate: server.savingsRate,
                      expenseRatio: server.totalIncome > 0
                          ? server.totalExpenses / server.totalIncome
                          : 0,
                      daysInPeriod: _periodDays,
                    );
              final expenseCategories = server == null
                  ? data.expenseCategories
                  : [
                      for (final c in server.expenseCategories)
                        CategoryAggregate(
                          name: c.name,
                          amount: c.amount,
                          percentage: c.percentage,
                        ),
                    ];
              String money(double v) =>
                  CurrencyFormater.formatAmountWithSymbol(context, v);

              return SingleChildScrollView(
                padding: widget.padding ??
                    EdgeInsets.symmetric(horizontal: 14.lx, vertical: 14.lx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (recap != null) ...[
                      LedgerCard(
                        padding: EdgeInsets.zero,
                        onTap: () => MonthInReviewScreen.show(context, recap),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.lx),
                          child: LedgerRow(
                            leading: LedgerCoin(
                              icon: LucideIcons.sparkles,
                              background: tones.accentWarmSoft,
                              foreground: tones.accentWarm,
                            ),
                            title: LocaleKeys.statsMonthInReview.tr(),
                            subtitle: recap.monthLabel,
                            trailing: Icon(
                              LucideIcons.chevronRight,
                              size: 16.lx,
                              color: tones.textMuted,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.lx),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LedgerSeg<int>(
                        options: const [
                          LedgerSegOption(30, '30D'),
                          LedgerSegOption(90, '90D'),
                          LedgerSegOption(180, '6M'),
                          LedgerSegOption(365, '12M'),
                        ],
                        selected: _periodDays,
                        onChanged: (v) {
                          setState(() => _periodDays = v);
                          context.read<ReportStatsCubit>().load(v);
                        },
                      ),
                    ),
                    SizedBox(height: 10.lx),
                    _StatsSourceNote(statsState: statsState),
                    Row(
                      children: [
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowIn.tr(),
                            value: money(totals.income),
                            color: tones.incomeColor,
                          ),
                        ),
                        SizedBox(width: 6.lx),
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowOut.tr(),
                            value: money(totals.expense),
                            color: tones.expenseColor,
                          ),
                        ),
                        SizedBox(width: 6.lx),
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowKept.tr(),
                            value: money(totals.net),
                            color: totals.net >= 0
                                ? tones.incomeColor
                                : tones.expenseColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.lx),
                    _Section(
                      title: LocaleKeys.statsCashflow.tr(),
                      legend: true,
                      child: CashflowChart(daily: data.daily),
                    ),
                    SizedBox(height: 12.lx),
                    _Section(
                      title: LocaleKeys.statsWhereItWent.tr(),
                      child: CategoryRanking(
                        categories: expenseCategories,
                        color: tones.expenseColor,
                      ),
                    ),
                    SizedBox(height: 12.lx),
                    _Section(
                      title: LocaleKeys.daily.tr(),
                      legend: true,
                      child: DailyBarChart(daily: data.daily),
                    ),
                    SizedBox(height: 12.lx),
                    _Section(
                      title: LocaleKeys.statsRatios.tr(),
                      child: FinancialRatios(totals: totals),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// One-line note under the period control when the numbers aren't plain
/// server truth: local estimate (signed in but no server stats yet) or
/// partial conversion. Signed-out users see nothing: local is their truth.
class _StatsSourceNote extends StatelessWidget {
  final ReportStatsState statsState;

  const _StatsSourceNote({required this.statsState});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final server = statsState.stats;

    String? note;
    if (server != null && server.partial) {
      note = LocaleKeys.statsExcludesCurrencies
          .tr(args: [server.unconvertedCurrencies.join(', ')]);
    } else if (server == null && !statsState.isLocalOnly) {
      note = statsState.deferredForPendingSync
          ? LocaleKeys.statsLocalEstimatePending.tr()
          : LocaleKeys.statsLocalEstimate.tr();
    }
    if (note == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.lx),
      child: Row(
        children: [
          Icon(LucideIcons.info, size: 13.lx, color: tones.textMuted),
          SizedBox(width: 6.lx),
          Expanded(
            child: Text(
              note,
              style: TextStyle(fontSize: 11.lx, color: tones.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final bool legend;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
    this.legend = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LedgerH6(
            title,
            trailing: legend
                ? LedgerChartLegend(items: [
                    (LocaleKeys.statsFlowIn.tr(), tones.incomeColor),
                    (LocaleKeys.statsFlowOut.tr(), tones.expenseColor),
                  ])
                : null,
          ),
          SizedBox(height: 12.lx),
          child,
        ],
      ),
    );
  }
}
