import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Categories ranked by amount, each with its share and a bar scaled to the
/// largest one.
class CategoryRanking extends StatelessWidget {
  final List<CategoryAggregate> categories;
  final Color color;
  final int maxRows;

  const CategoryRanking({
    super.key,
    required this.categories,
    required this.color,
    this.maxRows = 8,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final scope = categories.take(maxRows).toList();
    final maxAmount =
        scope.fold<double>(0, (m, c) => c.amount > m ? c.amount : m);

    if (scope.isEmpty) {
      return Text(
        LocaleKeys.statsNoCategories.tr(),
        style: TextStyle(fontSize: 12.5.lx, color: tones.textMuted),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < scope.length; i++) ...[
          if (i > 0) SizedBox(height: 10.lx),
          Row(
            children: [
              Expanded(
                child: Text(
                  scope[i].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.lx,
                    fontWeight: FontWeight.w500,
                    color: tones.textPrimary,
                  ),
                ),
              ),
              Text(
                '${scope[i].percentage.toStringAsFixed(0)}%',
                style: LedgerText.money(size: 11.lx, color: tones.textMuted),
              ),
              SizedBox(width: 10.lx),
              LedgerAmount(
                CurrencyFormater.formatAmountWithSymbol(
                  context,
                  scope[i].amount,
                ),
                size: 12.5,
                weight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 5.lx),
          LedgerBar(
            value: maxAmount > 0 ? scope[i].amount / maxAmount : 0,
            height: 5,
            color: color,
          ),
        ],
      ],
    );
  }
}
