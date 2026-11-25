import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Savings rate and expense ratio, each as a bar with a target marker.
class FinancialRatios extends StatelessWidget {
  final ReportTotals totals;

  const FinancialRatios({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final savings = totals.savingsRate * 100;
    final expense = totals.expenseRatio * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RatioBar(
          label: LocaleKeys.statsSavingsRate.tr(),
          percent: savings,
          color: savings >= 20 ? tones.incomeColor : tones.accentWarm,
          target: 20,
          note: LocaleKeys.statsSavingsGoal.tr(),
        ),
        SizedBox(height: 14.lx),
        _RatioBar(
          label: LocaleKeys.statsExpenseRatio.tr(),
          percent: expense,
          color: expense <= 80 ? tones.incomeColor : tones.expenseColor,
          target: 80,
          note: LocaleKeys.statsExpenseGoal.tr(),
        ),
      ],
    );
  }
}

class _RatioBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  final double target;
  final String note;

  const _RatioBar({
    required this.label,
    required this.percent,
    required this.color,
    required this.target,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13.lx, color: tones.textPrimary),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: LedgerText.money(
                size: 13.lx,
                weight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.lx),
        LayoutBuilder(
          builder: (context, box) => Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: box.maxWidth,
                child: LedgerBar(value: percent / 100, height: 6, color: color),
              ),
              Positioned(
                left: box.maxWidth * target / 100 - 1,
                top: -3.lx,
                child: Container(
                  width: 2,
                  height: 12.lx,
                  color: tones.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.lx),
        Text(
          note,
          style: TextStyle(fontSize: 11.lx, color: tones.textMuted),
        ),
      ],
    );
  }
}
