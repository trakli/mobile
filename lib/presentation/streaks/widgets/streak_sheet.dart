import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Every streak the user has: tracking and checking in, each by day and by
/// week, with the current run beside the best one.
class StreakSheet extends StatelessWidget {
  final List<StreakEntity> streaks;

  const StreakSheet({super.key, required this.streaks});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.streaksTitle.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              LocaleKeys.streaksHint.tr(),
              style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
            ),
            for (final type in StreakType.values) ...[
              SizedBox(height: 16.h),
              Text(
                switch (type) {
                  StreakType.transaction => LocaleKeys.streakTracking.tr(),
                  StreakType.checkIn => LocaleKeys.streakCheckIn.tr(),
                },
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                spacing: 8.w,
                children: [
                  for (final period in StreakPeriod.values)
                    Expanded(
                      child: _StreakTile(
                        period: period,
                        streak: streaks.firstWhereOrNull(
                          (streak) =>
                              streak.type == type && streak.period == period,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  final StreakPeriod period;

  /// Null when the user has never done this, which reads as a zero streak.
  final StreakEntity? streak;

  const _StreakTile({required this.period, required this.streak});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final isRunning = streak?.isRunning ?? false;
    final color = isRunning ? tones.accentWarm : tones.textMuted;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            switch (period) {
              StreakPeriod.daily => LocaleKeys.daily.tr(),
              StreakPeriod.weekly => LocaleKeys.weekly.tr(),
            },
            style: TextStyle(fontSize: 12.sp, color: tones.textSecondary),
          ),
          SizedBox(height: 4.h),
          Row(
            spacing: 4.w,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 20.sp,
                color: color,
              ),
              Text(
                '${streak?.currentLength ?? 0}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            LocaleKeys.streakBest.tr(
              args: ['${streak?.longestLength ?? 0}'],
            ),
            style: TextStyle(fontSize: 12.sp, color: tones.textMuted),
          ),
        ],
      ),
    );
  }
}
