import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/statistics/calendar/calendar_tab.dart';
import 'package:trakli/presentation/statistics/cubit/statistics_filter_cubit.dart';
import 'package:trakli/presentation/statistics/flow/flow_tab.dart';
import 'package:trakli/presentation/statistics/overview/overview_data.dart';
import 'package:trakli/presentation/statistics/reports/reports_screen.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

enum StatisticsTab { overview, calendar, flow, charts }

class StatisticsScreen extends StatefulWidget {
  final StatisticsTab initialTab;

  const StatisticsScreen({
    super.key,
    this.initialTab = StatisticsTab.overview,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late StatisticsTab _tab = widget.initialTab;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  TransactionType _breakdown = TransactionType.expense;

  String _tabLabel(StatisticsTab tab) => switch (tab) {
        StatisticsTab.overview => LocaleKeys.statsTabOverview.tr(),
        StatisticsTab.calendar => LocaleKeys.statsTabCalendar.tr(),
        StatisticsTab.flow => LocaleKeys.statsTabFlow.tr(),
        StatisticsTab.charts => LocaleKeys.statsTabCharts.tr(),
      };

  Widget _monthChip(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final months = [
      for (var i = 0; i < 12; i++) DateTime(now.year, now.month - i),
    ];
    return PopupMenuButton<DateTime>(
      tooltip: '',
      initialValue: _month,
      onSelected: (m) => setState(() => _month = m),
      itemBuilder: (_) => [
        for (final m in months)
          PopupMenuItem(
            value: m,
            child: Text(DateFormat.yMMMM(locale).format(m)),
          ),
      ],
      child: LedgerChip(
        _month.year == now.year
            ? DateFormat.MMM(locale).format(_month)
            : DateFormat.yMMM(locale).format(_month),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final monthScoped =
        _tab == StatisticsTab.calendar || _tab == StatisticsTab.flow;
    return Scaffold(
      backgroundColor: tones.bgPage,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 0),
              child: LedgerScreenBar(
                title: LocaleKeys.statistics.tr(),
                actions: [if (monthScoped) _monthChip(context)],
              ),
            ),
            SizedBox(height: 12.lx),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.lx),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: LedgerSeg<StatisticsTab>(
                  options: [
                    for (final tab in StatisticsTab.values)
                      LedgerSegOption(tab, _tabLabel(tab)),
                  ],
                  selected: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
              ),
            ),
            SizedBox(height: 12.lx),
            Expanded(
              child: switch (_tab) {
                StatisticsTab.overview => _buildOverview(context),
                StatisticsTab.calendar => StatisticsCalendarTab(
                    month: _month,
                    onOpenWallet: () => context
                        .read<MainNavigationCubit>()
                        .updateIndex(MainNavigationPageState.wallet),
                  ),
                StatisticsTab.flow => StatisticsFlowTab(month: _month),
                StatisticsTab.charts => ReportsView(
                    padding: EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 120.lx),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionCompleteEntity> _filterTransactions(
    List<TransactionCompleteEntity> transactions, {
    String? walletClientId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var filtered = transactions;

    if (walletClientId != null) {
      filtered = filtered
          .where((tx) => tx.transaction.walletClientId == walletClientId)
          .toList();
    }

    if (startDate != null && endDate != null) {
      filtered = filtered.where((tx) {
        final date = tx.transaction.datetime;
        return !date.isBefore(startDate) && !date.isAfter(endDate);
      }).toList();
    }

    return filtered;
  }

  void _pickDateRange(BuildContext context) async {
    final filterCubit = context.read<StatisticsFilterCubit>();
    final filter = filterCubit.state;
    final tones = context.tones;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      barrierColor: tones.bgPage.withValues(alpha: 0.8),
      initialDateRange: filter.startDate != null && filter.endDate != null
          ? DateTimeRange(start: filter.startDate!, end: filter.endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: tones.brand.deep,
                  onPrimary: Colors.white,
                  surface: tones.bgSurface,
                  onSurface: tones.textPrimary,
                ),
            datePickerTheme: Theme.of(context).datePickerTheme.copyWith(
                  rangePickerBackgroundColor: tones.bgSurface,
                  rangeSelectionBackgroundColor:
                      tones.brand.deep.withValues(alpha: 0.1),
                  dividerColor: tones.borderLight,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      filterCubit.setDateRange(
        picked.start,
        DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        ),
      );
    }
  }

  void _pickWallet(BuildContext context, List<WalletEntity> wallets) {
    final filterCubit = context.read<StatisticsFilterCubit>();
    final selected = filterCubit.state.walletClientId;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.tones.bgSurface,
      isScrollControlled: true,
      builder: (sheetContext) {
        final tones = sheetContext.tones;
        Widget option(String? id, String name, String? sub) => LedgerRow(
              leading: LedgerCoin(
                icon: id == null ? LucideIcons.layers : LucideIcons.wallet,
              ),
              title: name,
              subtitle: sub,
              trailing: id == selected
                  ? Icon(LucideIcons.check, size: 16.lx, color: tones.brandText)
                  : null,
              onTap: () {
                filterCubit.setWallet(id);
                Navigator.pop(sheetContext);
              },
            );
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 14.lx),
              children: [
                const LedgerSheetHandle(),
                SizedBox(height: 10.lx),
                LedgerH6(LocaleKeys.pickWallet.tr()),
                SizedBox(height: 4.lx),
                option(null, LocaleKeys.allWallets.tr(), null),
                for (final w in wallets)
                  option(w.clientId, w.name, w.currencyCode),
              ],
            ),
          ),
        );
      },
    );
  }

  String _rangeLabel(BuildContext context, StatisticsFilterState f) {
    final locale = Localizations.localeOf(context).toString();
    if (f.startDate == null || f.endDate == null) {
      return LocaleKeys.statsAllTime.tr();
    }
    final sameYear = f.startDate!.year == f.endDate!.year &&
        f.endDate!.year == DateTime.now().year;
    final fmt = sameYear ? DateFormat.MMMd(locale) : DateFormat.yMMMd(locale);
    return '${fmt.format(f.startDate!)} – ${fmt.format(f.endDate!)}';
  }

  Widget _buildOverview(BuildContext context) {
    return BlocBuilder<StatisticsFilterCubit, StatisticsFilterState>(
      builder: (context, filterState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            final tones = context.tones;
            final wallets = context.watch<WalletCubit>().state.wallets;
            final stats = StatsMoney.of(context);
            final selectedWallet = filterState.walletClientId == null
                ? null
                : wallets.firstWhereOrNull(
                    (w) => w.clientId == filterState.walletClientId,
                  );
            final currency = selectedWallet?.currencyCode ?? stats.currency;
            double convert(TransactionCompleteEntity t) =>
                selectedWallet == null
                    ? stats.convert(t)
                    : t.transaction.amount;
            String money(double v, {bool sign = false}) =>
                LedgerMoney.format(v, currency, sign: sign);

            final transactions = _filterTransactions(
              state.transactions,
              walletClientId: filterState.walletClientId,
              startDate: filterState.startDate,
              endDate: filterState.endDate,
            ).where((t) => !t.transaction.isTransferLeg).toList();
            final overview = buildStatsOverview(transactions, convert);

            final rows = _breakdown == TransactionType.income
                ? overview.incomeCategories
                : overview.expenseCategories;
            final rowColor = _breakdown == TransactionType.income
                ? tones.incomeColor
                : tones.expenseColor;

            return ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 120.lx),
              children: [
                LedgerChipRow(
                  children: [
                    LedgerFilterChip(
                      icon: LucideIcons.wallet,
                      label: selectedWallet?.name ?? LocaleKeys.allWallets.tr(),
                      onTap: () => _pickWallet(context, wallets),
                    ),
                    LedgerFilterChip(
                      icon: LucideIcons.calendar,
                      label: _rangeLabel(context, filterState),
                      onTap: () => _pickDateRange(context),
                    ),
                  ],
                ),
                SizedBox(height: 14.lx),
                Text(
                  LocaleKeys.statsFlowKept.tr(),
                  style: TextStyle(fontSize: 12.5.lx, color: tones.textMuted),
                ),
                LedgerBigNumber(
                  money(overview.net, sign: true),
                  color: overview.net >= 0
                      ? tones.incomeColor
                      : tones.expenseColor,
                ),
                SizedBox(height: 10.lx),
                Row(
                  children: [
                    Expanded(
                      child: LedgerTotalTile(
                        label: LocaleKeys.statsFlowIn.tr(),
                        value: money(overview.income),
                        color: tones.incomeColor,
                      ),
                    ),
                    SizedBox(width: 6.lx),
                    Expanded(
                      child: LedgerTotalTile(
                        label: LocaleKeys.statsFlowOut.tr(),
                        value: money(overview.expense),
                        color: tones.expenseColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.lx),
                LedgerCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LedgerH6(
                        LocaleKeys.daily.tr(),
                        trailing: LedgerChartLegend(items: [
                          (LocaleKeys.statsFlowIn.tr(), tones.incomeColor),
                          (LocaleKeys.statsFlowOut.tr(), tones.expenseColor),
                        ]),
                      ),
                      SizedBox(height: 12.lx),
                      GraphWidget(chartData: overview.days),
                    ],
                  ),
                ),
                SizedBox(height: 12.lx),
                LedgerCard(
                  padding: EdgeInsets.fromLTRB(12.lx, 12.lx, 12.lx, 4.lx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: LedgerH6(LocaleKeys.categories.tr())),
                          LedgerSeg<TransactionType>(
                            options: [
                              LedgerSegOption(
                                TransactionType.expense,
                                LocaleKeys.statsFlowOut.tr(),
                              ),
                              LedgerSegOption(
                                TransactionType.income,
                                LocaleKeys.statsFlowIn.tr(),
                              ),
                            ],
                            selected: _breakdown,
                            onChanged: (v) => setState(() => _breakdown = v),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.lx),
                      if (rows.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.lx),
                          child: Text(
                            LocaleKeys.statsNoCategories.tr(),
                            style: TextStyle(
                              fontSize: 12.5.lx,
                              color: tones.textMuted,
                            ),
                          ),
                        ),
                      for (final c in rows)
                        LedgerRow(
                          leading: LedgerCoin(
                            media: c.category?.icon,
                            icon: LucideIcons.tag,
                          ),
                          title: c.category?.name ??
                              LocaleKeys.statsFlowUncategorized.tr(),
                          subtitle: LocaleKeys.statsEntries.plural(c.count),
                          trailing: LedgerAmount(
                            money(c.amount),
                            size: 13,
                            weight: FontWeight.w600,
                            color: rowColor,
                          ),
                          divider: c != rows.last,
                        ),
                    ],
                  ),
                ),
                if (overview.people.isNotEmpty) ...[
                  SizedBox(height: 12.lx),
                  LedgerCard(
                    padding: EdgeInsets.fromLTRB(12.lx, 12.lx, 12.lx, 4.lx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LedgerH6(LocaleKeys.parties.tr()),
                        SizedBox(height: 4.lx),
                        for (final p in overview.people.take(6))
                          LedgerRow(
                            leading: LedgerInitials(p.party.name, size: 32),
                            title: p.party.name,
                            subtitle: LocaleKeys.statsEntries.plural(p.count),
                            trailing: LedgerAmount(
                              money(p.net, sign: true),
                              size: 13,
                              weight: FontWeight.w600,
                              color: p.net >= 0
                                  ? tones.incomeColor
                                  : tones.expenseColor,
                            ),
                            divider: p != overview.people.take(6).last,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
