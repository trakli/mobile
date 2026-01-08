import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/core/api_response.dart';

class NotificationPreferences {
  final NotificationChannels channels;
  final NotificationTypes types;

  NotificationPreferences({
    required this.channels,
    required this.types,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      channels: NotificationChannels.fromJson(
        json['channels'] as Map<String, dynamic>? ?? {},
      ),
      types: NotificationTypes.fromJson(
        json['types'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channels': channels.toJson(),
      'types': types.toJson(),
    };
  }

  NotificationPreferences copyWith({
    NotificationChannels? channels,
    NotificationTypes? types,
  }) {
    return NotificationPreferences(
      channels: channels ?? this.channels,
      types: types ?? this.types,
    );
  }
}

class NotificationChannels {
  final bool email;
  final bool push;
  final bool inapp;

  NotificationChannels({
    this.email = true,
    this.push = true,
    this.inapp = true,
  });

  factory NotificationChannels.fromJson(Map<String, dynamic> json) {
    return NotificationChannels(
      email: json['email'] as bool? ?? true,
      push: json['push'] as bool? ?? true,
      inapp: json['inapp'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'push': push,
      'inapp': inapp,
    };
  }

  NotificationChannels copyWith({
    bool? email,
    bool? push,
    bool? inapp,
  }) {
    return NotificationChannels(
      email: email ?? this.email,
      push: push ?? this.push,
      inapp: inapp ?? this.inapp,
    );
  }
}

class NotificationTypes {
  final bool reminders;
  final bool insights;
  final bool inactivity;

  NotificationTypes({
    this.reminders = true,
    this.insights = true,
    this.inactivity = true,
  });

  factory NotificationTypes.fromJson(Map<String, dynamic> json) {
    return NotificationTypes(
      reminders: json['reminders'] as bool? ?? true,
      insights: json['insights'] as bool? ?? true,
      inactivity: json['inactivity'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminders': reminders,
      'insights': insights,
      'inactivity': inactivity,
    };
  }

  NotificationTypes copyWith({
    bool? reminders,
    bool? insights,
    bool? inactivity,
  }) {
    return NotificationTypes(
      reminders: reminders ?? this.reminders,
      insights: insights ?? this.insights,
      inactivity: inactivity ?? this.inactivity,
    );
  }
}

abstract class NotificationPreferencesRemoteDataSource {
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(
      NotificationPreferences preferences);
}

@Injectable(as: NotificationPreferencesRemoteDataSource)
class NotificationPreferencesRemoteDataSourceImpl
    implements NotificationPreferencesRemoteDataSource {
  final Dio dio;

  NotificationPreferencesRemoteDataSourceImpl({required this.dio});

  @override
  Future<NotificationPreferences> getPreferences() async {
    final response = await dio.get('notifications/preferences');
    final apiResponse = ApiResponse.fromJson(response.data);
    return NotificationPreferences.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    final response = await dio.put(
      'notifications/preferences',
      data: preferences.toJson(),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return NotificationPreferences.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }
}
