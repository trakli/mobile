import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/presentation/notifications/cubit/notification_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  static Color getTypeColor(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => appOrange,
      NotificationType.alert => appDangerColor,
      NotificationType.achievement => appYellow,
      NotificationType.system => appPrimaryColor,
    };
  }

  static String getTypeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => 'Reminder',
      NotificationType.alert => 'Alert',
      NotificationType.achievement => 'Achievement',
      NotificationType.system => 'System',
    };
  }

  static IconData getTypeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => Icons.schedule_outlined,
      NotificationType.alert => Icons.warning_amber_rounded,
      NotificationType.achievement => Icons.stars_rounded,
      NotificationType.system => Icons.info_outline,
    };
  }

  void _handleTap(BuildContext context) {
    final isRead = notification.readAt != null;
    if (!isRead) {
      context.read<NotificationCubit>().markAsRead(notification.clientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification.readAt != null;
    final typeColor = getTypeColor(notification.type);
    final typeLabel = getTypeLabel(notification.type);
    final iconData = getTypeIcon(notification.type);

    return InkWell(
      onTap: () => _handleTap(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: transactionTileBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                iconData,
                size: 24.r,
                color: typeColor,
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: appPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isRead ? Colors.grey.shade600 : neutralN900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isRead ? Colors.grey.shade500 : textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm')
                        .format(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
