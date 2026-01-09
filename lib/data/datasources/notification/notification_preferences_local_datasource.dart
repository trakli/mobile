import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/data/models/notification_preferences.dart';

abstract class NotificationPreferencesLocalDataSource {
  Future<NotificationPreferences?> getPreferences();
  Future<void> savePreferences(NotificationPreferences preferences);
  Future<void> clearPreferences();
}

@Injectable(as: NotificationPreferencesLocalDataSource)
class NotificationPreferencesLocalDataSourceImpl
    implements NotificationPreferencesLocalDataSource {
  static const String _preferencesKey = 'notification_preferences';

  NotificationPreferencesLocalDataSourceImpl();

  @override
  Future<NotificationPreferences?> getPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_preferencesKey);
      if (preferencesJson == null) {
        return null;
      }
      final json = jsonDecode(preferencesJson) as Map<String, dynamic>;
      return NotificationPreferences.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> savePreferences(NotificationPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(preferences.toJson());
    await prefs.setString(_preferencesKey, jsonString);
  }

  @override
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_preferencesKey);
  }
}
