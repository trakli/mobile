import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/notification/notification_preferences_local_datasource.dart';
import 'package:trakli/data/datasources/notification/notification_preferences_remote_datasource.dart';
import 'package:trakli/data/mappers/notification_preferences_mapper.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';
import 'package:trakli/domain/repositories/notification_preferences_repository.dart';

@LazySingleton(as: NotificationPreferencesRepository)
class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  final NotificationPreferencesRemoteDataSource _remoteDataSource;
  final NotificationPreferencesLocalDataSource _localDataSource;

  NotificationPreferencesRepositoryImpl({
    required NotificationPreferencesRemoteDataSource remoteDataSource,
    required NotificationPreferencesLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, NotificationPreferencesEntity>> getPreferences() {
    return RepositoryErrorHandler.handleApiCall(() async {
      // Try to get from local cache first (for offline support)
      final localModel = await _localDataSource.getPreferences();
      if (localModel != null) {
        // Return cached data immediately, but also try to refresh in background
        _refreshPreferencesInBackground();
        return NotificationPreferencesMapper.toDomain(localModel);
      }

      final remoteModel = await _remoteDataSource.getPreferences();
      // Save to local cache for offline access
      await _localDataSource.savePreferences(remoteModel);
      return NotificationPreferencesMapper.toDomain(remoteModel);
    });
  }

  /// Refreshes preferences from remote in the background
  /// This allows showing cached data immediately while updating in background
  void _refreshPreferencesInBackground() {
    _remoteDataSource.getPreferences().then((remoteModel) {
      _localDataSource.savePreferences(remoteModel);
    }).catchError((_) {
      // Silently fail background refresh - cached data is still valid
    });
  }

  @override
  Future<Either<Failure, NotificationPreferencesEntity>> updatePreferences(
    NotificationPreferencesEntity preferences,
  ) {
    return RepositoryErrorHandler.handleApiCall(() async {
      // Update remote first (as requested)
      final model = NotificationPreferencesMapper.toModel(preferences);
      final updatedModel = await _remoteDataSource.updatePreferences(model);

      // Only save locally after successful remote update
      await _localDataSource.savePreferences(updatedModel);

      return NotificationPreferencesMapper.toDomain(updatedModel);
    });
  }
}
