import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class ImportSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isPrimary;
  final VoidCallback? onTap;

  const ImportSourceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final disabled = onTap == null;
    final fg = isPrimary ? tones.onBrand : tones.textPrimary;
    final subFg =
        isPrimary ? tones.onBrand.withValues(alpha: 0.8) : tones.textMuted;
    final bg = isPrimary ? tones.brandFill : tones.bgSurface;
    final radius = BorderRadius.circular(AppRadii.md);

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: bg,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: isPrimary ? null : Border.all(color: tones.borderLight),
            ),
            padding: EdgeInsets.all(10.lx),
            child: Row(
              children: [
                LedgerCoin(
                  icon: icon,
                  size: 36,
                  background:
                      isPrimary ? tones.onBrand.withValues(alpha: 0.18) : null,
                  foreground: isPrimary ? tones.onBrand : null,
                ),
                SizedBox(width: 11.lx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13.5.lx,
                          color: fg,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.lx),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12.lx, color: subFg),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImportFilePreview extends StatelessWidget {
  final String fileName;
  final VoidCallback? onClear;

  const ImportFilePreview({
    super.key,
    required this.fileName,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.fromLTRB(10.lx, 6.lx, 4.lx, 6.lx),
      decoration: BoxDecoration(
        color: tones.surface2,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.fileText, size: 16.lx, color: tones.textSecondary),
          SizedBox(width: 8.lx),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: LedgerText.money(size: 12.lx, color: tones.textPrimary),
            ),
          ),
          LedgerIconButton(
            icon: LucideIcons.x,
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            onTap: onClear,
          ),
        ],
      ),
    );
  }
}
