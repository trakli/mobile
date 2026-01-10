import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/notification_entity.dart';

class NotificationMapper {
  static NotificationEntity toDomain(Notification n) {
    return NotificationEntity(
      id: n.id,
      clientId: n.clientId,
      type: n.type,
      title: n.title,
      body: n.body,
      data: n.data,
      readAt: n.readAt,
      createdAt: n.createdAt,
      userId: n.userId,
      updatedAt: n.updatedAt,
      lastSyncedAt: n.lastSyncedAt,
    );
  }

  static List<NotificationEntity> toDomainList(
      List<Notification> notifications) {
    return notifications.map((n) => toDomain(n)).toList();
  }
}
