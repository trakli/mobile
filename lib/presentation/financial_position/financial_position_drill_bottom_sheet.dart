import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Lists the transactions behind a single Financial Position ledger row
/// (e.g. "Discretionary spend"), mirroring the web drill-down drawer. Reads the
/// live local transaction list and reproduces the server's bucketing: same
/// [preset] period, matching [type] + [intent], transfers excluded.
///
/// Shown inside a draggable bottom sheet; [controller] is that sheet's drag
/// controller, driving the transaction list so the sheet can be extended.
class FinancialPositionDrillBottomSheet extends StatelessWidget {
  final String label;
  final String eyebrow;
  final String totalLabel;
  final TransactionType type;
  final TransactionIntent intent;
  final FinancialPositionPreset preset;
  final ScrollController controller;

  const FinancialPositionDrillBottomSheet({
    super.key,
    required this.label,
    required this.eyebrow,
    required this.totalLabel,
    required this.type,
    required this.intent,
    required this.preset,
    required this.controller,
  });

  List<TransactionCompleteEntity> _matching(
    List<TransactionCompleteEntity> all,
  ) {
    final (start, end) = preset.dateRange(DateTime.now());
    return all.where((t) {
      final tx = t.transaction;
      final isTransfer =
          tx.transferClientId != null && tx.transferClientId!.isNotEmpty;
      if (isTransfer) return false;
      if (tx.type != type || tx.intent != intent) return false;
      final at = tx.datetime;
      return !at.isBefore(start) && !at.isAfter(end);
    }).toList()
      ..sort(
        (a, b) => b.transaction.datetime.compareTo(a.transaction.datetime),
      );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final accent =
        type == TransactionType.income ? t.incomeColor : t.expenseColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8.lx),
        const LedgerSheetHandle(),
        Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 8.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LedgerH6(eyebrow),
              SizedBox(height: 4.lx),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.lx,
                        fontWeight: FontWeight.w700,
                        color: t.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.lx),
                  LedgerAmount(
                    totalLabel,
                    size: 16,
                    weight: FontWeight.w600,
                    color: accent,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final rows = _matching(state.transactions);
              return ListView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 24.lx),
                children: [
                  if (rows.isEmpty)
                    LedgerCard(
                      child: Text(
                        LocaleKeys.fpDrillEmpty.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                      ),
                    )
                  else ...[
                    Text(
                      LocaleKeys.statsEntries.plural(rows.length),
                      style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                    ),
                    SizedBox(height: 6.lx),
                    LedgerCard(
                      padding: EdgeInsets.symmetric(horizontal: 12.lx),
                      child: Column(
                        children: [
                          for (final r in rows)
                            LedgerTransactionRow(
                              transaction: r,
                              subtitle: DateFormat.yMMMd(
                                Localizations.localeOf(context).toString(),
                              ).format(r.transaction.datetime),
                              divider: r != rows.last,
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
