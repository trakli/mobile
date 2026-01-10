import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:trakli/domain/usecases/notification/listen_to_notifications_usecase.dart';
import 'package:trakli/domain/usecases/notification/mark_notification_as_read_usecase.dart';

part 'notification_cubit.freezed.dart';
part 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markAsReadUseCase;
  final ListenToNotificationsUseCase listenToNotificationsUseCase;
  StreamSubscription? _notificationsSubscription;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._markAsReadUseCase,
    this.listenToNotificationsUseCase,
  ) : super(NotificationState.initial()) {
    listenToNotifications();
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getNotificationsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (notifications) => emit(state.copyWith(
        isLoading: false,
        notifications: notifications,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> markAsRead(String clientId) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _markAsReadUseCase(
      MarkNotificationAsReadParams(clientId: clientId),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) {
        emit(state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ));
        loadNotifications();
      },
    );
  }

  void listenToNotifications() {
    _notificationsSubscription?.cancel();
    _notificationsSubscription =
        listenToNotificationsUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (notifications) => emit(state.copyWith(
          notifications: notifications,
          failure: const Failure.none(),
        )),
      ),
    );
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
