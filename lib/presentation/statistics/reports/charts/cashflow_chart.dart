import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Income vs expense over time. Daily buckets are summed into weekly points
/// so the curve stays readable at phone width.
class CashflowChart extends StatelessWidget {
  final List<DailyBucket> daily;

  const CashflowChart({super.key, required this.daily});

  List<_Point> _aggregateWeekly() {
    if (daily.isEmpty) return const [];
    final out = <_Point>[];
    final start = daily.first.date;
    final end = daily.last.date;
    DateTime cursor = start;
    while (!cursor.isAfter(end)) {
      final weekEnd = cursor.add(const Duration(days: 6));
      double income = 0;
      double expense = 0;
      for (final d in daily) {
        if (!d.date.isBefore(cursor) && !d.date.isAfter(weekEnd)) {
          income += d.income;
          expense += d.expense;
        }
      }
      out.add(_Point(week: cursor, income: income, expense: expense));
      cursor = cursor.add(const Duration(days: 7));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final style = LedgerChartStyle.of(context);
    final points = _aggregateWeekly();
    final locale = Localizations.localeOf(context).toString();

    return SizedBox(
      height: 190.lx,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: style.dateAxis(format: DateFormat.MMMd(locale)),
        primaryYAxis: style.valueAxis(),
        tooltipBehavior: style.tooltip(),
        series: <CartesianSeries<_Point, DateTime>>[
          SplineAreaSeries<_Point, DateTime>(
            name: LocaleKeys.statsFlowIn.tr(),
            animationDuration: 350,
            dataSource: points,
            xValueMapper: (p, _) => p.week,
            yValueMapper: (p, _) => p.income,
            color: tones.incomeColor.withValues(alpha: 0.10),
            borderColor: tones.incomeColor,
            borderWidth: 1.6,
            splineType: SplineType.monotonic,
          ),
          SplineAreaSeries<_Point, DateTime>(
            name: LocaleKeys.statsFlowOut.tr(),
            animationDuration: 350,
            dataSource: points,
            xValueMapper: (p, _) => p.week,
            yValueMapper: (p, _) => p.expense,
            color: tones.expenseColor.withValues(alpha: 0.10),
            borderColor: tones.expenseColor,
            borderWidth: 1.6,
            splineType: SplineType.monotonic,
          ),
        ],
      ),
    );
  }
}

class _Point {
  final DateTime week;
  final double income;
  final double expense;
  _Point({required this.week, required this.income, required this.expense});
}
