import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

/// Full-screen viewer for transaction attachments.
/// Pass [filePath] for a local file, or [bytes] + [fileExtension] for content from the server.
class ViewAttachmentScreen extends StatefulWidget {
  final String? filePath;
  final Uint8List? bytes;
  final String? fileExtension;

  const ViewAttachmentScreen({
    super.key,
    this.filePath,
    this.bytes,
    this.fileExtension,
  }) : assert(
          (filePath != null) || (bytes != null && fileExtension != null),
          'Provide either filePath or bytes + fileExtension',
        );

  @override
  State<ViewAttachmentScreen> createState() => _ViewAttachmentScreenState();
}

class _ViewAttachmentScreenState extends State<ViewAttachmentScreen> {
  PdfControllerPinch? _pdfController;

  String get _ext {
    if (widget.fileExtension != null && widget.fileExtension!.isNotEmpty) {
      return widget.fileExtension!.toLowerCase();
    }
    if (widget.filePath != null && widget.filePath!.contains('.')) {
      return widget.filePath!.split('.').last.toLowerCase();
    }
    return 'bin';
  }

  bool get _isImage =>
      _ext == 'png' ||
      _ext == 'jpg' ||
      _ext == 'jpeg' ||
      _ext == 'gif' ||
      _ext == 'webp';

  bool get _isPdf => _ext == 'pdf';

  @override
  void initState() {
    super.initState();
    if (_isPdf) {
      if (widget.filePath != null) {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openFile(widget.filePath!),
        );
      } else if (widget.bytes != null && widget.bytes!.isNotEmpty) {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openData(widget.bytes!),
        );
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  /// Detects file extension and MIME type from content (magic bytes).
  static String? _detectMimeFromBytes(Uint8List bytes) {
    if (bytes.length < 4) return null;
    // PDF: %PDF
    if (bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return 'application/pdf';
    }
    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return 'image/jpeg';
    }
    // PNG: 89 50 4E 47 0D 0A 1A 0A
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    // GIF: GIF87a or GIF89a
    if (bytes.length >= 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46) {
      return 'image/gif';
    }
    return null;
  }

  static const Map<String, String> _extToMime = {
    'pdf': 'application/pdf',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

  static String _extFromMime(String? mime) {
    if (mime == null) return 'bin';
    for (final e in _extToMime.entries) {
      if (e.value == mime) return e.key;
    }
    return 'bin';
  }

  Future<void> _share() async {
    if (widget.filePath != null) {
      final file = File(widget.filePath!);
      if (file.existsSync()) {
        await Share.shareXFiles([XFile(widget.filePath!)]);
        return;
      }
    }
    if (widget.bytes != null && widget.bytes!.isNotEmpty) {
      String ext = _ext;
      if (ext == 'bin') {
        final mime = _detectMimeFromBytes(widget.bytes!);
        ext = _extFromMime(mime);
      }
      final mime = _extToMime[ext] ?? _detectMimeFromBytes(widget.bytes!);
      final xFile = XFile.fromData(
        widget.bytes!,
        name: 'attachment.$ext',
        mimeType: mime,
      );
      await Share.shareXFiles([xFile]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        leading: const CustomBackButton(),
        titleText: LocaleKeys.attachment.tr(),
        backgroundColor: Colors.black,
        headerTextColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            color: Colors.white,
            onPressed: _share,
            tooltip: LocaleKeys.share.tr(),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.filePath != null) {
      final file = File(widget.filePath!);
      if (!file.existsSync()) {
        return Center(
          child: Text(
            LocaleKeys.fileNotFound.tr(),
            style: TextStyle(color: Colors.white70, fontSize: 16.sp),
          ),
        );
      }
      if (_isImage) {
        return Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              file,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _fallbackContent(context),
            ),
          ),
        );
      }
      if (_isPdf && _pdfController != null) {
        return _buildPdfView();
      }
      if (_isPdf) {
        return _pdfError(context);
      }
      return _fallbackContent(context);
    }

    // bytes from server
    if (widget.bytes == null || widget.bytes!.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.noContent.tr(),
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
      );
    }
    if (_isImage) {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.memory(
            widget.bytes!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _fallbackContent(context),
          ),
        ),
      );
    }
    if (_isPdf && _pdfController != null) {
      return _buildPdfView();
    }
    if (_isPdf) {
      return _pdfError(context);
    }
    return _fallbackContent(context);
  }

  Widget _buildPdfView() {
    return PdfViewPinch(
      controller: _pdfController!,
      scrollDirection: Axis.vertical,
    );
  }

  Widget _pdfError(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.couldNotLoadPdf.tr(),
        style: TextStyle(color: Colors.white70, fontSize: 16.sp),
      ),
    );
  }

  Widget _fallbackContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 64.sp, color: Colors.white54),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.previewNotAvailable.tr(),
            style: TextStyle(color: Colors.white70, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
