import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class GroupTile extends StatelessWidget {
  final GroupEntity group;

  const GroupTile({
    super.key,
    required this.group,
  });

  void _handleEdit(BuildContext context) {
    AppNavigator.push(
      context,
      AddGroupScreen(group: group),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: 'Delete Group',
        subTitle:
            'Are you sure you want to delete "${group.name}"? This action cannot be undone.',
        mainAction: () {
          context.read<GroupCubit>().deleteGroup(group.clientId);
          AppNavigator.pop(context);
        },
        secondaryAction: () {
          AppNavigator.pop(context);
        },
        mainActionText: "Delete",
        secondaryActionText: "Cancel",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ImageWidget(
              mediaEntity: group.icon,
              accentColor: accentColor,
              iconSize: 20.sp,
              emojiSize: 20.sp,
              placeholderIcon: Icons.groups_outlined,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (group.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    group.description!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: accentColor.withValues(alpha: 0.2),
            ),
            child: PopupMenuButton(
              icon: SvgPicture.asset(
                height: 20.h,
                width: 20.w,
                Assets.images.more,
                colorFilter: ColorFilter.mode(
                  accentColor,
                  BlendMode.srcIn,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => _handleEdit(context),
                    height: 40.h,
                    child: Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.edit2,
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => _showDeleteConfirmation(context),
                    height: 40.h,
                    child: Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withValues(alpha: 0.2),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.trash,
                            colorFilter: const ColorFilter.mode(
                              Colors.redAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
