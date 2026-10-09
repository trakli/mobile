import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_entity.freezed.dart';

/// What a streak counts. [serverKey] is the value the API sends.
enum StreakType {
  /// Recording a transaction. It counts on the day it reaches the server.
  transaction('transaction'),

  /// Reaching the server at all while signed in.
  checkIn('check_in');

  const StreakType(this.serverKey);

  final String serverKey;

  /// Null for a type this build does not know, so the row can be skipped.
  static StreakType? fromServerKey(String? key) =>
      StreakType.values.firstWhereOrNull((type) => type.serverKey == key);
}

/// The unit a streak is counted in. [serverKey] is the value the API sends.
enum StreakPeriod {
  daily('daily'),
  weekly('weekly');

  const StreakPeriod(this.serverKey);

  final String serverKey;

  /// Null for a period this build does not know, so the row can be skipped.
  static StreakPeriod? fromServerKey(String? key) =>
      StreakPeriod.values.firstWhereOrNull((period) => period.serverKey == key);
}

/// A run of consecutive days or weeks in which the user did [type].
///
/// The server counts in the user's own timezone and reports a [currentLength]
/// of zero once a period is missed, so the app shows the numbers as given.
@freezed
class StreakEntity with _$StreakEntity {
  const factory StreakEntity({
    required StreakType type,
    required StreakPeriod period,
    required int currentLength,
    required int longestLength,

    /// Long enough to celebrate (the server's threshold, three by default).
    required bool isRunning,
    DateTime? startedOn,
    DateTime? lastTrackedOn,
  }) = _StreakEntity;
}
