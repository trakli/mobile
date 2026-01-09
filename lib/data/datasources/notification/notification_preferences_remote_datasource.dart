import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/models/notification_preferences.dart';

abstract class NotificationPreferencesRemoteDataSource {
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  );
}

@Injectable(as: NotificationPreferencesRemoteDataSource)
class NotificationPreferencesRemoteDataSourceImpl
    implements NotificationPreferencesRemoteDataSource {
  final Dio dio;

  NotificationPreferencesRemoteDataSourceImpl({required this.dio});

  @override
  Future<NotificationPreferences> getPreferences() {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.get('notifications/preferences');
      final apiResponse = ApiResponse.fromJson(response.data);
      return NotificationPreferences.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) {
    return ErrorHandler.handleApiCall(() async {
      final response = await dio.put(
        'notifications/preferences',
        data: preferences.toJson(),
      );
      final apiResponse = ApiResponse.fromJson(response.data);
      return NotificationPreferences.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    });
  }
}
