import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialog) => PopUpDialog(
      title: title,
      subTitle: message,
      dialogType: DialogType.negative,
      mainActionText: LocaleKeys.delete.tr(),
      mainAction: () => Navigator.of(dialog).pop(true),
      secondaryAction: () => Navigator.of(dialog).pop(false),
    ),
  );
  return result ?? false;
}

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  Color? confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialog) => PopUpDialog(
      title: title,
      subTitle: message,
      accentColor: confirmColor,
      mainActionText: confirmText,
      mainAction: () => Navigator.of(dialog).pop(true),
      secondaryAction: () => Navigator.of(dialog).pop(false),
    ),
  );
  return result ?? false;
}
