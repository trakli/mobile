import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';
import 'package:trakli/domain/repositories/notification_preferences_repository.dart';

@injectable
class GetNotificationPreferencesUseCase
    implements UseCase<NotificationPreferencesEntity, NoParams> {
  final NotificationPreferencesRepository _repository;

  GetNotificationPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationPreferencesEntity>> call(
    NoParams params,
  ) async {
    return await _repository.getPreferences();
  }
}
