import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class PopUpDialog extends StatelessWidget {
  final DialogType dialogType;
  final Color? accentColor;
  final VoidCallback? mainAction;
  final VoidCallback? secondaryAction;
  final String title;
  final String subTitle;
  final String? mainActionText;
  final String? secondaryActionText;
  final ButtonLayout buttonLayout;
  final bool showSecondary;

  const PopUpDialog({
    super.key,
    required this.title,
    required this.subTitle,
    this.dialogType = DialogType.positive,
    this.accentColor,
    this.mainAction,
    this.secondaryAction,
    this.mainActionText,
    this.secondaryActionText,
    this.buttonLayout = ButtonLayout.horizontal,
    this.showSecondary = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final positive = dialogType == DialogType.positive;
    final accent = accentColor ?? (positive ? t.brandFill : t.expenseColor);

    final secondary = LedgerButton(
      label: secondaryActionText ?? LocaleKeys.cancel.tr(),
      style: LedgerButtonStyle.outline,
      large: true,
      onPressed: secondaryAction ?? () => AppNavigator.pop(context),
    );
    final main = LedgerButton(
      label: mainActionText ?? LocaleKeys.confirm.tr(),
      large: true,
      background: accent,
      onPressed: mainAction ?? () {},
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.lx, vertical: 24.lx),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.lx, 20.lx, 18.lx, 16.lx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LedgerCoin(
              icon: positive ? LucideIcons.check : LucideIcons.triangleAlert,
              foreground: accent,
              size: 36,
            ),
            SizedBox(height: 14.lx),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.lx,
                fontWeight: FontWeight.w700,
                color: t.textPrimary,
              ),
            ),
            SizedBox(height: 6.lx),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 13.5.lx,
                height: 1.45,
                color: t.textSecondary,
              ),
            ),
            SizedBox(height: 18.lx),
            if (!showSecondary)
              main
            else if (buttonLayout == ButtonLayout.vertical) ...[
              main,
              SizedBox(height: 8.lx),
              secondary,
            ] else
              Row(
                children: [
                  Expanded(child: secondary),
                  SizedBox(width: 8.lx),
                  Expanded(child: main),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
