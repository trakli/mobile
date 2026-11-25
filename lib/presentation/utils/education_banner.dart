import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class EducationBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  const EducationBanner({
    super.key,
    required this.message,
    this.icon = LucideIcons.lightbulb,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.lx),
      child: LedgerCard(
        color: t.accentWarmSoft,
        borderColor: t.accentWarm.withValues(alpha: 0.45),
        padding: EdgeInsets.all(12.lx),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 17.lx, color: t.accentWarm),
            SizedBox(width: 10.lx),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12.5.lx,
                  height: 1.45,
                  color: t.textPrimary,
                ),
              ),
            ),
            if (onDismiss != null) ...[
              SizedBox(width: 8.lx),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(LucideIcons.x, size: 15.lx, color: t.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
