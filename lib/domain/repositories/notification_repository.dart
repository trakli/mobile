import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'dart:async';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getAllNotifications();
  Future<Either<Failure, Unit>> markAsRead(String clientId);
  Stream<Either<Failure, List<NotificationEntity>>> listenToNotifications();
}
