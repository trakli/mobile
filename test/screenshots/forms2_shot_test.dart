import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/config/remote_feature_config.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/holdings/add_holding_screen.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/reminders/add_reminder_screen.dart';
import 'package:trakli/presentation/remote_config/cubit/remote_config_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/transfers/wallet_transfer_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockHolding extends Mock implements HoldingCubit {}

class _MockTransfer extends Mock implements TransferCubit {}

class _MockRemoteConfig extends Mock implements RemoteConfigCubit {}

T _stub<T extends StateStreamableSource<S>, S>(T cubit, S state) {
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  return cubit;
}

List<BlocProvider> _extra() => [
      BlocProvider<HoldingCubit>.value(
        value: _stub(_MockHolding(), HoldingState.initial()),
      ),
      BlocProvider<TransferCubit>.value(
        value: _stub(_MockTransfer(), TransferState.initial()),
      ),
      BlocProvider<RemoteConfigCubit>.value(
        value: _stub(
          _MockRemoteConfig(),
          const RemoteConfigState(RemoteFeatureConfig()),
        ),
      ),
    ];

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('add budget', (tester) async {
    await captureLedgerShots(tester, 'add-budget',
        (dark) => withShotProviders(const AddBudgetScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('add holding', (tester) async {
    await captureLedgerShots(tester, 'add-holding',
        (dark) => withShotProviders(const AddHoldingScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('add reminder', (tester) async {
    await captureLedgerShots(tester, 'add-reminder',
        (dark) => withShotProviders(const AddReminderScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('wallet transfer', (tester) async {
    await captureLedgerShots(
        tester,
        'transfer',
        (dark) =>
            withShotProviders(const WalletTransferScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);
}
