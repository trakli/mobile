import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// A titled card of settings rows with hairline dividers between them.
class LedgerSettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const LedgerSettingsGroup({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(left: 2.lx),
            child: LedgerH6(title!),
          ),
          SizedBox(height: 6.lx),
        ],
        LedgerCard(
          padding: EdgeInsets.symmetric(horizontal: 12.lx),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Divider(height: 1, color: t.borderLight),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One settings row: icon, title, optional subtitle, and either a value
/// with a chevron, a custom [trailing] widget, or nothing.
class LedgerSettingsRow extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  const LedgerSettingsRow({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final fg = destructive ? t.expenseColor : t.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.lx),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: 12.lx),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 17.lx,
                color: destructive ? t.expenseColor : t.textSecondary,
              ),
              SizedBox(width: 12.lx),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.lx,
                      fontWeight: FontWeight.w500,
                      color: fg,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.lx),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              SizedBox(width: 8.lx),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 150.lx),
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                ),
              ),
            ],
            if (trailing != null) ...[
              SizedBox(width: 8.lx),
              trailing!,
            ] else if (onTap != null && !destructive) ...[
              SizedBox(width: 6.lx),
              Icon(LucideIcons.chevronRight, size: 16.lx, color: t.textMuted),
            ],
          ],
        ),
      ),
    );
  }
}

/// A settings row whose trailing control is a [LedgerToggle].
class LedgerSettingsToggle extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LedgerSettingsToggle({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LedgerSettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: LedgerToggle(value: value, onChanged: onChanged),
    );
  }
}

class LedgerOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;

  const LedgerOption(this.value, this.label, {this.subtitle, this.leading});
}

/// Bottom sheet listing [options] with a check on [selected]. Resolves to
/// the picked value, or null when dismissed.
Future<T?> showLedgerOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required List<LedgerOption<T>> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.tones.bgSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (sheet) {
      final t = sheet.tones;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheet).size.height * 0.75,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 14.lx),
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 10.lx),
              LedgerH6(title),
              SizedBox(height: 4.lx),
              for (final o in options)
                LedgerRow(
                  leading: o.leading,
                  title: o.label,
                  subtitle: o.subtitle,
                  divider: o != options.last,
                  trailing: o.value == selected
                      ? Icon(LucideIcons.check, size: 16.lx, color: t.brandText)
                      : null,
                  onTap: () => Navigator.of(sheet).pop(o.value),
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// Page body for settings screens: page background, side gutters and
/// spacing between groups.
class LedgerSettingsList extends StatelessWidget {
  final List<Widget> children;

  const LedgerSettingsList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: 16.lx),
          children[i],
        ],
      ],
    );
  }
}

/// Ledger colours and type for the currency_picker sheet.
CurrencyPickerThemeData ledgerCurrencyPickerTheme(BuildContext context) {
  final t = context.tones;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadii.sm),
    borderSide: BorderSide(color: t.borderLight),
  );
  return CurrencyPickerThemeData(
    bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
    backgroundColor: t.bgSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    flagSize: 20.lx,
    titleTextStyle: TextStyle(fontSize: 14.lx, color: t.textPrimary),
    subtitleTextStyle: TextStyle(fontSize: 12.lx, color: t.textMuted),
    currencySignTextStyle: LedgerText.money(
      size: 13.lx,
      color: t.textSecondary,
    ),
    inputDecoration: InputDecoration(
      isDense: true,
      prefixIcon: Icon(LucideIcons.search, size: 16.lx, color: t.textMuted),
      hintText: 'Search',
      hintStyle: TextStyle(fontSize: 14.lx, color: t.textMuted),
      filled: true,
      fillColor: t.bgPage,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: t.brandFill),
      ),
    ),
  );
}
