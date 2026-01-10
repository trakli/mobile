part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    required List<NotificationEntity> notifications,
    required bool isLoading,
    required bool isSaving,
    required Failure failure,
  }) = _NotificationState;

  factory NotificationState.initial() => const NotificationState(
        notifications: [],
        isLoading: false,
        isSaving: false,
        failure: Failure.none(),
      );
}
