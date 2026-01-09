import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences.g.dart';

@JsonSerializable()
class NotificationPreferences {
  final NotificationChannels channels;
  final NotificationTypes types;

  NotificationPreferences({
    required this.channels,
    required this.types,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);
}

@JsonSerializable()
class NotificationChannels {
  @JsonKey(defaultValue: true)
  final bool email;
  @JsonKey(defaultValue: true)
  final bool push;
  @JsonKey(defaultValue: true)
  final bool inapp;

  NotificationChannels({
    this.email = true,
    this.push = true,
    this.inapp = true,
  });

  factory NotificationChannels.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationChannelsToJson(this);
}

@JsonSerializable()
class NotificationTypes {
  @JsonKey(defaultValue: true)
  final bool reminders;
  @JsonKey(defaultValue: true)
  final bool insights;
  @JsonKey(defaultValue: true)
  final bool inactivity;

  NotificationTypes({
    this.reminders = true,
    this.insights = true,
    this.inactivity = true,
  });

  factory NotificationTypes.fromJson(Map<String, dynamic> json) =>
      _$NotificationTypesFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTypesToJson(this);
}
