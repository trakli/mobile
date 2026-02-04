import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/view_attachment_screen.dart';
import 'package:trakli/presentation/utils/path_helper.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_display_cache.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_thumbnail_tile.dart';

/// Stateful tile that takes an [AttachmentListItem], loads content/PDF thumb via
/// [AttachmentDisplayCache], and delegates display to [AttachmentThumbnailTile].
/// Handles onTap (navigate to [ViewAttachmentScreen]); parent provides [onRemove].
class AttachmentListItemTile extends StatefulWidget {
  const AttachmentListItemTile({
    super.key,
    required this.item,
    this.showRemoveButton = false,
    this.accentColor,
    this.onRemove,
  });

  final AttachmentListItem item;
  final bool showRemoveButton;
  final Color? accentColor;
  final VoidCallback? onRemove;

  @override
  State<AttachmentListItemTile> createState() => _AttachmentListItemTileState();
}

class _AttachmentListItemTileState extends State<AttachmentListItemTile> {
  @override
  void initState() {
    super.initState();
    _triggerLoads();
  }

  @override
  void didUpdateWidget(AttachmentListItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) _triggerLoads();
  }

  void _triggerLoads() {
    final item = widget.item;
    final cubit = context.read<TransactionCubit>();

    switch (item) {
      case ExistingAttachment(media: final m):
        if (m.id != null) {
          AttachmentDisplayCache.loadContent(
            m.id!,
            cubit,
            () {
              if (mounted) {
                setState(() {});
                if (isPdfPath(m.path)) {
                  final filePath = AttachmentDisplayCache.getLoadedPath(m.id!);
                  AttachmentDisplayCache.loadPdfThumb(
                    m.path,
                    () => mounted ? setState(() {}) : () {},
                    filePath: filePath ?? m.path,
                  );
                }
              }
            },
          );
        } else if (isPdfPath(m.path)) {
          AttachmentDisplayCache.loadPdfThumb(
            m.path,
            () => mounted ? setState(() {}) : () {},
          );
        }
        break;
      case NewLocalAttachment(path: final p):
        if (isPdfPath(p)) {
          AttachmentDisplayCache.loadPdfThumb(
            p,
            () => mounted ? setState(() {}) : () {},
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final path = item.path;
    final mediaId = item.mediaId;

    String? loadedPath;
    bool loadFailed = false;
    bool isLoading = false;

    if (mediaId != null) {
      loadedPath = AttachmentDisplayCache.getLoadedPath(mediaId);
      loadFailed = AttachmentDisplayCache.isFailed(mediaId);
      isLoading = loadedPath == null && !loadFailed;
    }

    final pdfThumbnail =
        isPdfPath(path) ? AttachmentDisplayCache.getPdfThumbnail(path) : null;

    return AttachmentThumbnailTile(
      path: path,
      loadedPath: loadedPath,
      pdfThumbnailBytes: pdfThumbnail,
      isLoading: isLoading,
      loadFailed: loadFailed,
      showRemoveButton: widget.showRemoveButton,
      accentColor: widget.accentColor,
      onTap: () => _onTap(context, item),
      onRemove: widget.onRemove,
    );
  }

  Future<void> _onTap(BuildContext context, AttachmentListItem item) async {
    switch (item) {
      case ExistingAttachment(media: final m):
        if (m.id != null) {
          final path = AttachmentDisplayCache.getLoadedPath(m.id!);
          if (path != null) {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ViewAttachmentScreen(filePath: path),
              ),
            );
          } else {
            final cubit = context.read<TransactionCubit>();
            final result = await cubit.getFileContent(m.id!);
            if (!context.mounted) return;
            result.fold(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.couldNotLoadAttachment.tr()),
                ),
              ),
              (filePath) => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ViewAttachmentScreen(filePath: filePath),
                ),
              ),
            );
          }
        } else {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ViewAttachmentScreen(filePath: m.path),
            ),
          );
        }
        break;
      case NewLocalAttachment(path: final p):
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ViewAttachmentScreen(filePath: p),
          ),
        );
        break;
    }
  }
}
