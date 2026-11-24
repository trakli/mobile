import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

class LedgerNavItem {
  final IconData icon;
  final String label;
  final MainNavigationPageState state;

  const LedgerNavItem({
    required this.icon,
    required this.label,
    required this.state,
  });
}

/// Bottom tab bar: two tabs, the raised add button, two tabs.
class LedgerBottomNav extends StatelessWidget {
  final List<LedgerNavItem> items;
  final MainNavigationPageState selected;
  final ValueChanged<MainNavigationPageState> onSelect;
  final VoidCallback onAdd;
  final String addLabel;

  const LedgerBottomNav({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
    required this.addLabel,
  }) : assert(items.length == 4);

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    Widget tab(LedgerNavItem item) {
      final on = item.state == selected;
      final color = on ? t.brandText : t.textMuted;
      return Expanded(
        child: InkWell(
          onTap: () => onSelect(item.state),
          child: Padding(
            padding: EdgeInsets.only(top: 7.lx, bottom: 4.lx),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 19.lx, color: color),
                SizedBox(height: 2.lx),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5.lx,
                    color: color,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: t.bgSurface,
        border: Border(top: BorderSide(color: t.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52.lx,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tab(items[0]),
              tab(items[1]),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -12.lx),
                  child: Center(
                    child: Semantics(
                      button: true,
                      label: addLabel,
                      child: Material(
                        color: t.brandFill,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: const ValueKey('ledger-nav-add'),
                          onTap: onAdd,
                          child: SizedBox(
                            width: 42.lx,
                            height: 42.lx,
                            child: Icon(
                              LucideIcons.plus,
                              color: t.onBrand,
                              size: 20.lx,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              tab(items[2]),
              tab(items[3]),
            ],
          ),
        ),
      ),
    );
  }
}
