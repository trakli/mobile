import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/notification_preferences_entity.dart';
import 'package:trakli/domain/usecases/notification_preferences/get_notification_preferences_usecase.dart';
import 'package:trakli/domain/usecases/notification_preferences/update_notification_preferences_usecase.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_cubit.freezed.dart';

@injectable
class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {
  final GetNotificationPreferencesUseCase _getPreferencesUseCase;
  final UpdateNotificationPreferencesUseCase _updatePreferencesUseCase;

  NotificationPreferencesCubit(
    this._getPreferencesUseCase,
    this._updatePreferencesUseCase,
  ) : super(const NotificationPreferencesState.initial()) {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    emit(const NotificationPreferencesState.loading());
    final result = await _getPreferencesUseCase(NoParams());
    result.fold(
      (failure) => emit(NotificationPreferencesState.error(failure)),
      (preferences) => emit(
        NotificationPreferencesState.loaded(preferences),
      ),
    );
  }

  Future<void> updateChannel({
    required bool email,
    required bool push,
    required bool inapp,
  }) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedChannels = currentPreferences.channels.copyWith(
      email: email,
      push: push,
      inapp: inapp,
    );

    await _updatePreferences(
      currentPreferences.copyWith(channels: updatedChannels),
    );
  }

  Future<void> updateType({
    required bool reminders,
    required bool insights,
    required bool inactivity,
  }) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedTypes = currentPreferences.types.copyWith(
      reminders: reminders,
      insights: insights,
      inactivity: inactivity,
    );

    await _updatePreferences(
      currentPreferences.copyWith(types: updatedTypes),
    );
  }

  Future<void> _updatePreferences(
    NotificationPreferencesEntity preferences,
  ) async {
    // Store previous preferences to revert on failure
    final previousPreferences = state.preferences;

    // Optimistically update UI (toggle changes immediately)
    emit(NotificationPreferencesState.loaded(
      preferences,
      isSaving: true,
    ));

    final result = await _updatePreferencesUseCase(
      UpdateNotificationPreferencesParams(preferences: preferences),
    );
    result.fold(
      (failure) {
        // Revert to previous state immediately on failure
        if (previousPreferences != null) {
          emit(NotificationPreferencesState.loaded(
            previousPreferences,
            isSaving: false,
            failure: failure,
          ));
        } else {
          // If no previous state, reload from server
          loadPreferences();
        }
      },
      (updatedPreferences) => emit(
        NotificationPreferencesState.loaded(
          updatedPreferences,
          isSaving: false,
        ),
      ),
    );
  }
}
