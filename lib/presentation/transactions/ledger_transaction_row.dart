import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/transaction_details_bottom_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Opens the transaction details sheet with edit and delete, as the
/// transaction tiles elsewhere in the app do.
void openTransactionDetails(
  BuildContext context,
  TransactionCompleteEntity transaction,
) {
  final tones = context.tones;
  final accent = transaction.transaction.type == TransactionType.income
      ? tones.incomeColor
      : tones.expenseColor;
  final cubit = context.read<TransactionCubit>();
  showCustomBottomSheet(
    context,
    color: Theme.of(context).scaffoldBackgroundColor,
    widget: BlocProvider.value(
      value: cubit,
      child: TransactionDetailsBottomSheet(
        transaction: transaction,
        accentColor: accent,
        onEdit: () => AppNavigator.push(
          context,
          AddTransactionScreen(
            transaction: transaction,
            transactionType: transaction.transaction.type,
            accentColor: accent,
          ),
        ),
        onDelete: () async {
          final ok = await showDeleteConfirmationDialog(
            context,
            title: LocaleKeys.deleteTransaction.tr(),
            message: LocaleKeys.deleteTransactionConfirmation.tr(),
          );
          if (ok) cubit.deleteTransaction(transaction.transaction.clientId);
        },
        hideActions: transaction.transaction.transferClientId != null &&
            transaction.transaction.transferClientId!.isNotEmpty,
      ),
    ),
  );
}

/// Signed amount in the wallet currency: income gets a plus and the income
/// color, spending a minus.
String ledgerSignedAmount(TransactionCompleteEntity t) {
  final income = t.transaction.type == TransactionType.income;
  final v = income ? t.transaction.amount : -t.transaction.amount;
  return LedgerMoney.format(v, t.wallet.currencyCode, sign: income);
}

class LedgerTransactionRow extends StatelessWidget {
  final TransactionCompleteEntity transaction;
  final String? subtitle;
  final bool divider;
  final double verticalPadding;
  final bool showCoin;

  const LedgerTransactionRow({
    super.key,
    required this.transaction,
    this.subtitle,
    this.divider = true,
    this.verticalPadding = 9,
    this.showCoin = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final tx = transaction.transaction;
    final income = tx.type == TransactionType.income;
    final category =
        transaction.categories.isEmpty ? null : transaction.categories.first;
    final title = tx.description.trim().isNotEmpty
        ? tx.description.trim()
        : (category?.name ??
            transaction.party?.name ??
            LocaleKeys.noDescription.tr());
    return LedgerRow(
      leading: showCoin
          ? LedgerCoin(
              media: category?.icon,
              icon: tx.isTransferLeg
                  ? LucideIcons.arrowLeftRight
                  : (category == null
                      ? (income
                          ? LucideIcons.arrowDownLeft
                          : LucideIcons.arrowUpRight)
                      : null),
            )
          : null,
      title: title,
      subtitle: subtitle ?? transaction.wallet.name,
      divider: divider,
      verticalPadding: verticalPadding,
      onTap: () => openTransactionDetails(context, transaction),
      trailing: LedgerAmount(
        ledgerSignedAmount(transaction),
        color: tx.isTransferLeg
            ? t.textPrimary
            : (income ? t.incomeColor : t.expenseColor),
      ),
    );
  }
}
