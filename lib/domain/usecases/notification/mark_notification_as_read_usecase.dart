import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/notification_repository.dart';

part 'mark_notification_as_read_usecase.freezed.dart';

@freezed
class MarkNotificationAsReadParams with _$MarkNotificationAsReadParams {
  const factory MarkNotificationAsReadParams({
    required String clientId,
  }) = _MarkNotificationAsReadParams;
}

@injectable
class MarkNotificationAsReadUseCase
    implements UseCase<Unit, MarkNotificationAsReadParams> {
  final NotificationRepository _repository;

  MarkNotificationAsReadUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(
      MarkNotificationAsReadParams params) async {
    return await _repository.markAsRead(params.clientId);
  }
}
