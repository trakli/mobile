import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/core/sync/sync_entity.dart';

abstract class ReminderRemoteDataSource {
  Future<List<Reminder>> getAllReminders({
    DateTime? syncedSince,
    bool? noClientId,
  });
  Future<Reminder?> getReminder(int id);
  Future<Reminder> insertReminder(Reminder reminder);
  Future<Reminder> updateReminder(Reminder reminder);
  Future<Reminder> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  });
  Future<void> deleteReminder(int id);
  Future<void> snoozeReminder(int id, DateTime until);
  Future<void> pauseReminder(int id);
  Future<void> resumeReminder(int id);
}

@Injectable(as: ReminderRemoteDataSource)
class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final Dio dio;

  ReminderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Reminder>> getAllReminders({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    final allItems = <Reminder>[];
    int currentPage = 1;

    while (true) {
      final queryParams = <String, dynamic>{'page': currentPage};
      if (syncedSince != null) {
        queryParams['synced_since'] =
            formatServerIsoDateTimeString(syncedSince);
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }

      final response = await dio.get('reminders', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.lenient(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => Reminder.fromJson(
            JsonDefaultsHelper.addDefaults(json! as Map<String, dynamic>)),
        entityType: SyncEntity.reminder,
      );

      allItems.addAll(paginatedResponse.data);
      if (!paginatedResponse.hasMore) break;
      currentPage++;
    }

    return allItems;
  }

  @override
  Future<Reminder?> getReminder(int id) async {
    final response = await dio.get('reminders/$id');
    if (response.data == null) return null;
    final apiResponse = ApiResponse.fromJson(response.data);
    return Reminder.fromJson(apiResponse.data);
  }

  /// [forCreate] gates the two fields only `POST /reminders` accepts:
  /// created_at, and the client id — see [claimClientId] for repointing it.
  Map<String, dynamic> _writeData(Reminder r, {bool forCreate = false}) {
    return {
      'title': r.title,
      if (forCreate) 'client_id': r.clientId,
      if (r.description != null) 'description': r.description,
      'type': r.type,
      if (r.triggerAt != null)
        'trigger_at': formatServerIsoDateTimeString(r.triggerAt!),
      if (r.dueAt != null) 'due_at': formatServerIsoDateTimeString(r.dueAt!),
      'repeat_rule': r.repeatRule,
      if (r.timezone != null) 'timezone': r.timezone,
      'priority': r.priority,
      if (forCreate) 'created_at': formatServerIsoDateTimeString(r.createdAt),
    };
  }

  @override
  Future<Reminder> insertReminder(Reminder reminder) async {
    final response = await dio.post(
      'reminders',
      data: _writeData(reminder, forCreate: true),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return Reminder.fromJson(apiResponse.data);
  }

  @override
  Future<Reminder> updateReminder(Reminder reminder) async {
    final response = await dio.put(
      'reminders/${reminder.id}',
      data: _writeData(reminder),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return Reminder.fromJson(apiResponse.data);
  }

  @override
  Future<Reminder> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  }) async {
    final response = await dio.put('reminders/$id', data: {
      'client_id': clientId,
      'updated_at': formatServerIsoDateTimeString(updatedAt),
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Reminder.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteReminder(int id) async {
    await dio.delete('reminders/$id');
  }

  @override
  Future<void> snoozeReminder(int id, DateTime until) async {
    await dio.post(
      'reminders/$id/snooze',
      data: {'until': formatServerIsoDateTimeString(until)},
    );
  }

  @override
  Future<void> pauseReminder(int id) async {
    await dio.post('reminders/$id/pause');
  }

  @override
  Future<void> resumeReminder(int id) async {
    await dio.post('reminders/$id/resume');
  }
}
