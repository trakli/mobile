import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// Material theme in Ledger terms, so widgets that still use stock
/// Material controls (text fields, buttons, dialogs, pickers, menus) pick
/// up the same colours, radii and type as the Ledger components.
abstract class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme =>
      _build(AppTones.light, AppElevations.light, Brightness.light);

  static ThemeData get darkTheme =>
      _build(AppTones.dark, AppElevations.dark, Brightness.dark);

  static ThemeData _build(
    AppTones t,
    AppElevations elevations,
    Brightness brightness,
  ) {
    final dark = brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppRadii.sm);
    const sheetRadius = BorderRadius.vertical(top: Radius.circular(12));
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: c, width: w),
        );
    final buttonText = TextStyle(
      fontFamily: AppFonts.body,
      fontSize: 14.lx,
      fontWeight: FontWeight.w600,
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: radius);
    final buttonPadding =
        EdgeInsets.symmetric(horizontal: 14.lx, vertical: 11.lx);

    final scheme =
        (dark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
      surface: t.bgSurface,
      onSurface: t.textPrimary,
      onSurfaceVariant: t.textSecondary,
      surfaceContainerLowest: t.bgSurface,
      surfaceContainerLow: t.bgSurface,
      surfaceContainer: t.bgSurface,
      surfaceContainerHigh: t.bgSurface,
      surfaceContainerHighest: t.surface2,
      primary: t.brandFill,
      onPrimary: t.onBrand,
      primaryContainer: t.surface2,
      onPrimaryContainer: t.brandText,
      secondary: t.accentWarm,
      secondaryContainer: t.surface2,
      onSecondaryContainer: t.textPrimary,
      error: t.expenseColor,
      outline: t.borderMedium,
      outlineVariant: t.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppFonts.body,
      colorScheme: scheme,
      primaryColor: t.brandFill,
      primaryColorLight: t.surface2,
      primaryColorDark: t.textPrimary,
      hintColor: t.textMuted,
      scaffoldBackgroundColor: t.bgPage,
      canvasColor: t.bgSurface,
      splashFactory: InkRipple.splashFactory,
      extensions: [t, elevations],
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 20.lx,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 20.lx,
          color: t.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 15.lx,
          fontWeight: FontWeight.w700,
          color: t.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 15.lx,
          fontWeight: FontWeight.w600,
          color: t.textPrimary,
        ),
        bodyLarge: TextStyle(
            fontFamily: AppFonts.body, fontSize: 14.lx, color: t.textPrimary),
        bodyMedium: TextStyle(
            fontFamily: AppFonts.body, fontSize: 14.lx, color: t.textPrimary),
        bodySmall: TextStyle(
            fontFamily: AppFonts.body, fontSize: 12.lx, color: t.textSecondary),
        labelLarge: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 14.lx,
          fontWeight: FontWeight.w600,
          color: t.textPrimary,
        ),
        labelSmall: TextStyle(
            fontFamily: AppFonts.body, fontSize: 12.lx, color: t.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: t.brandFill,
          foregroundColor: t.onBrand,
          disabledBackgroundColor: t.surface2,
          disabledForegroundColor: t.textMuted,
          textStyle: buttonText,
          shape: buttonShape,
          padding: buttonPadding,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.brandFill,
          foregroundColor: t.onBrand,
          textStyle: buttonText,
          shape: buttonShape,
          padding: buttonPadding,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          backgroundColor: t.bgSurface,
          textStyle: buttonText,
          shape: buttonShape,
          side: BorderSide(color: t.borderMedium),
          padding: buttonPadding,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.brandText,
          textStyle: buttonText,
          shape: buttonShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: t.textSecondary,
          shape: buttonShape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.brandFill,
        foregroundColor: t.onBrand,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.bgSurface,
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.lx, vertical: 12.lx),
        hintStyle: TextStyle(
            fontFamily: AppFonts.body, color: t.textMuted, fontSize: 14.lx),
        labelStyle: TextStyle(
            fontFamily: AppFonts.body, color: t.textSecondary, fontSize: 14.lx),
        floatingLabelStyle: TextStyle(
            fontFamily: AppFonts.body, color: t.brandText, fontSize: 13.lx),
        helperStyle: TextStyle(
            fontFamily: AppFonts.body, color: t.textMuted, fontSize: 11.5.lx),
        errorStyle: TextStyle(
            fontFamily: AppFonts.body,
            color: t.expenseColor,
            fontSize: 11.5.lx),
        prefixIconColor: t.textMuted,
        suffixIconColor: t.textMuted,
        border: border(t.borderLight),
        enabledBorder: border(t.borderLight),
        disabledBorder: border(t.borderLight),
        focusedBorder: border(t.brandFill, 1.4),
        errorBorder: border(t.expenseColor),
        focusedErrorBorder: border(t.expenseColor, 1.4),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.brandFill,
        selectionColor: t.brandFill.withValues(alpha: 0.25),
        selectionHandleColor: t.brandFill,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xs),
        ),
        side: BorderSide(color: t.borderMedium, width: 1.4),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.brandFill : null,
        ),
        checkColor: WidgetStatePropertyAll(t.onBrand),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? t.brandFill : t.borderMedium,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onBrand : t.bgSurface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.brandFill : t.surface3,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.brandFill,
        linearTrackColor: t.surface2,
        circularTrackColor: Colors.transparent,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: t.brandFill,
        inactiveTrackColor: t.surface2,
        thumbColor: t.brandFill,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: t.bgSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: dark ? 0.5 : 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(color: t.borderLight),
        ),
        menuPadding: EdgeInsets.symmetric(vertical: 4.lx),
        position: PopupMenuPosition.under,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
              fontFamily: AppFonts.body, fontSize: 14.lx, color: t.textPrimary),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(t.bgSurface),
        side: WidgetStatePropertyAll(BorderSide(color: t.borderLight)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: radius)),
      ),
      dividerTheme: DividerThemeData(
        color: t.borderLight,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: t.textSecondary,
        textColor: t.textPrimary,
        titleTextStyle: TextStyle(
            fontFamily: AppFonts.body, fontSize: 14.lx, color: t.textPrimary),
        subtitleTextStyle: TextStyle(
            fontFamily: AppFonts.body, fontSize: 12.lx, color: t.textMuted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.bgSurface,
        modalBackgroundColor: t.bgSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: sheetRadius),
        dragHandleColor: t.borderMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.bgSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          side: BorderSide(color: t.borderLight),
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 17.lx,
          fontWeight: FontWeight.w700,
          color: t.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 13.5.lx,
          height: 1.45,
          color: t.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? t.surface3 : t.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 13.5.lx,
          color: dark ? t.textPrimary : t.bgSurface,
        ),
        actionTextColor: dark ? t.brandText : t.incomeSoft,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.bgPage,
        surfaceTintColor: Colors.transparent,
        foregroundColor: t.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 18.lx,
          fontWeight: FontWeight.w700,
          color: t.textPrimary,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: t.textPrimary,
        unselectedLabelColor: t.textMuted,
        indicatorColor: t.brandFill,
        dividerColor: t.borderLight,
        labelStyle: TextStyle(
            fontFamily: AppFonts.body,
            fontSize: 13.5.lx,
            fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            TextStyle(fontFamily: AppFonts.body, fontSize: 13.5.lx),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: t.bgSurface,
        selectedColor: t.surface2,
        side: BorderSide(color: t.borderLight),
        labelStyle: TextStyle(
            fontFamily: AppFonts.body, fontSize: 12.5.lx, color: t.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      cardTheme: CardThemeData(
        color: t.bgSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(color: t.borderLight),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: t.bgSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        headerBackgroundColor: t.bgSurface,
        headerForegroundColor: t.textPrimary,
        dividerColor: t.borderLight,
        rangePickerBackgroundColor: t.bgSurface,
        rangePickerHeaderBackgroundColor: t.bgSurface,
        rangePickerHeaderForegroundColor: t.textPrimary,
        rangeSelectionBackgroundColor: t.brandFill.withValues(alpha: 0.14),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onBrand : t.textPrimary,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.brandFill : null,
        ),
        todayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onBrand : t.brandText,
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.brandFill : null,
        ),
        todayBorder: BorderSide(color: t.brandFill),
        yearForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onBrand : t.textPrimary,
        ),
        yearBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.brandFill : null,
        ),
        cancelButtonStyle:
            TextButton.styleFrom(foregroundColor: t.textSecondary),
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: t.brandText),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: t.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        hourMinuteShape: RoundedRectangleBorder(borderRadius: radius),
        hourMinuteColor: WidgetStateColor.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.surface2 : t.bgPage,
        ),
        hourMinuteTextColor: t.textPrimary,
        dayPeriodShape: RoundedRectangleBorder(borderRadius: radius),
        dayPeriodBorderSide: BorderSide(color: t.borderMedium),
        dayPeriodColor: WidgetStateColor.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? t.surface2
              : Colors.transparent,
        ),
        dayPeriodTextColor: t.textPrimary,
        dialBackgroundColor: t.bgPage,
        dialHandColor: t.brandFill,
        dialTextColor: WidgetStateColor.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onBrand : t.textPrimary,
        ),
        entryModeIconColor: t.textMuted,
        cancelButtonStyle:
            TextButton.styleFrom(foregroundColor: t.textSecondary),
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: t.brandText),
      ),
    );
  }
}
