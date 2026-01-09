import 'package:trakli/data/models/notification_preferences.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';

class NotificationPreferencesMapper {
  static NotificationPreferencesEntity toDomain(
    NotificationPreferences model,
  ) {
    return NotificationPreferencesEntity(
      channels: NotificationChannelsEntity(
        email: model.channels.email,
        push: model.channels.push,
        inapp: model.channels.inapp,
      ),
      types: NotificationTypesEntity(
        reminders: model.types.reminders,
        insights: model.types.insights,
        inactivity: model.types.inactivity,
      ),
    );
  }

  static NotificationPreferences toModel(
    NotificationPreferencesEntity entity,
  ) {
    return NotificationPreferences(
      channels: NotificationChannels(
        email: entity.channels.email,
        push: entity.channels.push,
        inapp: entity.channels.inapp,
      ),
      types: NotificationTypes(
        reminders: entity.types.reminders,
        insights: entity.types.insights,
        inactivity: entity.types.inactivity,
      ),
    );
  }
}
