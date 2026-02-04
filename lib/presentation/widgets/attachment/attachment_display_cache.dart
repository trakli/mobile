import 'dart:typed_data';

import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/helpers.dart';

/// Static cache for resolved file paths and PDF thumbnails so multiple tiles
/// for the same id/path don't refetch. Used by [AttachmentListItemTile].
class AttachmentDisplayCache {
  AttachmentDisplayCache._();

  static final Map<int, String> _loadedPaths = {};
  static final Set<int> _failedIds = {};
  static final Map<String, Uint8List> _pdfThumbnails = {};

  static String? getLoadedPath(int id) => _loadedPaths[id];
  static bool isFailed(int id) => _failedIds.contains(id);
  static Uint8List? getPdfThumbnail(String path) => _pdfThumbnails[path];

  /// Loads file content for [mediaId] via [cubit], stores result, then calls [onUpdated].
  static Future<void> loadContent(
    int mediaId,
    TransactionCubit cubit,
    void Function() onUpdated,
  ) async {
    if (_loadedPaths.containsKey(mediaId) || _failedIds.contains(mediaId)) {
      return;
    }

    final result = await cubit.getFileContent(mediaId);
    result.fold(
      (_) {
        _failedIds.add(mediaId);
        onUpdated();
      },
      (path) {
        _loadedPaths[mediaId] = path;
        _failedIds.remove(mediaId);
        onUpdated();
      },
    );
  }

  /// Loads PDF first-page thumbnail for [path]. Uses [filePath] for rendering if set
  /// (e.g. resolved path for server media); otherwise uses [path]. Calls [onUpdated] when done.
  static Future<void> loadPdfThumb(
    String path,
    void Function() onUpdated, {
    String? filePath,
  }) async {
    if (_pdfThumbnails.containsKey(path)) return;
    final resolvedPath = filePath ?? path;
    final thumb = await renderPdfFirstPageThumbnail(
      filePath: resolvedPath,
      bytes: null,
      size: 144,
    );
    if (thumb != null) {
      _pdfThumbnails[path] = thumb;
    }
    onUpdated();
  }

  static void clear() {
    _loadedPaths.clear();
    _failedIds.clear();
    _pdfThumbnails.clear();
  }
}
