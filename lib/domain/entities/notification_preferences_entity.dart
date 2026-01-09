import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences_entity.freezed.dart';

@freezed
class NotificationPreferencesEntity with _$NotificationPreferencesEntity {
  const factory NotificationPreferencesEntity({
    required NotificationChannelsEntity channels,
    required NotificationTypesEntity types,
  }) = _NotificationPreferencesEntity;
}

@freezed
class NotificationChannelsEntity with _$NotificationChannelsEntity {
  const factory NotificationChannelsEntity({
    @Default(true) bool email,
    @Default(true) bool push,
    @Default(true) bool inapp,
  }) = _NotificationChannelsEntity;
}

@freezed
class NotificationTypesEntity with _$NotificationTypesEntity {
  const factory NotificationTypesEntity({
    @Default(true) bool reminders,
    @Default(true) bool insights,
    @Default(true) bool inactivity,
  }) = _NotificationTypesEntity;
}
