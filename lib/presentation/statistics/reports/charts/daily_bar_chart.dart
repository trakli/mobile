import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Income and expense per day over the last [trailingDays] days.
class DailyBarChart extends StatelessWidget {
  final List<DailyBucket> daily;
  final int trailingDays;

  const DailyBarChart({
    super.key,
    required this.daily,
    this.trailingDays = 30,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final style = LedgerChartStyle.of(context);
    final locale = Localizations.localeOf(context).toString();
    final scope = daily.length > trailingDays
        ? daily.sublist(daily.length - trailingDays)
        : daily;

    return SizedBox(
      height: 170.lx,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: style.dateAxis(
          intervalType: DateTimeIntervalType.days,
          interval: 7,
          format: DateFormat.MMMd(locale),
        ),
        primaryYAxis: style.valueAxis(),
        tooltipBehavior: style.tooltip(),
        series: <CartesianSeries<DailyBucket, DateTime>>[
          ColumnSeries<DailyBucket, DateTime>(
            name: LocaleKeys.statsFlowIn.tr(),
            animationDuration: 350,
            dataSource: scope,
            xValueMapper: (b, _) => b.date,
            yValueMapper: (b, _) => b.income,
            color: tones.incomeColor,
            width: 0.7,
            spacing: 0.1,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(1.5)),
          ),
          ColumnSeries<DailyBucket, DateTime>(
            name: LocaleKeys.statsFlowOut.tr(),
            animationDuration: 350,
            dataSource: scope,
            xValueMapper: (b, _) => b.date,
            yValueMapper: (b, _) => b.expense,
            color: tones.expenseColor,
            width: 0.7,
            spacing: 0.1,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(1.5)),
          ),
        ],
      ),
    );
  }
}
