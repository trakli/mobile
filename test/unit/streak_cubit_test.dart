import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/streak/dtos/streak_dto.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/domain/usecases/streak/get_streaks_usecase.dart';
import 'package:trakli/presentation/streaks/cubit/streak_cubit.dart';

class _MockGetStreaks extends Mock implements GetStreaksUseCase {}

void main() {
  late _MockGetStreaks getStreaks;

  const dailyTracking = StreakEntity(
    type: StreakType.transaction,
    period: StreakPeriod.daily,
    currentLength: 4,
    longestLength: 9,
    isRunning: true,
  );
  const weeklyCheckIn = StreakEntity(
    type: StreakType.checkIn,
    period: StreakPeriod.weekly,
    currentLength: 1,
    longestLength: 2,
    isRunning: false,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    getStreaks = _MockGetStreaks();
  });

  StreakCubit buildCubit() => StreakCubit(getStreaks);

  group('StreakCubit', () {
    test('loads the streaks and finds one by type and period', () async {
      when(() => getStreaks(any()))
          .thenAnswer((_) async => const Right([dailyTracking, weeklyCheckIn]));

      final cubit = buildCubit();
      await cubit.loadStreaks();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.failure.hasError, isFalse);
      expect(
        cubit.state.streakFor(StreakType.transaction, StreakPeriod.daily),
        dailyTracking,
      );
      expect(
        cubit.state.streakFor(StreakType.transaction, StreakPeriod.weekly),
        isNull,
      );
    });

    test('a failed refresh keeps the streaks already shown', () async {
      when(() => getStreaks(any()))
          .thenAnswer((_) async => const Right([dailyTracking]));
      final cubit = buildCubit();
      await cubit.loadStreaks();

      when(() => getStreaks(any())).thenAnswer(
        (_) async => const Left(Failure.networkError()),
      );
      await cubit.loadStreaks();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.failure.hasError, isTrue);
      expect(cubit.state.streaks, [dailyTracking]);
    });

    test('a refresh clears the previous failure', () async {
      when(() => getStreaks(any())).thenAnswer(
        (_) async => const Left(Failure.networkError()),
      );
      final cubit = buildCubit();
      await cubit.loadStreaks();
      expect(cubit.state.failure.hasError, isTrue);

      when(() => getStreaks(any()))
          .thenAnswer((_) async => const Right([dailyTracking]));
      await cubit.loadStreaks();

      expect(cubit.state.failure.hasError, isFalse);
      expect(cubit.state.streaks, [dailyTracking]);
    });

    test('ignores a second load while one is in flight', () async {
      final pending = Completer<Either<Failure, List<StreakEntity>>>();
      when(() => getStreaks(any())).thenAnswer((_) => pending.future);

      final cubit = buildCubit();
      final first = cubit.loadStreaks();
      await cubit.loadStreaks();
      pending.complete(const Right([dailyTracking]));
      await first;

      verify(() => getStreaks(any())).called(1);
      expect(cubit.state.streaks, [dailyTracking]);
    });

    test('does not emit when closed before the answer arrives', () async {
      final pending = Completer<Either<Failure, List<StreakEntity>>>();
      when(() => getStreaks(any())).thenAnswer((_) => pending.future);

      final cubit = buildCubit();
      final load = cubit.loadStreaks();
      await cubit.close();
      pending.complete(const Right([dailyTracking]));

      await expectLater(load, completes);
    });
  });

  group('StreakDto', () {
    test('reads a row from GET /streaks', () {
      final entity = StreakDto.fromJson(const {
        'id': 7,
        'type': 'check_in',
        'period': 'weekly',
        'current_length': 3,
        'longest_length': 5,
        'started_on': '2026-09-21',
        'last_tracked_on': '2026-10-05',
        'is_running': true,
      }).toEntity();

      expect(entity, isNotNull);
      expect(entity!.type, StreakType.checkIn);
      expect(entity.period, StreakPeriod.weekly);
      expect(entity.currentLength, 3);
      expect(entity.longestLength, 5);
      expect(entity.isRunning, isTrue);
      expect(entity.startedOn, DateTime(2026, 9, 21));
      expect(entity.lastTrackedOn, DateTime(2026, 10, 5));
    });

    test('reads a streak that has never been tracked', () {
      final entity = StreakDto.fromJson(const {
        'type': 'transaction',
        'period': 'daily',
        'current_length': 0,
        'longest_length': 0,
        'started_on': null,
        'last_tracked_on': null,
        'is_running': false,
      }).toEntity();

      expect(entity!.startedOn, isNull);
      expect(entity.lastTrackedOn, isNull);
    });

    test('skips a type or period this build does not know', () {
      Map<String, dynamic> row(String type, String period) => {
            'type': type,
            'period': period,
            'current_length': 1,
            'longest_length': 1,
            'is_running': false,
          };

      expect(StreakDto.fromJson(row('budget', 'daily')).toEntity(), isNull);
      expect(
        StreakDto.fromJson(row('transaction', 'monthly')).toEntity(),
        isNull,
      );
    });
  });
}
