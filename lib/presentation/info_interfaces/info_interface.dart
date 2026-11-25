import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// First-run empty state for a list page: what the page is for, a few
/// numbered quick start steps, the primary action and an optional tip.
class InfoInterface extends StatelessWidget {
  final EmptyStateModel data;
  final VoidCallback? action;

  const InfoInterface({
    super.key,
    this.action,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final steps = data.quickStartSteps;
    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 40.lx),
      children: [
        LedgerCoin(icon: data.icon, size: 48),
        SizedBox(height: 14.lx),
        Text(
          data.title.tr(),
          style: TextStyle(
            fontSize: 20.lx,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02 * 20.lx,
            color: t.textPrimary,
          ),
        ),
        SizedBox(height: 6.lx),
        Text(
          data.description.tr(),
          style: TextStyle(
            fontSize: 13.5.lx,
            height: 1.5,
            color: t.textSecondary,
          ),
        ),
        if (steps.isNotEmpty) ...[
          SizedBox(height: 18.lx),
          LedgerH6(LocaleKeys.quickStart.tr()),
          SizedBox(height: 6.lx),
          LedgerCard(
            padding: EdgeInsets.symmetric(horizontal: 12.lx),
            child: Column(
              children: [
                for (final (i, step) in steps.indexed)
                  LedgerRow(
                    leading: _StepNumber(i + 1),
                    title: step.tr(),
                    divider: i != steps.length - 1,
                  ),
              ],
            ),
          ),
        ],
        if (action != null && data.buttonText.isNotEmpty) ...[
          SizedBox(height: 16.lx),
          LedgerButton(
            label: data.buttonText.tr(),
            icon: LucideIcons.plus,
            large: true,
            onPressed: action,
          ),
        ],
        if (data.tipText != null) ...[
          SizedBox(height: 12.lx),
          LedgerNote(icon: LucideIcons.lightbulb, text: data.tipText!.tr()),
        ],
      ],
    );
  }
}

class _StepNumber extends StatelessWidget {
  final int n;
  const _StepNumber(this.n);

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      width: 22.lx,
      height: 22.lx,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.surface2,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Text(
        '$n',
        style: LedgerText.money(
          size: 11.lx,
          weight: FontWeight.w600,
          color: t.textSecondary,
        ),
      ),
    );
  }
}
