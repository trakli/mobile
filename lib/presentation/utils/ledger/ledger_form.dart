import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Top card of an entity form: a tappable icon tile and a large name field.
class LedgerNameCard extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final MediaEntity? media;
  final Color? accent;
  final VoidCallback? onPickIcon;
  final FormFieldValidator<String>? validator;

  const LedgerNameCard({
    super.key,
    required this.controller,
    required this.hint,
    this.media,
    this.accent,
    this.onPickIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final tint = accent ?? t.brandText;
    final style = TextStyle(
      fontSize: 17.lx,
      fontWeight: FontWeight.w600,
      color: t.textPrimary,
    );
    return LedgerCard(
      child: Row(
        children: [
          if (onPickIcon != null) ...[
            GestureDetector(
              onTap: onPickIcon,
              child: Container(
                width: 44.lx,
                height: 44.lx,
                decoration: BoxDecoration(
                  color: accent?.withValues(alpha: 0.14) ?? t.surface2,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: ImageWidget(mediaEntity: media, accentColor: tint),
              ),
            ),
            SizedBox(width: 12.lx),
          ],
          Expanded(
            child: TextFormField(
              controller: controller,
              style: style,
              decoration: ledgerBareInput(
                hint,
                style.copyWith(color: t.textMuted),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card holding a column of [LedgerFieldRow]s.
class LedgerFieldsCard extends StatelessWidget {
  final List<Widget> children;

  const LedgerFieldsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LedgerCard(
      padding: EdgeInsets.symmetric(horizontal: 12.lx),
      child: Column(children: children),
    );
  }
}

/// Multi-line text input sized for a [LedgerFieldRow] value slot.
class LedgerInlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const LedgerInlineField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 4,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(fontSize: 12.5.lx, color: t.textPrimary),
      decoration: ledgerBareInput(
        hint,
        TextStyle(fontSize: 12.5.lx, color: t.textMuted),
      ),
    );
  }
}

/// Borderless, unfilled input. [InputDecoration.collapsed] alone still picks
/// up the theme's enabled and focused borders and fill.
InputDecoration ledgerBareInput(String hint, TextStyle hintStyle) {
  return InputDecoration(
    hintText: hint,
    hintStyle: hintStyle,
    isCollapsed: true,
    filled: false,
    contentPadding: EdgeInsets.zero,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );
}
