import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item_tile.dart';

/// Horizontal list of [AttachmentListItemTile]s. Used by add-transaction form
/// and can be reused for transaction details (e.g. bottom sheet media tab).
class AttachmentListView extends StatelessWidget {
  const AttachmentListView({
    super.key,
    required this.items,
    this.showRemoveButton = false,
    this.accentColor,
    required this.onRemove,
  });

  final List<AttachmentListItem> items;
  final bool showRemoveButton;
  final Color? accentColor;
  final void Function(AttachmentListItem item) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, index) {
        final item = items[index];
        return AttachmentListItemTile(
          item: item,
          showRemoveButton: showRemoveButton,
          accentColor: accentColor,
          onRemove: () => onRemove(item),
        );
      },
    );
  }
}
