import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/groups/my_groups_screen.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/reminders/reminder_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('categories', (tester) async {
    await captureLedgerShots(
      tester,
      'categories',
      (dark) => withShotProviders(const CategoryScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('parties', (tester) async {
    await captureLedgerShots(
      tester,
      'parties',
      (dark) => withShotProviders(const PartyScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('groups', (tester) async {
    final cubit = MockGroupCubit();
    when(() => cubit.state).thenReturn(GroupState(groups: ShotData.groups));
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.isClosed).thenReturn(false);
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.getGroups()).thenAnswer((_) async {});
    if (getIt.isRegistered<GroupCubit>()) getIt.unregister<GroupCubit>();
    getIt.registerFactory<GroupCubit>(() => cubit);
    await captureLedgerShots(
      tester,
      'groups',
      (dark) => withShotProviders(const MyGroupsScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('reminders', (tester) async {
    await captureLedgerShots(
      tester,
      'reminders',
      (dark) => withShotProviders(const ReminderScreen()),
    );
  }, skip: !ledgerShotsEnabled);
}
