import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/presentation/defaults_settings_screen.dart';
import 'package:trakli/presentation/financial_position/cubit/financial_position_cubit.dart';
import 'package:trakli/presentation/financial_position/financial_position_screen.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/notification_settings/notification_settings_screen.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/profile_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockPlansCubit extends Mock implements PlansCubit {}

class _MockFinancialPositionCubit extends Mock
    implements FinancialPositionCubit {}

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

  testWidgets('financial position', (tester) async {
    final cubit = _MockFinancialPositionCubit();
    when(() => cubit.state).thenReturn(
      FinancialPositionState(
        preset: FinancialPositionPreset.currentMonth,
        isLoading: false,
        failure: const Failure.none(),
        position: FinancialPositionEntity(
          earnedIncome: 3200,
          discretionarySpend: 1874.6,
          cashBalance: 8421.15,
          holdingsValue: 12500,
          totalNetWorth: 20921.15,
          loanReceived: 0,
          loanRepayment: 250,
          debtOwed: 120,
          debtSettled: 0,
          loansDebtNet: -130,
          investmentPrincipal: 400,
          investmentReturns: 86.4,
          giftsReceived: 0,
          netWorthDelta: 1411.8,
          currency: 'EUR',
          asOf: DateTime(2026, 11, 24, 18, 5),
        ),
      ),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    if (getIt.isRegistered<FinancialPositionCubit>()) {
      getIt.unregister<FinancialPositionCubit>();
    }
    getIt.registerFactory<FinancialPositionCubit>(() => cubit);
    await captureLedgerShots(
      tester,
      'financial-position',
      (dark) => withShotProviders(const FinancialPositionScreen()),
    );
  }, skip: !ledgerShotsEnabled);
}
