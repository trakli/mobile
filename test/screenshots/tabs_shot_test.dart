import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/presentation/budget/budget_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/wallets/wallet_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('wallets', (tester) async {
    await captureLedgerShots(
      tester,
      'wallets',
      (dark) => withShotProviders(const WalletScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('budgets', (tester) async {
    BlocProvider<BudgetCubit> budgets() {
      final cubit = MockBudgetCubit();
      when(() => cubit.state).thenReturn(
        BudgetState.initial().copyWith(budgets: ShotData.budgets),
      );
      when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => cubit.isClosed).thenReturn(false);
      when(() => cubit.close()).thenAnswer((_) async {});
      when(() => cubit.loadBudgets()).thenAnswer((_) async {});
      return BlocProvider<BudgetCubit>.value(value: cubit);
    }

    await captureLedgerShots(
      tester,
      'budgets',
      (dark) => withShotProviders(const BudgetScreen(), extra: [budgets()]),
    );
  }, skip: !ledgerShotsEnabled);
}
