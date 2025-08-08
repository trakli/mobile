import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:popover/popover.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart' show PlanType, WalletType;
import 'package:trakli/presentation/utils/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

Future<File?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      withData: true,
    );
    if (result != null) {
      final fileSize = result.files.single.size;
      const maxSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxSize) {
        throw Exception(LocaleKeys.fileSizeExceedsLimit.tr());
      }
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  } catch (e) {
    rethrow;
  }
}

Future<void> openUrl({required String url}) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception(LocaleKeys.couldNotLaunchUrl.tr());
  }
}

void showLoader() {
  navigatorKey.currentContext?.loaderOverlay.show();
}

void hideLoader() {
  navigatorKey.currentContext?.loaderOverlay.hide();
}

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.emailEmptyDesc.tr();
  }
// Regular expression for email validation
  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return LocaleKeys.emailValidDesc.tr();
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.passEmptyDesc.tr();
  }
  return null;
}

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.firstName.tr();
  }
  return null;
}

void updateLanguage(BuildContext context, Locale locale) {
  context.setLocale(locale);
}

String getLanguageFromCode(Locale locale) {
  switch (locale.languageCode) {
    case "en":
      return LocaleKeys.langEnglish.tr();
    case "fr":
      return LocaleKeys.langFrench.tr();
    case "de":
      return LocaleKeys.langGerman.tr();
    case "es":
      return LocaleKeys.langSpanish.tr();
    case "it":
      return LocaleKeys.langItalian.tr();
    default:
      return locale.languageCode;
  }
}

String getFormDisplayText(String displayMode) {
  switch (displayMode) {
    case "full":
      return LocaleKeys.full.tr();
    case "compact":
      return LocaleKeys.compact.tr();
    default:
      return "";
  }
}

Widget flagWidget(Currency currency) {
  if (currency.flag == null) {
    return Image.asset(
      'no_flag.png'.imagePath, // Make sure you have this image
      package: 'currency_picker',
      width: 27,
    );
  }

  if (currency.isFlagImage) {
    return Image.asset(
      currency.flag!.imagePath,
      package: 'currency_picker',
      width: 27,
    );
  }

  return Text(
    CurrencyUtils.currencyToEmoji(currency),
    style: TextStyle(
      fontSize: 24.sp, // Or widget.theme?.flagSize ?? 25,
    ),
  );
}

extension StringExtensions on String {
  String get imagePath => 'lib/src/res/$this';
}

Future<T?> showCustomPopOver<T>(
  context, {
  required Widget widget,
  double? maxWidth,
}) async {
  return showPopover<T>(
    context: context,
    backgroundColor: Colors.white,
    transitionDuration: const Duration(milliseconds: 150),
    bodyBuilder: (context) => widget,
    direction: PopoverDirection.bottom,
    barrierColor: Colors.black.withAlpha(80),
    constraints: BoxConstraints(
      maxHeight: 0.6.sh,
      maxWidth: maxWidth ?? 0.4.sw,
    ),
    arrowHeight: 10.h,
    arrowWidth: 20.w,
  );
}

Future<T?> showCustomBottomSheet<T>(
  context, {
  required Widget widget,
  Color color = Colors.white,
  double maxHeightRatio = 1,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: color,
    scrollControlDisabledMaxHeightRatio: maxHeightRatio,
    builder: (context) {
      return widget;
    },
  );
}

Future<T?> showCustomDialog<T>({
  bool barrierDismissible = true,
  required Widget widget,
}) async {
  return showDialog<T>(
    context: scaffoldKey.currentContext!,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return widget;
    },
  );
}

Future<File?> pickImageApp({
  ImageSource sourcePick = ImageSource.gallery,
}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: sourcePick,
  );
  if (pickedFile != null) {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: LocaleKeys.cropper.tr(),
          toolbarColor: appPrimaryColor,
          activeControlsWidgetColor: appPrimaryColor,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: LocaleKeys.cropper.tr(),
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
  }
  return null;
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => LocaleKeys.cropAspectRatioCustom.tr();
}

void showSnackBar({
  required dynamic message,
  Color backgroundColor = const Color(0xFFEB5757),
  Color textColor = Colors.white,
  double fontSize = 16,
  bool isFloating = true,
  double? borderRadius,
}) {
  final String messageText =
      message is Failure ? message.customMessage : message.toString();

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      shape: borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              messageText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Icon(
              Icons.close,
              color: textColor,
              size: 18.sp,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget bulletPoint(String text) {
  return Row(
    spacing: 4.w,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "• ",
        style: TextStyle(fontSize: 16.sp),
      ),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.5.sp,
            color: neutralN700,
          ),
        ),
      ),
    ],
  );
}

getPlanType(String interval) {
  switch (interval) {
    case 'monthly':
      return PlanType.monthly;
    case 'yearly':
      return PlanType.yearly;
    default:
      return PlanType.monthly;
  }
}

/// Sets up default group and wallet with the given currency
/// This function is reusable across different parts of the app
Future<void> setupDefaultGroupAndWallet({
  required BuildContext context,
  required String currencyCode,
  String? groupName,
  String? walletName,
  String? walletDescription,
}) async {
  // if (!context.mounted) return;

  // Ensure default group exists
  context.read<GroupCubit>().ensureDefaultGroup(
        name: groupName ?? LocaleKeys.defaultGroupName.tr(),
      );

  // Check if context is still mounted before proceeding
  // Create default wallet with selected currency
  await context.read<WalletCubit>().ensureDefaultWallet(
        currencyCode: currencyCode,
        name: walletName ?? LocaleKeys.defaultWalletName.tr(),
        type: WalletType.cash,
        description:
            walletDescription ?? LocaleKeys.defaultWalletDescription.tr(),
      );
}

DateTime? getStartDateFromKey(String key) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  switch (key) {
    case LocaleKeys.thisWeek:
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      return startOfWeek;
    case LocaleKeys.thisMonth:
      return DateTime(today.year, today.month);
    case LocaleKeys.lastThreeMonths:
      return DateTime(today.year, today.month - 2);
    case LocaleKeys.lastSixMonths:
      return DateTime(today.year, today.month - 5);
    case LocaleKeys.thisYear:
      return DateTime(today.year);
    default:
      return null;
  }
}

bool matchTransactionDate(
  PickerDateRange? range,
  TransactionEntity transaction,
) {
  final txDate = transaction.datetime;
  final start = range?.startDate;
  final end = range?.endDate;

  if (start == null) return true;

  if (end == null) {
    return txDate.year == start.year &&
        txDate.month == start.month &&
        txDate.day == start.day;
  }

  return (txDate.isAtSameMomentAs(start) || txDate.isAfter(start)) &&
      (txDate.isAtSameMomentAs(end) || txDate.isBefore(end));
}
