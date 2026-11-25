import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/locale_keys.g.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/transfer_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class TransfersScreen extends StatelessWidget {
  const TransfersScreen({super.key});

  WalletEntity? _findWallet({
    required List<WalletEntity> wallets,
    int? id,
    String? clientId,
  }) {
    if (id != null) {
      final byId = wallets.firstWhereOrNull((w) => w.id == id);
      if (byId != null) return byId;
    }

    if (clientId == null) return null;
    return wallets.firstWhereOrNull((w) => w.clientId == clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(title: LocaleKeys.transfers.tr()),
      body: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          if (state.transfers.isEmpty) {
            return LedgerEmptyState(
              loading: state.isLoading,
              icon: LucideIcons.arrowLeftRight,
              title: LocaleKeys.noTransfersFound.tr(),
            );
          }
          final transfers = List<TransferEntity>.from(state.transfers)
            ..sort((a, b) => b.datetime.compareTo(a.datetime));
          return BlocBuilder<WalletCubit, WalletState>(
            builder: (context, walletState) {
              return ListView(
                padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                children: [
                  LedgerCard(
                    padding: EdgeInsets.symmetric(horizontal: 12.lx),
                    child: Column(
                      children: [
                        for (final transfer in transfers)
                          Builder(builder: (context) {
                            final from = _findWallet(
                              wallets: walletState.wallets,
                              id: transfer.fromWalletId,
                              clientId: transfer.fromWalletClientId,
                            );
                            final to = _findWallet(
                              wallets: walletState.wallets,
                              id: transfer.toWalletId,
                              clientId: transfer.toWalletClientId,
                            );
                            return TransferTile(
                              transfer: transfer,
                              fromWalletName: from?.name,
                              toWalletName: to?.name,
                              fromWalletCurrency: from?.currencyCode,
                              toWalletCurrency: to?.currencyCode,
                              divider: transfer != transfers.last,
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
