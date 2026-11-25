import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Axis numbers without a currency: 950, 1.2k, 15k, 2.4M.
String ledgerCompactNumber(num v) {
  final a = v.abs();
  final sign = v < 0 ? '−' : '';
  String trim(double x) {
    final s = x.toStringAsFixed(x < 10 ? 1 : 0);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  if (a >= 1e6) return '$sign${trim(a / 1e6)}M';
  if (a >= 1e3) return '$sign${trim(a / 1e3)}k';
  return '$sign${a.round()}';
}

/// Shared look for Syncfusion charts: mono axis labels, no ticks or axis
/// lines, a faint horizontal grid, and a surface-coloured tooltip.
class LedgerChartStyle {
  final AppTones tones;

  const LedgerChartStyle(this.tones);

  factory LedgerChartStyle.of(BuildContext context) =>
      LedgerChartStyle(context.tones);

  TextStyle get label => LedgerText.money(
        size: 9.5.lx,
        weight: FontWeight.w400,
        color: tones.textMuted,
      );

  MajorGridLines get grid =>
      MajorGridLines(width: 0.6, color: tones.borderLight);

  CategoryAxis categoryAxis({double labelRotation = 0}) => CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: label,
        labelRotation: labelRotation.toInt(),
        labelIntersectAction: AxisLabelIntersectAction.hide,
      );

  DateTimeAxis dateAxis({
    DateTimeIntervalType intervalType = DateTimeIntervalType.auto,
    double? interval,
    DateFormat? format,
  }) =>
      DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: label,
        intervalType: intervalType,
        interval: interval,
        dateFormat: format,
      );

  NumericAxis valueAxis() => NumericAxis(
        majorGridLines: grid,
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: label,
        maximumLabels: 3,
        axisLabelFormatter: (d) =>
            ChartAxisLabel(ledgerCompactNumber(d.value), d.textStyle),
      );

  TooltipBehavior tooltip({String? format}) => TooltipBehavior(
        enable: true,
        color: tones.bgSurface,
        borderColor: tones.borderLight,
        borderWidth: 1,
        elevation: 0,
        format: format,
        textStyle: LedgerText.money(
          size: 11.lx,
          color: tones.textPrimary,
        ),
      );
}

/// Dot-and-label legend drawn outside the chart so it matches the rest of
/// the Ledger type.
class LedgerChartLegend extends StatelessWidget {
  final List<(String, Color)> items;

  const LedgerChartLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Wrap(
      spacing: 12.lx,
      runSpacing: 4.lx,
      children: [
        for (final (label, color) in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.lx,
                height: 8.lx,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 5.lx),
              Text(
                label,
                style: TextStyle(fontSize: 11.lx, color: t.textSecondary),
              ),
            ],
          ),
      ],
    );
  }
}
