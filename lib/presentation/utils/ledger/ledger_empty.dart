import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Centered empty state for list pages: icon coin, title, body and an
/// optional call to action. Scrollable so pull to refresh still works.
class LedgerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool loading;

  const LedgerEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: Center(
            child: loading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.lx),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LedgerCoin(icon: icon, size: 48),
                        SizedBox(height: 14.lx),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.lx,
                            fontWeight: FontWeight.w700,
                            color: t.textPrimary,
                          ),
                        ),
                        if (body != null) ...[
                          SizedBox(height: 6.lx),
                          Text(
                            body!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.lx,
                              height: 1.45,
                              color: t.textSecondary,
                            ),
                          ),
                        ],
                        if (actionLabel != null && onAction != null) ...[
                          SizedBox(height: 18.lx),
                          LedgerButton(
                            label: actionLabel!,
                            icon: LucideIcons.plus,
                            onPressed: onAction,
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
