import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/presentation/defaults_settings_screen.dart';
import 'package:trakli/presentation/notification_settings/notification_settings_screen.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/profile_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockPlansCubit extends Mock implements PlansCubit {}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  BlocProvider<PlansCubit> plans() {
    final cubit = _MockPlansCubit();
    when(() => cubit.state).thenReturn(PlansState.initial());
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    return BlocProvider<PlansCubit>.value(value: cubit);
  }

  testWidgets('profile', (tester) async {
    await captureLedgerShots(
      tester,
      'profile',
      (dark) => withShotProviders(const ProfileScreen(), extra: [plans()]),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('defaults', (tester) async {
    await captureLedgerShots(
      tester,
      'defaults',
      (dark) => withShotProviders(const DefaultsSettingsScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('notification settings', (tester) async {
    await captureLedgerShots(
      tester,
      'notifications-settings',
      (dark) => withShotProviders(const NotificationSettingsScreen()),
    );
  }, skip: !ledgerShotsEnabled);
}
