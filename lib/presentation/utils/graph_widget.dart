import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/presentation/statistics/overview/overview_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Income and expense bars per day.
class GraphWidget extends StatelessWidget {
  final List<StatsDay> chartData;

  const GraphWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final style = LedgerChartStyle.of(context);
    final locale = Localizations.localeOf(context).toString();
    return SizedBox(
      height: 180.lx,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: style.dateAxis(
          intervalType: DateTimeIntervalType.days,
          format: DateFormat.MMMd(locale),
        ),
        primaryYAxis: style.valueAxis(),
        tooltipBehavior: style.tooltip(),
        series: <CartesianSeries<StatsDay, DateTime>>[
          ColumnSeries<StatsDay, DateTime>(
            name: LocaleKeys.statsFlowIn.tr(),
            animationDuration: 350,
            dataSource: chartData,
            xValueMapper: (d, _) => d.day,
            yValueMapper: (d, _) => d.income,
            color: tones.incomeColor,
            width: 0.7,
            spacing: 0.1,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(1.5)),
          ),
          ColumnSeries<StatsDay, DateTime>(
            name: LocaleKeys.statsFlowOut.tr(),
            animationDuration: 350,
            dataSource: chartData,
            xValueMapper: (d, _) => d.day,
            yValueMapper: (d, _) => d.expense,
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

class ChartStatistics {
  ChartStatistics(
    this.date,
    this.income,
    this.expense,
  );

  final String date;
  final double income;
  final double expense;
}
