import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';

abstract class NotificationPreferencesRepository {
  Future<Either<Failure, NotificationPreferencesEntity>> getPreferences();
  Future<Either<Failure, NotificationPreferencesEntity>> updatePreferences(
    NotificationPreferencesEntity preferences,
  );
}
