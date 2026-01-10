import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'notification_entity.freezed.dart';

@freezed
class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String clientId,
    required NotificationType type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    DateTime? readAt,
    required DateTime createdAt,
    int? id,
    int? userId,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
  }) = _NotificationEntity;
}
