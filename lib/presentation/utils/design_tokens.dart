import 'package:flutter/material.dart';

/// Tonal surface palette mirroring the web app's `.surface--*` classes.
///
/// Each tone supplies a background tint, an accent, a deeper variant for
/// emphasis (icons, eyebrows), and an ink color for text on top. Light and
/// dark theme values are tuned independently so glassy surfaces sit on the
/// page in both modes instead of dominating it.
@immutable
class ToneColors {
  final Color background;
  final Color accent;
  final Color deep;
  final Color ink;

  const ToneColors({
    required this.background,
    required this.accent,
    required this.deep,
    required this.ink,
  });
}

@immutable
class AppTones extends ThemeExtension<AppTones> {
  final ToneColors brand;
  final ToneColors brandSoft;
  final ToneColors income;
  final ToneColors expense;
  final ToneColors neutral;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color borderLight;
  final Color borderMedium;
  final Color bgPage;
  final Color bgSurface;
  final Color bgCard;
  final Color glassBg;
  final Color glassBgStrong;
  final Color hoverOverlay;
  final Color pressOverlay;

  final Color incomeColor;
  final Color expenseColor;
  final Color incomeSoft;
  final Color expenseSoft;

  /// Trakli secondary brand colour (warm). Used sparingly to break up the
  /// green-heavy palette — month chips, decorative dots, highlight accents.
  final Color accentWarm;
  final Color accentWarmSoft;

  final Color surface2;
  final Color surface3;

  /// Filled brand surfaces (primary buttons, the selected wallet card).
  /// Differs from [brandText] in dark mode, where text needs a lighter green
  /// than a fill does to stay readable.
  final Color brandFill;
  final Color brandText;
  final Color onBrand;
  final Color warmText;

  const AppTones({
    required this.brand,
    required this.brandSoft,
    required this.income,
    required this.expense,
    required this.neutral,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.borderLight,
    required this.borderMedium,
    required this.bgPage,
    required this.bgSurface,
    required this.bgCard,
    required this.glassBg,
    required this.glassBgStrong,
    required this.hoverOverlay,
    required this.pressOverlay,
    required this.incomeColor,
    required this.expenseColor,
    required this.incomeSoft,
    required this.expenseSoft,
    required this.accentWarm,
    required this.accentWarmSoft,
    required this.surface2,
    required this.surface3,
    required this.brandFill,
    required this.brandText,
    required this.onBrand,
    required this.warmText,
  });

  static const AppTones light = AppTones(
    brand: ToneColors(
      background: Color(0xFFE2F1E8),
      accent: Color(0xFF047844),
      deep: Color(0xFF047844),
      ink: Color(0xFF0F1A14),
    ),
    brandSoft: ToneColors(
      background: Color(0xFFEEF2F0),
      accent: Color(0xFF4AAD84),
      deep: Color(0xFF035431),
      ink: Color(0xFF0F1A14),
    ),
    income: ToneColors(
      background: Color(0xFFE2F1E8),
      accent: Color(0xFF047844),
      deep: Color(0xFF047844),
      ink: Color(0xFF0F1A14),
    ),
    expense: ToneColors(
      background: Color(0xFFFBE7EA),
      accent: Color(0xFFC2364B),
      deep: Color(0xFFC2364B),
      ink: Color(0xFF0F1A14),
    ),
    neutral: ToneColors(
      background: Color(0xFFEEF2F0),
      accent: Color(0xFFC9D3CD),
      deep: Color(0xFF44554B),
      ink: Color(0xFF0F1A14),
    ),
    textPrimary: Color(0xFF0F1A14),
    textSecondary: Color(0xFF44554B),
    textMuted: Color(0xFF6E7E75),
    borderLight: Color(0xFFDCE3DF),
    borderMedium: Color(0xFFC9D3CD),
    bgPage: Color(0xFFF4F6F5),
    bgSurface: Color(0xFFFFFFFF),
    bgCard: Color(0xFFEEF2F0),
    glassBg: Color(0xC7FFFFFF),
    glassBgStrong: Color(0xEBFFFFFF),
    hoverOverlay: Color(0x0F000000),
    pressOverlay: Color(0x1F000000),
    incomeColor: Color(0xFF047844),
    expenseColor: Color(0xFFC2364B),
    incomeSoft: Color(0xFFE2F1E8),
    expenseSoft: Color(0xFFFBE7EA),
    accentWarm: Color(0xFFFF9500),
    accentWarmSoft: Color(0xFFFFF1DC),
    surface2: Color(0xFFEEF2F0),
    surface3: Color(0xFFE3E9E5),
    brandFill: Color(0xFF047844),
    brandText: Color(0xFF047844),
    onBrand: Color(0xFFFFFFFF),
    warmText: Color(0xFFB05C00),
  );

  static const AppTones dark = AppTones(
    brand: ToneColors(
      background: Color(0xFF123524),
      accent: Color(0xFF4FD18F),
      deep: Color(0xFF4FD18F),
      ink: Color(0xFFE8F0EB),
    ),
    brandSoft: ToneColors(
      background: Color(0xFF18251E),
      accent: Color(0xFF4FD18F),
      deep: Color(0xFF4FD18F),
      ink: Color(0xFFE8F0EB),
    ),
    income: ToneColors(
      background: Color(0xFF123524),
      accent: Color(0xFF4FD18F),
      deep: Color(0xFF4FD18F),
      ink: Color(0xFFE8F0EB),
    ),
    expense: ToneColors(
      background: Color(0xFF3B1A20),
      accent: Color(0xFFFF7A8A),
      deep: Color(0xFFFF7A8A),
      ink: Color(0xFFE8F0EB),
    ),
    neutral: ToneColors(
      background: Color(0xFF18251E),
      accent: Color(0xFF33443A),
      deep: Color(0xFFA9BBB1),
      ink: Color(0xFFE8F0EB),
    ),
    textPrimary: Color(0xFFE8F0EB),
    textSecondary: Color(0xFFA9BBB1),
    textMuted: Color(0xFF7D8F85),
    borderLight: Color(0xFF26352D),
    borderMedium: Color(0xFF33443A),
    bgPage: Color(0xFF0C1410),
    bgSurface: Color(0xFF121C17),
    bgCard: Color(0xFF18251E),
    glassBg: Color(0x24FFFFFF),
    glassBgStrong: Color(0x42FFFFFF),
    hoverOverlay: Color(0x14FFFFFF),
    pressOverlay: Color(0x29FFFFFF),
    incomeColor: Color(0xFF4FD18F),
    expenseColor: Color(0xFFFF7A8A),
    incomeSoft: Color(0xFF123524),
    expenseSoft: Color(0xFF3B1A20),
    accentWarm: Color(0xFFFF9500),
    accentWarmSoft: Color(0xFF3A2A12),
    surface2: Color(0xFF18251E),
    surface3: Color(0xFF1F2E26),
    brandFill: Color(0xFF0A8A50),
    brandText: Color(0xFF4FD18F),
    onBrand: Color(0xFFFFFFFF),
    warmText: Color(0xFFFFB347),
  );

  ToneColors tone(AppTone tone) {
    switch (tone) {
      case AppTone.brand:
        return brand;
      case AppTone.brandSoft:
        return brandSoft;
      case AppTone.income:
        return income;
      case AppTone.expense:
        return expense;
      case AppTone.neutral:
        return neutral;
      case AppTone.warm:
        return ToneColors(
          background: accentWarmSoft,
          accent: accentWarm,
          deep: warmText,
          ink: textPrimary,
        );
    }
  }

  @override
  ThemeExtension<AppTones> copyWith() => this;

  @override
  ThemeExtension<AppTones> lerp(ThemeExtension<AppTones>? other, double t) {
    if (other is! AppTones) return this;
    return t < 0.5 ? this : other;
  }
}

enum AppTone { brand, brandSoft, income, expense, neutral, warm }

/// Layered elevation tokens. The web side stacks two shadows per
/// level; in Flutter we approximate with a multi-stop BoxShadow list.
@immutable
class AppElevations extends ThemeExtension<AppElevations> {
  final List<BoxShadow> level1;
  final List<BoxShadow> level2;
  final List<BoxShadow> level3;
  final List<BoxShadow> level4;
  final List<BoxShadow> level5;

  const AppElevations({
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static const AppElevations light = AppElevations(
    level1: [
      BoxShadow(color: Color(0x12000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 2),
      ),
    ],
    level2: [
      BoxShadow(color: Color(0x08000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 6,
        spreadRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
    level3: [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 8,
        spreadRadius: 3,
        offset: Offset(0, 4),
      ),
      BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
    level4: [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10,
        spreadRadius: 4,
        offset: Offset(0, 6),
      ),
      BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 2)),
    ],
    level5: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        spreadRadius: 6,
        offset: Offset(0, 8),
      ),
      BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 4)),
    ],
  );

  static const AppElevations dark = AppElevations(
    level1: [
      BoxShadow(color: Color(0x80000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4D000000),
        blurRadius: 3,
        spreadRadius: 1,
        offset: Offset(0, 1),
      ),
    ],
    level2: [
      BoxShadow(color: Color(0x80000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x59000000),
        blurRadius: 6,
        spreadRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
    level3: [
      BoxShadow(
        color: Color(0x73000000),
        blurRadius: 8,
        spreadRadius: 3,
        offset: Offset(0, 4),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
    level4: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 10,
        spreadRadius: 4,
        offset: Offset(0, 6),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 3, offset: Offset(0, 2)),
    ],
    level5: [
      BoxShadow(
        color: Color(0x8C000000),
        blurRadius: 12,
        spreadRadius: 6,
        offset: Offset(0, 8),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 4, offset: Offset(0, 4)),
    ],
  );

  @override
  ThemeExtension<AppElevations> copyWith() => this;

  @override
  ThemeExtension<AppElevations> lerp(
    ThemeExtension<AppElevations>? other,
    double t,
  ) {
    return t < 0.5 ? this : (other ?? this);
  }
}

/// Shared corner-radius scale. Use these everywhere instead of hardcoded
/// `BorderRadius.circular(N.r)` so the system stays consistent. The scale
/// is intentionally tighter than the prior ad-hoc radii (~30% smaller) so
/// surfaces read calmer on a phone.
class AppRadii {
  static const double xs = 3;

  static const double sm = 4;

  static const double md = 6;

  static const double lg = 7;

  static const double xl = 8;

  static const double xxl = 8;

  static const double pill = 8;
}

/// Motion tokens, matching the web's easings + durations so
/// component-level animations feel like they came out of the same kit.
class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration deliberate = Duration(milliseconds: 600);

  // Standard / emphasized easings used across the app.
  static const Cubic standard = Cubic(0.2, 0, 0, 1);
  static const Cubic emphasized = Cubic(0.3, 0, 0, 1);
  static const Cubic decelerate = Cubic(0, 0, 0, 1);
  static const Cubic accelerate = Cubic(0.3, 0, 1, 1);
}

/// Convenience extensions so screens read like:
///   `context.tones.brand.accent`
///   `context.elevations.level2`
extension ToneContext on BuildContext {
  AppTones get tones =>
      Theme.of(this).extension<AppTones>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppTones.dark
          : AppTones.light);

  AppElevations get elevations =>
      Theme.of(this).extension<AppElevations>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppElevations.dark
          : AppElevations.light);
}
