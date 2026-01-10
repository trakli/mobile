import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class NotificationLocalDataSource {
  Future<List<Notification>> getAllNotifications();
  Future<Notification?> getNotificationByClientId(String clientId);
  Future<Notification> markAsRead(String clientId, DateTime readAt);
  Stream<List<Notification>> listenToNotifications();
}

@Injectable(as: NotificationLocalDataSource)
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  NotificationLocalDataSourceImpl(this.database);
  final AppDatabase database;

  @override
  Future<List<Notification>> getAllNotifications() async {
    return (database.select(database.notifications)
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();
  }

  @override
  Future<Notification?> getNotificationByClientId(String clientId) async {
    return (database.select(database.notifications)
          ..where((n) => n.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  @override
  Future<Notification> markAsRead(String clientId, DateTime readAt) async {
    final now = DateTime.now();
    DateTime dateTime = formatServerIsoDateTime(now);

    final model = await (database.update(database.notifications)
          ..where((n) => n.clientId.equals(clientId)))
        .writeReturning(
      NotificationsCompanion(
        readAt: Value(readAt),
        updatedAt: Value(dateTime),
      ),
    );
    return model.first;
  }

  @override
  Stream<List<Notification>> listenToNotifications() {
    return (database.select(database.notifications)
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .watch();
  }
}
