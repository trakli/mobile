import 'package:trakli/domain/entities/streak_entity.dart';

/// Wire shape of a row from `GET /streaks`.
class StreakDto {
  final String type;
  final String period;
  final int currentLength;
  final int longestLength;
  final bool isRunning;
  final DateTime? startedOn;
  final DateTime? lastTrackedOn;

  const StreakDto({
    required this.type,
    required this.period,
    required this.currentLength,
    required this.longestLength,
    required this.isRunning,
    this.startedOn,
    this.lastTrackedOn,
  });

  // The dates are plain `Y-m-d` days already in the user's timezone, so they
  // parse as local midnight and need no conversion.
  factory StreakDto.fromJson(Map<String, dynamic> json) => StreakDto(
        type: json['type'] as String? ?? '',
        period: json['period'] as String? ?? '',
        currentLength: (json['current_length'] as num?)?.toInt() ?? 0,
        longestLength: (json['longest_length'] as num?)?.toInt() ?? 0,
        isRunning: json['is_running'] as bool? ?? false,
        startedOn: DateTime.tryParse(json['started_on'] as String? ?? ''),
        lastTrackedOn:
            DateTime.tryParse(json['last_tracked_on'] as String? ?? ''),
      );

  /// Null when the server sends a type or period this build cannot show.
  StreakEntity? toEntity() {
    final streakType = StreakType.fromServerKey(type);
    final streakPeriod = StreakPeriod.fromServerKey(period);
    if (streakType == null || streakPeriod == null) return null;

    return StreakEntity(
      type: streakType,
      period: streakPeriod,
      currentLength: currentLength,
      longestLength: longestLength,
      isRunning: isRunning,
      startedOn: startedOn,
      lastTrackedOn: lastTrackedOn,
    );
  }
}
