import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showCustomDialog;
import 'package:trakli/presentation/utils/ledger/ledger_detail.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletDetailScreen extends StatelessWidget {
  final WalletEntity wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final live = context.select<WalletCubit, WalletEntity>(
      (c) =>
          c.state.wallets
              .firstWhereOrNull((w) => w.clientId == wallet.clientId) ??
          wallet,
    );
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final mine = state.transactions
            .where((tx) => tx.transaction.walletClientId == wallet.clientId)
            .toList();
        double income = 0;
        double expense = 0;
        for (final tx in mine) {
          if (tx.transaction.isTransferLeg) continue;
          if (tx.transaction.type == TransactionType.income) {
            income += tx.transaction.amount;
          } else {
            expense += tx.transaction.amount;
          }
        }
        final code = live.currencyCode;
        final monthly =
            ledgerMonthlyBuckets(mine, (tx) => tx.transaction.amount);

        return Scaffold(
          backgroundColor: t.bgPage,
          appBar: PageAppBar(
            title: live.name,
            eyebrow: LocaleKeys.wallets.tr(),
            actions: [
              PageAppBarAction(
                icon: LucideIcons.pencil,
                onTap: () =>
                    AppNavigator.push(context, AddWalletScreen(wallet: live)),
              ),
              PageAppBarAction(
                icon: LucideIcons.trash2,
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
            children: [
              LedgerDetailHero(
                coin: LedgerCoin(
                  media: live.icon,
                  icon: LucideIcons.wallet,
                  size: 24,
                ),
                eyebrow: '${LocaleKeys.balance.tr()} · $code',
                figure: LedgerMoney.format(live.balance, code),
                figureColor: live.balance < 0 ? t.expenseColor : null,
              ),
              SizedBox(height: 12.lx),
              Row(
                children: [
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.statsFlowIn.tr(),
                      value: LedgerMoney.format(income, code),
                      color: t.incomeColor,
                    ),
                  ),
                  SizedBox(width: 6.lx),
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.statsFlowOut.tr(),
                      value: LedgerMoney.format(expense, code),
                      color: t.expenseColor,
                    ),
                  ),
                  SizedBox(width: 6.lx),
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.detailNetFlow.tr(),
                      value: LedgerMoney.format(
                        income - expense,
                        code,
                        sign: true,
                      ),
                      color:
                          income - expense < 0 ? t.expenseColor : t.incomeColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.lx),
              LedgerMonthlyCard(buckets: monthly),
              SizedBox(height: 16.lx),
              LedgerRecentCard(transactions: mine, showWallet: false),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteWallet.tr(),
        subTitle:
            LocaleKeys.deleteWalletConfirm.tr(namedArgs: {'name': wallet.name}),
        mainAction: () {
          context.read<WalletCubit>().deleteWallet(wallet.clientId);
          AppNavigator.pop(context);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }
}
