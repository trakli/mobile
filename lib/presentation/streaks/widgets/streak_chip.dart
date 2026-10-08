import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/streaks/cubit/streak_cubit.dart';
import 'package:trakli/presentation/streaks/widgets/streak_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/sync_cubit.dart';

/// The user's daily tracking streak, opening the full set on tap.
///
/// Streaks are counted on the server and the app keeps no copy, so the chip
/// is hidden for guests and until the server has answered.
class StreakChip extends StatelessWidget {
  const StreakChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.isAuthenticated != current.isAuthenticated,
      builder: (context, authState) {
        if (!authState.isAuthenticated) return const SizedBox.shrink();

        return BlocProvider(
          create: (_) => getIt<StreakCubit>()..loadStreaks(),
          child: const _StreakChipView(),
        );
      },
    );
  }
}

class _StreakChipView extends StatelessWidget {
  const _StreakChipView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SyncCubit, bool>(
      // A transaction only counts once it reaches the server, so look again
      // each time a sync finishes.
      listenWhen: (wasSyncing, isSyncing) => wasSyncing && !isSyncing,
      listener: (context, _) => context.read<StreakCubit>().loadStreaks(),
      child: BlocBuilder<StreakCubit, StreakState>(
        buildWhen: (previous, current) => previous.streaks != current.streaks,
        builder: (context, state) {
          final streak =
              state.streakFor(StreakType.transaction, StreakPeriod.daily);
          if (streak == null) return const SizedBox.shrink();

          final tones = context.tones;
          final color = streak.isRunning ? tones.accentWarm : tones.textMuted;
          final radius = BorderRadius.circular(AppRadii.pill);

          return Tooltip(
            message: LocaleKeys.streaksTitle.tr(),
            child: Material(
              color: streak.isRunning
                  ? tones.accentWarmSoft
                  : tones.neutral.background,
              borderRadius: radius,
              child: InkWell(
                borderRadius: radius,
                onTap: () => showCustomBottomSheet(
                  context,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  widget: StreakSheet(streaks: state.streaks),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.w,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 16.sp,
                        color: color,
                      ),
                      Text(
                        '${streak.currentLength}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
