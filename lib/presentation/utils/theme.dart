import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/colors.dart';

final lightTheme = ThemeData(
  primaryColor: const Color(0xFF047844),
  primaryColorLight: const Color(0xFFDFE1E4),
  primaryColorDark: const Color(0xFF1E2448),
  hintColor: const Color(0xFFF7B600),
  scaffoldBackgroundColor: const Color(0xFFEBEDEC),
  // brightness: Theme.of(context).brightness,
  useMaterial3: true,
  datePickerTheme: DatePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    headerBackgroundColor: const Color(0xFF047844),
    headerForegroundColor: Colors.white,
    todayBackgroundColor: WidgetStatePropertyAll(appPrimaryColor),
    todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    backgroundColor: Colors.white,
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    dayPeriodColor: appPrimaryColor.withAlpha(50),
    dayPeriodBorderSide: BorderSide(
      color: Colors.grey.shade500,
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    dialHandColor: appPrimaryColor,
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      color: textColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
        ),
      ),
      backgroundColor: const WidgetStatePropertyAll(
        Color(0xFF047844),
      ),
      foregroundColor: const WidgetStatePropertyAll(
        Colors.white,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: 32.0.w,
          vertical: 12.h,
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      iconSize: 12.sp,
      foregroundColor: textColor,
      textStyle: TextStyle(
        fontSize: 10.sp,
        color: neutralN900,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      side: BorderSide(
        color: appPrimaryColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 12.h,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF5F6F7),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 12.h,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(
        color: Color(0xFF047844),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    ),
    floatingLabelStyle: TextStyle(
      color: appPrimaryColor,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      foregroundColor: appPrimaryColor,
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
      side: const BorderSide(
        color: Color(0xFFE6E8E9),
      ),
    ),
    menuPadding: EdgeInsets.symmetric(
      vertical: 8.h,
      horizontal: 0,
    ),
    position: PopupMenuPosition.under,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 14.sp,
        color: const Color(0XFF00171F),
      ),
    ),
  ),
  searchBarTheme: SearchBarThemeData(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),
  ),
);