part of 'streak_cubit.dart';

@freezed
class StreakState with _$StreakState {
  const StreakState._();

  const factory StreakState({
    required List<StreakEntity> streaks,
    required bool isLoading,

    /// Why the last refresh failed. Not shown: the streak is a nicety, and the
    /// last good answer stays on screen.
    required Failure failure,
  }) = _StreakState;

  factory StreakState.initial() => const StreakState(
        streaks: [],
        isLoading: false,
        failure: Failure.none(),
      );

  StreakEntity? streakFor(StreakType type, StreakPeriod period) =>
      streaks.firstWhereOrNull(
        (streak) => streak.type == type && streak.period == period,
      );
}
