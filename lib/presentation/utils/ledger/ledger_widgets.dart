import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

enum LedgerChipTone { neutral, good, bad, warm }

class LedgerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final bool dashed;

  const LedgerCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderColor,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final radius = BorderRadius.circular(AppRadii.md);
    final content = Padding(
      padding: padding ?? EdgeInsets.all(12.lx),
      child: child,
    );
    return Material(
      color: color ?? t.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor ?? t.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

/// Small uppercase section label with an optional action on the right.
class LedgerH6 extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? trailing;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LedgerH6(
    this.text, {
    super.key,
    this.icon,
    this.trailing,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14.lx, color: t.textMuted),
          SizedBox(width: 8.lx),
        ],
        Expanded(
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.lx,
              letterSpacing: 0.09 * 11.lx,
              color: t.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailing != null) trailing!,
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: 12.5.lx,
                fontWeight: FontWeight.w600,
                color: t.brandText,
              ),
            ),
          ),
      ],
    );
  }
}

class LedgerChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final LedgerChipTone tone;
  final VoidCallback? onTap;

  const LedgerChip(
    this.label, {
    super.key,
    this.icon,
    this.tone = LedgerChipTone.neutral,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final (bg, fg) = switch (tone) {
      LedgerChipTone.neutral => (t.surface2, t.textSecondary),
      LedgerChipTone.good => (t.brand.background, t.brandText),
      LedgerChipTone.bad => (t.expenseSoft, t.expenseColor),
      LedgerChipTone.warm => (t.accentWarmSoft, t.warmText),
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.lx, vertical: 2.lx),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13.lx, color: fg),
              SizedBox(width: 5.lx),
            ],
            Text(label, style: TextStyle(fontSize: 12.lx, color: fg)),
          ],
        ),
      ),
    );
  }
}

class LedgerSegOption<T> {
  final T value;
  final String label;
  const LedgerSegOption(this.value, this.label);
}

/// Segmented control: a tinted track with a raised surface on the active
/// option.
class LedgerSeg<T> extends StatelessWidget {
  final List<LedgerSegOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const LedgerSeg({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      padding: EdgeInsets.all(2.lx),
      decoration: BoxDecoration(
        color: t.surface2,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            Padding(
              padding: EdgeInsets.only(
                right: o == options.last ? 0 : 2.lx,
              ),
              child: GestureDetector(
                onTap: () => onChanged(o.value),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.lx, vertical: 5.lx),
                  decoration: BoxDecoration(
                    color: o.value == selected ? t.bgSurface : null,
                    borderRadius: BorderRadius.circular(AppRadii.xs),
                    boxShadow: o.value == selected
                        ? const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    o.label,
                    style: TextStyle(
                      fontSize: 12.5.lx,
                      color:
                          o.value == selected ? t.textPrimary : t.textSecondary,
                      fontWeight: o.value == selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Square outlined icon button used in screen headers.
class LedgerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final Widget? badge;

  const LedgerIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final button = Material(
      color: t.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        side: BorderSide(color: t.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 32.lx,
          height: 32.lx,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(icon, size: 16.lx, color: t.textSecondary),
              ),
              if (badge != null)
                Positioned(top: 4.lx, right: 4.lx, child: badge!),
            ],
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Square tile holding a category or entity icon.
class LedgerCoin extends StatelessWidget {
  final IconData? icon;
  final MediaEntity? media;
  final double size;
  final double? height;
  final Color? background;
  final Color? foreground;

  const LedgerCoin({
    super.key,
    this.icon,
    this.media,
    this.size = 32,
    this.height,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final fg = foreground ?? t.textSecondary;
    return Container(
      width: size.lx,
      height: (height ?? size).lx,
      decoration: BoxDecoration(
        color: background ?? t.surface2,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      alignment: Alignment.center,
      child: media != null
          ? LedgerMediaIcon(
              media: media,
              fallback: icon ?? LucideIcons.tag,
              color: fg,
            )
          : Icon(icon ?? LucideIcons.tag, size: 16.lx, color: fg),
    );
  }
}

/// Initials square (people, members).
class LedgerInitials extends StatelessWidget {
  final String name;
  final double size;
  final Color? background;
  final Color? foreground;

  const LedgerInitials(
    this.name, {
    super.key,
    this.size = 30,
    this.background,
    this.foreground,
  });

  static String initialsOf(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      width: size.lx,
      height: size.lx,
      decoration: BoxDecoration(
        color: background ?? t.surface3,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        initialsOf(name),
        style: TextStyle(
          fontSize: (size * 0.38).lx,
          fontWeight: FontWeight.w700,
          color: foreground ?? t.textSecondary,
        ),
      ),
    );
  }
}

/// List row: leading, two-line text, trailing value, hairline divider.
class LedgerRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool divider;
  final double verticalPadding;
  final TextStyle? titleStyle;

  const LedgerRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.onTap,
    this.divider = true,
    this.verticalPadding = 9,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding.lx),
        decoration: BoxDecoration(
          border:
              divider ? Border(bottom: BorderSide(color: t.borderLight)) : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: 11.lx)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle ??
                        TextStyle(fontSize: 13.5.lx, color: t.textPrimary),
                  ),
                  if (subtitleWidget != null)
                    DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: subtitleWidget!,
                    )
                  else if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 8.lx), trailing!],
          ],
        ),
      ),
    );
  }
}

/// Tabular money text. Positive income uses the income color when
/// [colorize] is set.
class LedgerAmount extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;

  const LedgerAmount(
    this.text, {
    super.key,
    this.size = 13.5,
    this.weight = FontWeight.w500,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: LedgerText.money(
        size: size.lx,
        weight: weight,
        color: color ?? context.tones.textPrimary,
      ),
    );
  }
}

/// The large hero figure (`ph-big`).
class LedgerBigNumber extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;

  const LedgerBigNumber(this.text, {super.key, this.color, this.size = 34});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        style: LedgerText.money(
          size: size.lx,
          weight: FontWeight.w600,
          color: color ?? context.tones.textPrimary,
          letterSpacing: -0.04 * size.lx,
          height: 1,
        ),
      ),
    );
  }
}

enum LedgerButtonStyle { filled, outline }

class LedgerButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LedgerButtonStyle style;
  final bool large;
  final bool busy;
  final Color? background;
  final Color? foreground;

  const LedgerButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = LedgerButtonStyle.filled,
    this.large = false,
    this.busy = false,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final filled = style == LedgerButtonStyle.filled;
    final bg = background ?? (filled ? t.brandFill : t.bgSurface);
    final fg = foreground ?? (filled ? t.onBrand : t.textPrimary);
    final enabled = onPressed != null && !busy;
    return Opacity(
      opacity: enabled || busy ? 1 : 0.5,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          side: filled ? BorderSide.none : BorderSide(color: t.borderLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 13.lx,
              vertical: (large ? 12 : 8).lx,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy)
                  SizedBox(
                    width: 15.lx,
                    height: 15.lx,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: fg,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 15.lx, color: fg),
                if (busy || icon != null) SizedBox(width: 6.lx),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.lx,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
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

/// Thin progress bar.
class LedgerBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? color;

  const LedgerBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: height.lx,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: t.surface3)),
            FractionallySizedBox(
              widthFactor: value.isNaN ? 0 : value.clamp(0.0, 1.0),
              heightFactor: 1,
              child: ColoredBox(color: color ?? t.brandFill),
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? leading;
  final bool selected;
  final bool muted;
  final VoidCallback? onTap;

  const LedgerFilterChip({
    super.key,
    required this.label,
    this.icon,
    this.leading,
    this.selected = false,
    this.muted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final fg = selected ? t.bgPage : (muted ? t.textMuted : t.textSecondary);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.lx, vertical: 4.lx),
        decoration: BoxDecoration(
          color: selected ? t.textPrimary : t.bgSurface,
          border: Border.all(color: selected ? t.textPrimary : t.borderLight),
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(color: fg, size: 13.lx),
                child: leading!,
              ),
              SizedBox(width: 5.lx),
            ] else if (icon != null) ...[
              Icon(icon, size: 13.lx, color: fg),
              SizedBox(width: 5.lx),
            ],
            Text(label, style: TextStyle(fontSize: 11.5.lx, color: fg)),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrolling row of [LedgerFilterChip]s.
class LedgerChipRow extends StatelessWidget {
  final List<Widget> children;

  const LedgerChipRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: 6.lx),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// The "log or ask" bar.
class LedgerAskBar extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final bool placeholder;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onTrailingTap;

  const LedgerAskBar({
    super.key,
    this.leadingIcon = LucideIcons.messageCircle,
    required this.text,
    this.placeholder = true,
    this.trailingIcon,
    this.onTap,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return LedgerCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 10.lx, vertical: 9.lx),
      child: Row(
        children: [
          Icon(leadingIcon, size: 16.lx, color: t.textMuted),
          SizedBox(width: 8.lx),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.lx,
                color: placeholder ? t.textMuted : t.textPrimary,
              ),
            ),
          ),
          if (trailingIcon != null)
            GestureDetector(
              onTap: onTrailingTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(left: 8.lx),
                child: Icon(trailingIcon, size: 16.lx, color: t.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tinted note with a leading coin (`ins`).
class LedgerInsight extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const LedgerInsight({super.key, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      padding: EdgeInsets.all(10.lx),
      decoration: BoxDecoration(
        color: t.surface2,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LedgerCoin(icon: icon, background: t.bgSurface),
          SizedBox(width: 10.lx),
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 12.5.lx,
                height: 1.45,
                color: t.textPrimary,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed privacy or info note (`priv`).
class LedgerNote extends StatelessWidget {
  final IconData icon;
  final String text;

  const LedgerNote({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return CustomPaint(
      painter: _DashedBorderPainter(color: t.borderLight),
      child: Padding(
        padding: EdgeInsets.all(10.lx),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16.lx, color: t.brandText),
            SizedBox(width: 10.lx),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11.5.lx,
                  height: 1.45,
                  color: t.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(AppRadii.md),
      ));
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

enum LedgerTimelineTone { muted, good, warm }

class LedgerTimelineEntry {
  final String text;
  final String date;
  final LedgerTimelineTone tone;
  const LedgerTimelineEntry(this.text, this.date, this.tone);
}

class LedgerTimeline extends StatelessWidget {
  final List<LedgerTimelineEntry> entries;

  const LedgerTimeline({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Stack(
      children: [
        Positioned(
          left: 4.lx,
          top: 6.lx,
          bottom: 6.lx,
          child: Container(width: 2, color: t.borderLight),
        ),
        Column(
          children: [
            for (final e in entries)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.lx),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4.lx, left: 1.lx),
                      width: 8.lx,
                      height: 8.lx,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: switch (e.tone) {
                          LedgerTimelineTone.good => t.brandText,
                          LedgerTimelineTone.warm => t.accentWarm,
                          LedgerTimelineTone.muted => t.textMuted,
                        },
                      ),
                    ),
                    SizedBox(width: 9.lx),
                    Expanded(
                      child: Text(
                        e.text,
                        style: TextStyle(
                          fontSize: 12.5.lx,
                          color: t.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.lx),
                    Text(
                      e.date,
                      style: LedgerText.money(
                        size: 12.5.lx,
                        color: t.textMuted,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Day-of-month badge (`when`).
class LedgerWhen extends StatelessWidget {
  final String day;
  final String month;

  const LedgerWhen({super.key, required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      width: 40.lx,
      padding: EdgeInsets.symmetric(vertical: 4.lx),
      decoration: BoxDecoration(
        color: t.surface2,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: LedgerText.money(
              size: 15.lx,
              weight: FontWeight.w700,
              color: t.textPrimary,
              height: 1.05,
            ),
          ),
          Text(
            month.toUpperCase(),
            style: TextStyle(
              fontSize: 9.5.lx,
              letterSpacing: 0.08 * 9.5.lx,
              color: t.textMuted,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled form row (`frow`).
class LedgerFieldRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool placeholder;
  final Widget? trailing;
  final bool chevron;
  final VoidCallback? onTap;
  final bool divider;

  const LedgerFieldRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    this.placeholder = false,
    this.trailing,
    this.chevron = false,
    this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9.lx),
        decoration: BoxDecoration(
          border:
              divider ? Border(bottom: BorderSide(color: t.borderLight)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.lx, color: t.textMuted),
            SizedBox(width: 10.lx),
            SizedBox(
              width: 84.lx,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
              ),
            ),
            SizedBox(width: 10.lx),
            Expanded(
              child: valueWidget ??
                  Text(
                    value ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5.lx,
                      color: placeholder ? t.textMuted : t.textPrimary,
                    ),
                  ),
            ),
            if (trailing != null) ...[SizedBox(width: 8.lx), trailing!],
            if (chevron)
              Padding(
                padding: EdgeInsets.only(left: 8.lx),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16.lx,
                  color: t.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Square-cornered switch (`tog`).
class LedgerToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LedgerToggle({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: 34.lx,
        height: 20.lx,
        padding: EdgeInsets.all(3.lx),
        decoration: BoxDecoration(
          color: value ? t.brandFill : t.surface3,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 14.lx,
          height: 14.lx,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.xs),
          ),
        ),
      ),
    );
  }
}

/// Screen header row: optional leading icon button, title, actions.
class LedgerScreenBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final IconData? leadingIcon;
  final VoidCallback? onLeading;
  final List<Widget> actions;

  const LedgerScreenBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leadingIcon,
    this.onLeading,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Row(
      children: [
        if (leadingIcon != null) ...[
          LedgerIconButton(
            icon: leadingIcon!,
            onTap: onLeading ?? () => Navigator.of(context).maybePop(),
          ),
          SizedBox(width: 10.lx),
        ],
        Expanded(
          child: titleWidget ??
              Text(
                title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.lx,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.02 * 18.lx,
                  color: t.textPrimary,
                ),
              ),
        ),
        for (var i = 0; i < actions.length; i++) ...[
          SizedBox(width: (i == 0 ? 10 : 8).lx),
          actions[i],
        ],
      ],
    );
  }
}

/// Grab handle for bottom sheets.
class LedgerSheetHandle extends StatelessWidget {
  const LedgerSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36.lx,
        height: 4.lx,
        decoration: BoxDecoration(
          color: context.tones.borderLight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class LedgerWeekBar {
  final String label;
  final double value;
  final String valueLabel;
  final bool hot;
  const LedgerWeekBar({
    required this.label,
    required this.value,
    required this.valueLabel,
    this.hot = false,
  });
}

/// Vertical bars with a value on top and a label below (`wkb`).
class LedgerWeekBars extends StatelessWidget {
  final List<LedgerWeekBar> bars;
  final double height;

  const LedgerWeekBars({super.key, required this.bars, this.height = 96});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final max = bars.fold<double>(0, (m, b) => b.value > m ? b.value : m);
    final labelStyle = TextStyle(fontSize: 10.5.lx, color: t.textMuted);
    final valueStyle = LedgerText.money(size: 11.lx, color: t.textPrimary);
    return SizedBox(
      height: height.lx,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bars.length; i++) ...[
            if (i > 0) SizedBox(width: 8.lx),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(bars[i].valueLabel,
                            style: valueStyle, maxLines: 1),
                        SizedBox(height: 4.lx),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: max <= 0
                                ? 0
                                : (bars[i].value / max).clamp(0, 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: bars[i].hot ? t.accentWarm : t.brandFill,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.lx),
                  Text(bars[i].label, style: labelStyle, maxLines: 1),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small checkbox square (`cb`).
class LedgerCheck extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LedgerCheck({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 16.lx,
        height: 16.lx,
        decoration: BoxDecoration(
          color: value ? t.brandFill : null,
          border: Border.all(
            color: value ? t.brandFill : t.textMuted,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppRadii.xs),
        ),
        child: value
            ? Icon(LucideIcons.check, size: 12.lx, color: Colors.white)
            : null,
      ),
    );
  }
}

/// Small labelled total, such as In, Out or Kept for a period.
class LedgerTotalTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const LedgerTotalTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LedgerCard(
      padding: EdgeInsets.all(8.lx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.lx, color: context.tones.textMuted),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: LedgerAmount(
              value,
              size: 14,
              weight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
