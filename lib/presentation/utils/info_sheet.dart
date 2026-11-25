import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/bottom_sheets/draggable_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// One titled paragraph shown inside [showInfoSheet].
class InfoSection {
  final String heading;
  final String body;

  const InfoSection({required this.heading, required this.body});
}

/// Explanatory bottom sheet behind a "?" help action. Use it where the mental
/// model of a screen isn't obvious (holdings, financial position) so users get
/// context without cluttering the form itself. The sheet can be dragged to
/// extend and respects the device safe area.
Future<void> showInfoSheet(
  BuildContext context, {
  required String title,
  required List<InfoSection> sections,
}) {
  return showDraggableBottomSheet<void>(
    context,
    backgroundColor: context.tones.bgSurface,
    initialChildSize: 0.6,
    minChildSize: 0.4,
    maxChildSize: 0.9,
    builder: (context, controller) => _InfoSheet(
      title: title,
      sections: sections,
      controller: controller,
    ),
  );
}

class _InfoSheet extends StatelessWidget {
  final String title;
  final List<InfoSection> sections;
  final ScrollController controller;

  const _InfoSheet({
    required this.title,
    required this.sections,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8.lx),
        const LedgerSheetHandle(),
        Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 8.lx, 4.lx),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.lx,
                    fontWeight: FontWeight.w700,
                    color: t.textPrimary,
                  ),
                ),
              ),
              LedgerIconButton(
                icon: LucideIcons.x,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 24.lx),
            children: [
              for (final section in sections) ...[
                Text(
                  section.heading,
                  style: TextStyle(
                    fontSize: 14.lx,
                    fontWeight: FontWeight.w600,
                    color: t.textPrimary,
                  ),
                ),
                SizedBox(height: 4.lx),
                Text(
                  section.body,
                  style: TextStyle(
                    fontSize: 13.lx,
                    height: 1.5,
                    color: t.textSecondary,
                  ),
                ),
                SizedBox(height: 16.lx),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
