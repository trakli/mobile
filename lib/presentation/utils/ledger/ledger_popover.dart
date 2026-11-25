import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class LedgerPopoverItem {
  final String label;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;

  const LedgerPopoverItem({
    required this.label,
    required this.onTap,
    this.subtitle,
    this.leading,
  });
}

/// Body of a filter popover: a small heading over a list of tappable rows.
class LedgerPopoverMenu extends StatelessWidget {
  final String title;
  final List<LedgerPopoverItem> items;
  final String? emptyText;

  const LedgerPopoverMenu({
    super.key,
    required this.title,
    required this.items,
    this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 8.lx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.lx, 2.lx, 12.lx, 6.lx),
            child: LedgerH6(title),
          ),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(12.lx, 4.lx, 12.lx, 8.lx),
              child: Text(
                emptyText ?? '',
                style: TextStyle(fontSize: 13.lx, color: t.textMuted),
              ),
            ),
          for (final item in items)
            InkWell(
              onTap: item.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.lx,
                  vertical: 9.lx,
                ),
                child: Row(
                  children: [
                    if (item.leading != null) ...[
                      item.leading!,
                      SizedBox(width: 10.lx),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5.lx,
                              color: t.textPrimary,
                            ),
                          ),
                          if (item.subtitle != null)
                            Text(
                              item.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: LedgerText.money(
                                size: 11.lx,
                                color: t.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
