import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/subscription_tile.dart';

class PremiumDialog extends StatefulWidget {
  final SubscriptionEntity subscription;

  const PremiumDialog({
    super.key,
    required this.subscription,
  });

  @override
  State<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<PremiumDialog> {
  PlanType type = PlanType.monthly;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.lx),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.lx, 22.lx, 18.lx, 16.lx),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.subscription.overview.title,
              style: TextStyle(
                fontSize: 19.lx,
                color: context.tones.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.subscription.overview.description,
              style: TextStyle(
                fontSize: 13.5.lx,
                height: 1.45,
                color: context.tones.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            ...widget.subscription.plans.map<Widget>((plan) {
              return SubscriptionTile(
                plan: plan,
                isSelected: type == getPlanType(plan.id),
                onTap: () {
                  setState(() {
                    type = getPlanType(plan.id);
                  });
                },
              );
            }),
            Row(
              children: [
                Expanded(
                  child: LedgerButton(
                    label: LocaleKeys.cancel.tr(),
                    style: LedgerButtonStyle.outline,
                    large: true,
                    onPressed: () => AppNavigator.pop(context),
                  ),
                ),
                SizedBox(width: 8.lx),
                Expanded(
                  child: LedgerButton(
                    label: LocaleKeys.confirm.tr(),
                    large: true,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
