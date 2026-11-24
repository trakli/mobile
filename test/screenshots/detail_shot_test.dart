import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/presentation/budget/budget_detail_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/parties/party_detail_screen.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockTransferCubit extends Mock implements TransferCubit {}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  BlocProvider<BudgetCubit> budgetProvider() {
    final cubit = MockBudgetCubit();
    when(() => cubit.state).thenReturn(
      BudgetState.initial().copyWith(budgets: ShotData.budgets),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.watchBudget(any())).thenReturn(null);
    return BlocProvider<BudgetCubit>.value(value: cubit);
  }

  BlocProvider<ReminderCubit> reminderProvider() {
    final cubit = MockReminderCubit();
    final due = ShotData.day(-11, 9);
    when(() => cubit.state).thenReturn(
      ReminderState.initial().copyWith(reminders: [
        ...ShotData.reminders,
        ReminderEntity(
          clientId: 'r-tomas',
          title: 'Tomás pays back €80.00',
          description: 'Tomás Reyes',
          triggerAt: due,
          nextTriggerAt: due,
          createdAt: ShotData.day(1),
          updatedAt: ShotData.day(1),
        ),
      ]),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    return BlocProvider<ReminderCubit>.value(value: cubit);
  }

  BlocProvider<TransferCubit> transferProvider() {
    final cubit = _MockTransferCubit();
    when(() => cubit.state).thenReturn(TransferState.initial());
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    return BlocProvider<TransferCubit>.value(value: cubit);
  }

  testWidgets('budget detail', (tester) async {
    await captureLedgerShots(
      tester,
      'budget',
      (dark) => withShotProviders(
        BudgetDetailScreen(budget: ShotData.budgetEating),
        extra: [budgetProvider()],
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('person detail', (tester) async {
    await captureLedgerShots(
      tester,
      'party',
      (dark) => withShotProviders(
        PartyDetailScreen(party: ShotData.tomas),
        extra: [reminderProvider(), transferProvider()],
      ),
    );
  }, skip: !ledgerShotsEnabled);
}
