import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';
import 'package:trakli/domain/repositories/notification_preferences_repository.dart';

class UpdateNotificationPreferencesParams {
  final NotificationPreferencesEntity preferences;

  UpdateNotificationPreferencesParams({required this.preferences});
}

@injectable
class UpdateNotificationPreferencesUseCase
    implements
        UseCase<NotificationPreferencesEntity,
            UpdateNotificationPreferencesParams> {
  final NotificationPreferencesRepository _repository;

  UpdateNotificationPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationPreferencesEntity>> call(
    UpdateNotificationPreferencesParams params,
  ) async {
    return await _repository.updatePreferences(params.preferences);
  }
}
