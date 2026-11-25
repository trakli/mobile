import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_chart.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class LedgerMonthBucket {
  final DateTime month;
  double income = 0;
  double expense = 0;
  LedgerMonthBucket(this.month);
}

/// Income and expense per calendar month for the last [months] months,
/// oldest first. [convert] turns a transaction into the display currency.
List<LedgerMonthBucket> ledgerMonthlyBuckets(
  Iterable<TransactionCompleteEntity> txns,
  double Function(TransactionCompleteEntity) convert, {
  int months = 6,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final buckets = <DateTime, LedgerMonthBucket>{
    for (var i = months - 1; i >= 0; i--)
      DateTime(today.year, today.month - i): LedgerMonthBucket(
        DateTime(today.year, today.month - i),
      ),
  };
  for (final t in txns) {
    if (t.transaction.isTransferLeg) continue;
    final d = t.transaction.datetime;
    final b = buckets[DateTime(d.year, d.month)];
    if (b == null) continue;
    if (t.transaction.type == TransactionType.income) {
      b.income += convert(t);
    } else {
      b.expense += convert(t);
    }
  }
  return buckets.values.toList();
}

/// Six month In and Out column chart in a card. A series with no values
/// is left out, so single-direction pages (a category) show one colour.
class LedgerMonthlyCard extends StatelessWidget {
  final List<LedgerMonthBucket> buckets;

  const LedgerMonthlyCard({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final style = LedgerChartStyle.of(context);
    final locale = Localizations.localeOf(context).toString();
    final hasIn = buckets.any((b) => b.income > 0);
    final hasOut = buckets.any((b) => b.expense > 0);

    ColumnSeries<LedgerMonthBucket, String> series(
      String name,
      Color color,
      double Function(LedgerMonthBucket) y,
    ) =>
        ColumnSeries<LedgerMonthBucket, String>(
          name: name,
          animationDuration: 350,
          dataSource: buckets,
          xValueMapper: (b, _) => DateFormat.MMM(locale).format(b.month),
          yValueMapper: (b, _) => y(b),
          color: color,
          width: 0.6,
          spacing: 0.15,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(1.5)),
        );

    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LedgerH6(LocaleKeys.detailLast6Months.tr()),
          SizedBox(height: 8.lx),
          if (!hasIn && !hasOut)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.lx),
              child: Text(
                LocaleKeys.detailNoActivity.tr(),
                style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
              ),
            )
          else ...[
            SizedBox(
              height: 140.lx,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: style.categoryAxis(),
                primaryYAxis: style.valueAxis(),
                tooltipBehavior: style.tooltip(),
                series: [
                  if (hasIn)
                    series(
                      LocaleKeys.statsFlowIn.tr(),
                      t.incomeColor,
                      (b) => b.income,
                    ),
                  if (hasOut)
                    series(
                      LocaleKeys.statsFlowOut.tr(),
                      t.expenseColor,
                      (b) => b.expense,
                    ),
                ],
              ),
            ),
            if (hasIn && hasOut) ...[
              SizedBox(height: 8.lx),
              LedgerChartLegend(
                items: [
                  (LocaleKeys.statsFlowIn.tr(), t.incomeColor),
                  (LocaleKeys.statsFlowOut.tr(), t.expenseColor),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Most recent [limit] transactions as Ledger rows with their date.
class LedgerRecentCard extends StatelessWidget {
  final List<TransactionCompleteEntity> transactions;
  final int limit;
  final String? emptyText;
  final bool showWallet;

  const LedgerRecentCard({
    super.key,
    required this.transactions,
    this.limit = 10,
    this.emptyText,
    this.showWallet = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final sorted = [...transactions]..sort(
        (a, b) => b.transaction.datetime.compareTo(a.transaction.datetime),
      );
    final shown = sorted.take(limit).toList();
    final date = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LedgerH6(
          LocaleKeys.partyRecentTransactions.tr(),
          trailing: shown.isEmpty
              ? null
              : Text(
                  LocaleKeys.partyShownCount
                      .tr(namedArgs: {'count': '${shown.length}'}),
                  style: TextStyle(fontSize: 11.lx, color: t.textMuted),
                ),
        ),
        SizedBox(height: 6.lx),
        LedgerCard(
          padding: EdgeInsets.symmetric(horizontal: 12.lx),
          child: shown.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.lx),
                  child: Text(
                    emptyText ?? LocaleKeys.detailNoTransactions.tr(),
                    style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                  ),
                )
              : Column(
                  children: [
                    for (final tx in shown)
                      LedgerTransactionRow(
                        transaction: tx,
                        subtitle: showWallet
                            ? '${date.format(tx.transaction.datetime)} · ${tx.wallet.name}'
                            : date.format(tx.transaction.datetime),
                        divider: tx != shown.last,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Coin, eyebrow line and big figure that open a detail page.
class LedgerDetailHero extends StatelessWidget {
  final Widget coin;
  final String eyebrow;
  final String figure;
  final Color? figureColor;
  final Widget? trailing;

  const LedgerDetailHero({
    super.key,
    required this.coin,
    required this.eyebrow,
    required this.figure,
    this.figureColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  coin,
                  SizedBox(width: 8.lx),
                  Flexible(
                    child: Text(
                      eyebrow,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5.lx,
                        color: context.tones.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.lx),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: LedgerBigNumber(figure, color: figureColor),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
