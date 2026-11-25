import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_menu_glyph.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

/// Top bar for content pages: back (or the drawer button on root pages),
/// a left-aligned title, then square actions.
///
/// When [onSearchChanged] is supplied a search action appears; tapping it
/// turns the title slot into a search input until it is closed.
class PageAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? eyebrow;
  final List<Widget> actions;
  final bool showBack;
  final VoidCallback? onBack;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;

  /// Replaces the back button or drawer button.
  final Widget? leading;

  /// Replaces the title text.
  final Widget? titleWidget;

  const PageAppBar({
    super.key,
    required this.title,
    this.eyebrow,
    this.actions = const [],
    this.showBack = true,
    this.onBack,
    this.onSearchChanged,
    this.searchHint = 'Search',
    this.leading,
    this.titleWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(52.lx);

  @override
  State<PageAppBar> createState() => _PageAppBarState();
}

class _PageAppBarState extends State<PageAppBar> {
  bool _searching = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searching = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _closeSearch() {
    _controller.clear();
    widget.onSearchChanged?.call('');
    setState(() => _searching = false);
  }

  Widget _leading(BuildContext context) {
    if (widget.leading != null) return widget.leading!;
    if (widget.showBack) {
      return LedgerIconButton(
        icon: LucideIcons.chevronLeft,
        onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
      );
    }
    return const TrakliDrawerButton();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final Widget content;
    if (_searching) {
      content = Row(
        children: [
          LedgerIconButton(icon: LucideIcons.chevronLeft, onTap: _closeSearch),
          SizedBox(width: 10.lx),
          Expanded(
            child: _SearchField(
              controller: _controller,
              focusNode: _focus,
              hint: widget.searchHint,
              onChanged: widget.onSearchChanged!,
              onClear: () {
                _controller.clear();
                widget.onSearchChanged?.call('');
              },
            ),
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          _leading(context),
          SizedBox(width: 10.lx),
          Expanded(
            child: widget.titleWidget ??
                _TitleBlock(title: widget.title, eyebrow: widget.eyebrow),
          ),
          if (widget.onSearchChanged != null) ...[
            SizedBox(width: 8.lx),
            LedgerIconButton(icon: LucideIcons.search, onTap: _openSearch),
          ],
          for (final a in widget.actions) ...[SizedBox(width: 8.lx), a],
        ],
      );
    }
    return Material(
      color: t.bgPage,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: widget.preferredSize.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.lx),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String? eyebrow;

  const _TitleBlock({required this.title, this.eyebrow});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null)
          Text(
            eyebrow!.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.lx,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.09 * 10.lx,
              color: t.textMuted,
            ),
          ),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.lx,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02 * 18.lx,
            color: t.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      height: 34.lx,
      padding: EdgeInsets.symmetric(horizontal: 10.lx),
      decoration: BoxDecoration(
        color: t.bgSurface,
        border: Border.all(color: t.borderLight),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, size: 15.lx, color: t.textMuted),
          SizedBox(width: 8.lx),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 14.lx, color: t.textPrimary),
              cursorColor: t.brandFill,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14.lx, color: t.textMuted),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                child: Icon(LucideIcons.x, size: 15.lx, color: t.textMuted),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Action for [PageAppBar.actions]: a square outlined icon button, a
/// filled brand square when [primary], or a filled button with text when
/// [label] is set.
class PageAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool primary;
  final String? label;

  const PageAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.primary = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final Widget button;
    if (!primary && label == null) {
      button = LedgerIconButton(icon: icon, onTap: onTap);
    } else {
      button = Material(
        color: t.brandFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 32.lx,
            width: label == null ? 32.lx : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: label == null ? 0 : 10.lx,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16.lx, color: Colors.white),
                  if (label != null) ...[
                    SizedBox(width: 6.lx),
                    Text(
                      label!,
                      style: TextStyle(
                        fontSize: 12.5.lx,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}
