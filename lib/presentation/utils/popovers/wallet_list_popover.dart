import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_popover.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<WalletEntity> onSelect;
  final bool showCurrency;

  const WalletListPopover({
    super.key,
    required this.label,
    required this.onSelect,
    this.showCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: tones.expense.accent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return LedgerPopoverMenu(
          title: label,
          emptyText: LocaleKeys.noWalletsYet.tr(),
          items: [
            for (final wallet in state.wallets)
              LedgerPopoverItem(
                label: wallet.name,
                subtitle: showCurrency ? wallet.currencyCode : null,
                leading: LedgerCoin(
                  icon: LucideIcons.wallet,
                  media: wallet.icon,
                  size: 26,
                ),
                onTap: () {
                  onSelect(wallet);
                  AppNavigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
