import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/notifications/cubit/notification_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  static Color getTypeColor(NotificationType type, AppTones tones) {
    return switch (type) {
      NotificationType.reminder => tones.accentWarm,
      NotificationType.alert => tones.expenseColor,
      NotificationType.achievement => tones.accentWarm,
      NotificationType.system => tones.brandText,
    };
  }

  static String getTypeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => LocaleKeys.notificationTypeReminder.tr(),
      NotificationType.alert => LocaleKeys.notificationTypeAlert.tr(),
      NotificationType.achievement =>
        LocaleKeys.notificationTypeAchievement.tr(),
      NotificationType.system => LocaleKeys.notificationTypeSystem.tr(),
    };
  }

  static IconData getTypeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.reminder => LucideIcons.alarmClock,
      NotificationType.alert => LucideIcons.triangleAlert,
      NotificationType.achievement => LucideIcons.award,
      NotificationType.system => LucideIcons.info,
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
    final t = context.tones;
    final isRead = notification.readAt != null;
    final typeColor = getTypeColor(notification.type, t);
    return InkWell(
      onTap: () => _handleTap(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.lx),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LedgerCoin(
              icon: getTypeIcon(notification.type),
              foreground: typeColor,
            ),
            SizedBox(width: 10.lx),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.lx,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w600,
                            color: isRead ? t.textSecondary : t.textPrimary,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 7.lx,
                          height: 7.lx,
                          margin: EdgeInsets.only(left: 6.lx),
                          decoration: BoxDecoration(
                            color: t.brandFill,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.lx),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.5.lx,
                      height: 1.4,
                      color: isRead ? t.textMuted : t.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.lx),
                  Text(
                    '${getTypeLabel(notification.type)} · '
                    '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_Hm().format(notification.createdAt)}',
                    style: LedgerText.money(size: 10.5.lx, color: t.textMuted),
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
