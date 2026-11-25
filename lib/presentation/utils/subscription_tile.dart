import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class SubscriptionTile extends StatefulWidget {
  final bool isSelected;
  final PlanEntity plan;
  final VoidCallback? onTap;

  const SubscriptionTile({
    super.key,
    this.isSelected = false,
    required this.plan,
    this.onTap,
  });

  @override
  State<SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<SubscriptionTile> {
  PlanType planType = PlanType.monthly;

  @override
  void initState() {
    planType = getPlanType(widget.plan.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final yearly = planType == PlanType.yearly;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(12.lx),
        decoration: BoxDecoration(
          color: widget.isSelected ? t.surface2 : t.bgSurface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(
            width: widget.isSelected ? 1.5 : 1,
            color: widget.isSelected ? t.brandFill : t.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.plan.name,
                  style: TextStyle(
                    fontSize: 14.lx,
                    fontWeight: FontWeight.w700,
                    color: t.textPrimary,
                  ),
                ),
                if (yearly) ...[
                  SizedBox(width: 8.lx),
                  LedgerChip(
                    LocaleKeys.recommended.tr(),
                    tone: LedgerChipTone.warm,
                  ),
                ],
                const Spacer(),
                Icon(
                  widget.isSelected
                      ? LucideIcons.circleCheck
                      : LucideIcons.circle,
                  size: 18.lx,
                  color: widget.isSelected ? t.brandFill : t.textMuted,
                ),
              ],
            ),
            SizedBox(height: 6.lx),
            Text(
              "${widget.plan.priceFormatted}/${widget.plan.interval}",
              style: LedgerText.money(
                size: 17.lx,
                weight: FontWeight.w600,
                color: t.textPrimary,
              ),
            ),
            SizedBox(height: 2.lx),
            Text(
              widget.plan.cta.text,
              style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
            ),
            SizedBox(height: 8.lx),
            for (final feature in widget.plan.features)
              Padding(
                padding: EdgeInsets.only(top: 4.lx),
                child: Row(
                  children: [
                    Icon(LucideIcons.check, size: 14.lx, color: t.brandText),
                    SizedBox(width: 8.lx),
                    Expanded(
                      child: Text(
                        feature,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.lx, color: t.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
