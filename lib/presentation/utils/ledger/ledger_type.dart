import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFonts {
  AppFonts._();

  static const String body = 'Geist';
  static const String mono = 'GeistMono';
  static const String display = 'BricolageGrotesque';
}

extension LedgerScale on num {
  /// Ledger sizes are specified against a 302 logical pixel wide phone; this
  /// maps them onto the 390 wide ScreenUtil design canvas.
  double get lx => (this * 1.2).sp;
}

class LedgerText {
  LedgerText._();

  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static TextStyle money({
    required double size,
    FontWeight weight = FontWeight.w500,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.mono,
      fontFeatures: tabular,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle display({
    required double size,
    Color? color,
    double height = 1.02,
  }) {
    return TextStyle(
      fontFamily: AppFonts.display,
      fontVariations: const [FontVariation('wght', 800)],
      fontWeight: FontWeight.w800,
      fontSize: size,
      color: color,
      height: height,
      letterSpacing: -0.03 * size,
    );
  }
}
