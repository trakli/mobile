import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/exports/cubit/export_cubit.dart';
import 'package:trakli/presentation/utils/helpers.dart';

/// Reacts to an [ExportCubit] above it: once a file is ready it offers to save
/// or share it, and otherwise explains why the export failed or was refused.
class ExportResultListener extends StatelessWidget {
  final Widget child;

  const ExportResultListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportCubit, ExportState>(
      listenWhen: (previous, current) =>
          previous.file != current.file ||
          previous.failure != current.failure ||
          previous.blocker != current.blocker,
      listener: _onExportStateChanged,
      child: child,
    );
  }

  void _onExportStateChanged(BuildContext context, ExportState state) {
    if (state.file != null) {
      final file = state.file!;
      context.read<ExportCubit>().clearFile();
      _showExportActions(context, file);
      return;
    }

    if (state.failure.hasError) {
      showSnackBar(message: state.failure);
      return;
    }

    switch (state.blocker) {
      case ExportBlocker.signedOut:
        showSnackBar(message: LocaleKeys.exportRequiresAccount.tr());
      case ExportBlocker.pendingSync:
        showSnackBar(message: LocaleKeys.exportAwaitingSync.tr());
      case ExportBlocker.none:
        break;
    }
  }

  /// The file is ready; let the user decide whether it should be kept on the
  /// device or handed to another app.
  void _showExportActions(BuildContext context, ExportedFile file) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                file.name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(LocaleKeys.save.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _saveFile(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(LocaleKeys.share.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _shareFile(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareFile(ExportedFile file) {
    Share.shareXFiles([
      XFile.fromData(
        file.bytes,
        name: file.name,
        mimeType: file.mimeType,
      ),
    ], fileNameOverrides: [
      file.name
    ]);
  }

  /// Writes the export through the system file picker, so the user chooses
  /// where it lands and ends up with a copy they can find again.
  Future<void> _saveFile(ExportedFile file) async {
    try {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: LocaleKeys.export.tr(),
        fileName: file.name,
        bytes: file.bytes,
      );
      if (path == null) return;
      showSnackBar(
        message: LocaleKeys.exportSaved.tr(namedArgs: {'name': file.name}),
        isSuccess: true,
      );
    } catch (_) {
      showSnackBar(message: LocaleKeys.exportSaveFailed.tr());
    }
  }
}
