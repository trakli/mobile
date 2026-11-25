import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/core/config/remote_feature_config.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/remote_config/cubit/remote_config_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockTransferCubit extends Mock implements TransferCubit {}

class _MockRemoteConfigCubit extends Mock implements RemoteConfigCubit {}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('addFull', (tester) async {
    SharedPreferences.setMockInitialValues({'formDisplay': 'full'});
    final transfer = _MockTransferCubit();
    when(() => transfer.state).thenReturn(TransferState.initial());
    when(() => transfer.stream).thenAnswer((_) => const Stream.empty());
    final remote = _MockRemoteConfigCubit();
    when(() => remote.state)
        .thenReturn(const RemoteConfigState(RemoteFeatureConfig()));
    when(() => remote.stream).thenAnswer((_) => const Stream.empty());

    final paidBack = CategoryEntity(
      clientId: 'c-paidback',
      type: TransactionType.income,
      name: 'Paid back',
      createdAt: DateTime(2025),
    );

    await captureLedgerShots(
      tester,
      'addFull',
      (dark) => withShotProviders(
        AddTransactionScreen(
          transactionType: TransactionType.income,
          initialParty: ShotData.tomas,
          initialIntent: TransactionIntent.debtOwed,
          initialAmount: 40,
          initialWallet: ShotData.cash,
          initialCategory: paidBack,
          initialDescription: 'First half of the 120',
          initialDate: ShotData.day(3, 14).add(const Duration(minutes: 10)),
        ),
        extra: [
          BlocProvider<TransferCubit>.value(value: transfer),
          BlocProvider<RemoteConfigCubit>.value(value: remote),
        ],
      ),
    );
  }, skip: !ledgerShotsEnabled);
}
