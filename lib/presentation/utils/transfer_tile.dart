import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/utils/exchange_rate_formatter.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class TransferTile extends StatelessWidget {
  final TransferEntity transfer;
  final String? fromWalletName;
  final String? toWalletName;
  final String? fromWalletCurrency;
  final String? toWalletCurrency;
  final VoidCallback? onTap;
  final bool divider;

  const TransferTile({
    super.key,
    required this.transfer,
    this.fromWalletName,
    this.toWalletName,
    this.fromWalletCurrency,
    this.toWalletCurrency,
    this.onTap,
    this.divider = true,
  });

  bool get _crossCurrency =>
      fromWalletCurrency != null &&
      toWalletCurrency != null &&
      fromWalletCurrency != toWalletCurrency;

  String _amount(double v, String? code) =>
      LedgerMoney.format(v, code ?? '').trim();

  void _showDetails(BuildContext context) {
    final rate = transfer.exchangeRate;
    final converted = _crossCurrency && rate != null && rate != 1.0;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.tones.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheet) {
        final t = sheet.tones;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 16.lx),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LedgerSheetHandle(),
                SizedBox(height: 14.lx),
                Text(
                  LocaleKeys.walletTransfer.tr(),
                  style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                ),
                LedgerBigNumber(
                  _amount(transfer.amount, fromWalletCurrency),
                  size: 30,
                ),
                Text(
                  DateFormat.yMMMd(Localizations.localeOf(sheet).toString())
                      .add_Hm()
                      .format(transfer.datetime),
                  style: LedgerText.money(size: 11.5.lx, color: t.textMuted),
                ),
                SizedBox(height: 14.lx),
                LedgerCard(
                  padding: EdgeInsets.symmetric(horizontal: 12.lx),
                  child: Column(
                    children: [
                      LedgerRow(
                        leading: const LedgerCoin(
                          icon: LucideIcons.arrowUpRight,
                        ),
                        title: fromWalletName ?? LocaleKeys.unknown.tr(),
                        subtitle: LocaleKeys.from.tr(),
                        trailing: LedgerAmount(
                          _amount(-transfer.amount, fromWalletCurrency),
                        ),
                      ),
                      LedgerRow(
                        leading: const LedgerCoin(
                          icon: LucideIcons.arrowDownLeft,
                        ),
                        title: toWalletName ?? LocaleKeys.unknown.tr(),
                        subtitle: LocaleKeys.to.tr(),
                        divider: false,
                        trailing: LedgerAmount(
                          '+${_amount(converted ? transfer.amount * rate : transfer.amount, converted ? toWalletCurrency : fromWalletCurrency)}',
                        ),
                      ),
                    ],
                  ),
                ),
                if (_crossCurrency) ...[
                  SizedBox(height: 10.lx),
                  LedgerNote(
                    icon: LucideIcons.arrowLeftRight,
                    text: '${LocaleKeys.exchangeRate.tr()}: '
                        '${rate != null ? formatExchangeRateForDisplay(rate) : '?'}',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final from = fromWalletName ?? LocaleKeys.unknown.tr();
    final to = toWalletName ?? LocaleKeys.unknown.tr();
    return LedgerRow(
      leading: const LedgerCoin(icon: LucideIcons.arrowLeftRight),
      title: '$from → $to',
      subtitle: DateFormat.yMMMd(Localizations.localeOf(context).toString())
          .format(transfer.datetime),
      divider: divider,
      onTap: () => _showDetails(context),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LedgerAmount(_amount(transfer.amount, fromWalletCurrency)),
          if (_crossCurrency)
            Text(
              '$fromWalletCurrency → $toWalletCurrency',
              style: LedgerText.money(size: 10.5.lx, color: t.textMuted),
            ),
        ],
      ),
    );
  }
}
