import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/imports/widgets/import_source_button.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DocumentScanScreen extends StatefulWidget {
  /// Optional file to pre-select (e.g. when launched from the AI composer
  /// after the user already picked a document).
  final File? initialFile;

  const DocumentScanScreen({super.key, this.initialFile});

  @override
  State<DocumentScanScreen> createState() => _DocumentScanScreenState();
}

class _DocumentScanScreenState extends State<DocumentScanScreen> {
  File? _picked;
  DocumentType _type = DocumentType.receipt;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialFile;
  }

  Future<void> _setFile(File? file) async {
    if (file == null) return;
    setState(() => _picked = file);
  }

  String _labelFor(DocumentType t) {
    return switch (t) {
      DocumentType.bankStatement => LocaleKeys.importDocBankStatement.tr(),
      DocumentType.receipt => LocaleKeys.importDocReceipt.tr(),
      DocumentType.invoice => LocaleKeys.importDocInvoice.tr(),
      DocumentType.payStub => LocaleKeys.importDocPayStub.tr(),
      DocumentType.utilityBill => LocaleKeys.importDocUtilityBill.tr(),
    };
  }

  Future<void> _analyze() async {
    if (_picked == null) return;
    final cubit = context.read<ImportCubit>();
    final session = await cubit.analyzeDocument(_picked!, _type);
    if (!mounted) return;
    if (session != null) {
      AppNavigator.pushReplacement(
        context,
        SuggestionReviewScreen(sessionId: session.id),
      );
    } else {
      showSnackBar(
        message: cubit.state.failure.customMessage,
        borderRadius: 8.r,
        backgroundColor: appDangerColor,
        isFloating: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.lx),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 4.lx),
            child: LedgerScreenBar(
              title: LocaleKeys.importScanDocument.tr(),
              leadingIcon: LucideIcons.x,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(14.lx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.importScanDocumentDesc.tr(),
                    style: TextStyle(
                      fontSize: 13.lx,
                      height: 1.45,
                      color: tones.textSecondary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  LedgerH6(LocaleKeys.importDocTypeLabel.tr()),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<DocumentType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      isDense: true,
                    ),
                    items: DocumentType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(_labelFor(t)),
                            ))
                        .toList(),
                    onChanged: state.isUploading
                        ? null
                        : (v) {
                            if (v != null) setState(() => _type = v);
                          },
                  ),
                  SizedBox(height: 20.h),
                  LedgerH6(LocaleKeys.importSourceLabel.tr()),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: LucideIcons.camera,
                    label: LocaleKeys.importSourceCamera.tr(),
                    subtitle: LocaleKeys.importSourceCameraDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async => _setFile(
                            await ImportFilePicker.captureFromCamera()),
                  ),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: LucideIcons.images,
                    label: LocaleKeys.importSourceGallery.tr(),
                    subtitle: LocaleKeys.importSourceGalleryDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async =>
                            _setFile(await ImportFilePicker.pickFromGallery()),
                  ),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: LucideIcons.folder,
                    label: LocaleKeys.importSourceFile.tr(),
                    subtitle: LocaleKeys.importSourceFileDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async =>
                            _setFile(await ImportFilePicker.pickDocument()),
                  ),
                  if (_picked != null) ...[
                    SizedBox(height: 12.h),
                    ImportFilePreview(
                      fileName: ImportFilePicker.displayName(_picked!.path),
                      onClear: state.isUploading
                          ? null
                          : () => setState(() => _picked = null),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  LedgerButton(
                    label: LocaleKeys.importAnalyze.tr(),
                    icon: LucideIcons.sparkles,
                    large: true,
                    busy: state.isUploading,
                    onPressed: (_picked == null || state.isUploading)
                        ? null
                        : _analyze,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
