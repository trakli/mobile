import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/path_helper.dart';

/// Tile that displays a single attachment: image preview, PDF first-page
/// thumbnail, or file icon + name. Used in add-transaction form and transaction
/// details (e.g. bottom sheet media tab view).
///
/// [path] – logical path or filename (used for type detection and display name).
/// [loadedPath] – when set, the resolved file path for images (e.g. cached path).
/// [pdfThumbnailBytes] – pre-rendered first page of a PDF; when null and path is
///   PDF, show loading or file icon until parent provides bytes.
/// [isLoading] – show a loading indicator (e.g. while fetching server media).
/// [loadFailed] – show file icon when fetch failed.
/// [showRemoveButton] – show remove icon (e.g. in add-transaction form).
/// [onTap] – open full view (e.g. [ViewAttachmentScreen]); optional in read-only lists.
/// [onRemove] – remove attachment; required when [showRemoveButton] is true.
class AttachmentThumbnailTile extends StatelessWidget {
  const AttachmentThumbnailTile({
    super.key,
    required this.path,
    this.loadedPath,
    this.pdfThumbnailBytes,
    this.isLoading = false,
    this.loadFailed = false,
    this.showRemoveButton = false,
    this.accentColor,
    this.width,
    this.height,
    this.onTap,
    this.onRemove,
  });

  final String path;
  final String? loadedPath;
  final Uint8List? pdfThumbnailBytes;
  final bool isLoading;
  final bool loadFailed;
  final bool showRemoveButton;
  final Color? accentColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final w = width ?? 72.w;
    final h = height ?? 72.h;
    final file = File(path);
    final showPreviewFromFile = loadedPath == null &&
        !isLoading &&
        isImageAttachmentPath(path) &&
        file.existsSync();
    final showPreviewFromPath =
        loadedPath != null && isImageAttachmentPath(path);
    final showImagePreview = showPreviewFromFile || showPreviewFromPath;
    final isPdf = isPdfPath(path);
    final showPdfPreview = isPdf && pdfThumbnailBytes != null;
    final showThumbnail = showImagePreview || showPdfPreview;
    final pdfThumbnailLoading = isPdf && pdfThumbnailBytes == null;

    Widget content = GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: showThumbnail
              ? (showPdfPreview
                  ? Image.memory(
                      pdfThumbnailBytes!,
                      fit: BoxFit.cover,
                    )
                  : (loadedPath != null
                      ? Image.file(
                          File(loadedPath!),
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          file,
                          fit: BoxFit.cover,
                        )))
              : isLoading || pdfThumbnailLoading
                  ? Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconForAttachmentPath(path),
                            size: 28.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            displayNameForAttachmentPath(path, maxLength: 10),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );

    if (showRemoveButton && accentColor != null && onRemove != null) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            top: -6.h,
            right: -6.w,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 24.w,
                minHeight: 24.h,
              ),
              icon: Icon(
                Icons.cancel,
                size: 24.sp,
                color: accentColor,
              ),
              onPressed: onRemove,
            ),
          ),
        ],
      );
    }

    return content;
  }
}
