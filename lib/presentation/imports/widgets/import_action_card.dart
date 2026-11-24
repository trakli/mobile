import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ImportActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ImportActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return LedgerCard(
      onTap: onTap,
      padding: EdgeInsets.all(12.lx),
      child: Row(
        children: [
          LedgerCoin(
            icon: icon,
            size: 40,
            background: tones.brand.background,
            foreground: tones.brandText,
          ),
          SizedBox(width: 12.lx),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.lx,
                    fontWeight: FontWeight.w600,
                    color: tones.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.lx),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 12.lx, color: tones.textMuted),
                  ),
                ],
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, size: 16.lx, color: tones.textMuted),
        ],
      ),
    );
  }
}
