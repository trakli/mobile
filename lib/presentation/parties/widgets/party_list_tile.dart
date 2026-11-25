import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/party_detail_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Party row: icon, name with type or in and out totals, and the net
/// amount coloured by direction. Tap opens the party detail page.
class PartyListTile extends StatelessWidget {
  final PartyEntity party;
  final double receivedAmount;
  final double spentAmount;
  final String currency;
  final bool divider;

  const PartyListTile({
    super.key,
    required this.party,
    required this.receivedAmount,
    required this.spentAmount,
    required this.currency,
    this.divider = true,
  });

  double get _net => receivedAmount - spentAmount;

  static IconData iconForType(PartyType? type) => switch (type) {
        PartyType.business => LucideIcons.store,
        PartyType.organization => LucideIcons.building2,
        PartyType.partnership => LucideIcons.handshake,
        PartyType.nonProfit => LucideIcons.heartHandshake,
        PartyType.governmentAgency => LucideIcons.landmark,
        PartyType.educationalInstitution => LucideIcons.graduationCap,
        PartyType.healthcareProvider => LucideIcons.stethoscope,
        _ => LucideIcons.userRound,
      };

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final active = receivedAmount > 0 || spentAmount > 0;
    final parts = [
      if (receivedAmount > 0)
        '${LocaleKeys.statsFlowIn.tr()} ${LedgerMoney.format(receivedAmount, currency, short: true)}',
      if (spentAmount > 0)
        '${LocaleKeys.statsFlowOut.tr()} ${LedgerMoney.format(spentAmount, currency, short: true)}',
    ];
    return LedgerRow(
      leading: LedgerCoin(media: party.icon, icon: iconForType(party.type)),
      title: party.name,
      subtitle: active
          ? parts.join(' · ')
          : (party.type?.customName ?? LocaleKeys.walletsFilterIdle.tr()),
      divider: divider,
      onTap: () => AppNavigator.push(context, PartyDetailScreen(party: party)),
      trailing: active
          ? LedgerAmount(
              LedgerMoney.format(_net, currency, sign: true),
              color: _net > 0
                  ? t.incomeColor
                  : (_net < 0 ? t.expenseColor : t.textPrimary),
            )
          : null,
    );
  }
}
