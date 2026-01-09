part of 'notification_preferences_cubit.dart';

@freezed
class NotificationPreferencesState with _$NotificationPreferencesState {
  const factory NotificationPreferencesState.initial() = _Initial;
  const factory NotificationPreferencesState.loading() = _Loading;
  const factory NotificationPreferencesState.loaded(
    NotificationPreferencesEntity preferences, {
    @Default(false) bool isSaving,
    @Default(Failure.none()) Failure failure,
  }) = _Loaded;
  const factory NotificationPreferencesState.error(Failure failure) = _Error;
}

extension NotificationPreferencesStateX on NotificationPreferencesState {
  bool get isLoading => this is _Loading;
  bool get isSaving => maybeWhen(
        loaded: (_, isSaving, __) => isSaving,
        orElse: () => false,
      );
  NotificationPreferencesEntity? get preferences => maybeWhen(
        loaded: (preferences, _, __) => preferences,
        orElse: () => null,
      );
  Failure get failure => maybeWhen(
        error: (failure) => failure,
        loaded: (_, __, failure) => failure,
        orElse: () => const Failure.none(),
      );
}
