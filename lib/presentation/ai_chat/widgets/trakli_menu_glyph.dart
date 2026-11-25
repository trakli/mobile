import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Header button that opens the app drawer, drawn with [TrakliMenuGlyph].
class TrakliDrawerButton extends StatelessWidget {
  const TrakliDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Semantics(
      button: true,
      label: LocaleKeys.homeMenu.tr(),
      child: Tooltip(
        message: LocaleKeys.homeMenu.tr(),
        child: Material(
          color: t.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            side: BorderSide(color: t.borderLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: SizedBox(
              width: 32.lx,
              height: 32.lx,
              child: const Center(child: TrakliMenuGlyph()),
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu glyph drawn from the Trakli mark: its three receipt lines become the
/// menu bars, the top one keeps the mark's arrowhead, and the mark's
/// orange-and-green gauge sits under the arrow.
class TrakliMenuGlyph extends StatelessWidget {
  final double size;

  const TrakliMenuGlyph({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: Size(size.lx, size.lx * 16 / 20),
      painter: _MenuGlyphPainter(
        bars: dark ? Colors.white : t.brandFill,
        gaugeMain: t.accentWarm,
        gaugeTail: dark ? Colors.white : t.brandFill,
      ),
    );
  }
}

class _MenuGlyphPainter extends CustomPainter {
  final Color bars;
  final Color gaugeMain;
  final Color gaugeTail;

  const _MenuGlyphPainter({
    required this.bars,
    required this.gaugeMain,
    required this.gaugeTail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 20;
    const thickness = 2.4;

    final bar = Paint()
      ..color = bars
      ..strokeWidth = thickness * s
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(1.2 * s, 2.8 * s), Offset(13 * s, 2.8 * s), bar);
    canvas.drawLine(Offset(1.2 * s, 8 * s), Offset(10.5 * s, 8 * s), bar);
    canvas.drawLine(Offset(1.2 * s, 13.2 * s), Offset(7 * s, 13.2 * s), bar);

    final arrow = Path()
      ..moveTo(13.6 * s, 0)
      ..lineTo(19.4 * s, 2.8 * s)
      ..lineTo(13.6 * s, 5.6 * s)
      ..close();
    canvas.drawPath(arrow, Paint()..color = bars);

    final gauge = Rect.fromCircle(
      center: Offset(15.6 * s, 11.8 * s),
      radius: 2.9 * s,
    );
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9 * s
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      gauge,
      math.pi * 0.5,
      math.pi * 1.5,
      false,
      arc..color = gaugeMain,
    );
    canvas.drawArc(
      gauge,
      math.pi * 0.08,
      math.pi * 0.34,
      false,
      arc..color = gaugeTail,
    );
  }

  @override
  bool shouldRepaint(_MenuGlyphPainter old) =>
      old.bars != bars ||
      old.gaugeMain != gaugeMain ||
      old.gaugeTail != gaugeTail;
}
