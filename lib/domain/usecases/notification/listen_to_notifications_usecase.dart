import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/domain/repositories/notification_repository.dart';
import 'dart:async';

@injectable
class ListenToNotificationsUseCase
    implements StreamUseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  ListenToNotificationsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.listenToNotifications();
  }
}
