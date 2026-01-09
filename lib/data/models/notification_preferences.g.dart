// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferences _$NotificationPreferencesFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferences(
      channels: NotificationChannels.fromJson(
          json['channels'] as Map<String, dynamic>),
      types: NotificationTypes.fromJson(json['types'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'channels': instance.channels.toJson(),
      'types': instance.types.toJson(),
    };

NotificationChannels _$NotificationChannelsFromJson(
        Map<String, dynamic> json) =>
    NotificationChannels(
      email: json['email'] as bool? ?? true,
      push: json['push'] as bool? ?? true,
      inapp: json['inapp'] as bool? ?? true,
    );

Map<String, dynamic> _$NotificationChannelsToJson(
        NotificationChannels instance) =>
    <String, dynamic>{
      'email': instance.email,
      'push': instance.push,
      'inapp': instance.inapp,
    };

NotificationTypes _$NotificationTypesFromJson(Map<String, dynamic> json) =>
    NotificationTypes(
      reminders: json['reminders'] as bool? ?? true,
      insights: json['insights'] as bool? ?? true,
      inactivity: json['inactivity'] as bool? ?? true,
    );

Map<String, dynamic> _$NotificationTypesToJson(NotificationTypes instance) =>
    <String, dynamic>{
      'reminders': instance.reminders,
      'insights': instance.insights,
      'inactivity': instance.inactivity,
    };
