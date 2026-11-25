import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/core/config/remote_feature_config.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/remote_config/cubit/remote_config_cubit.dart';
import 'package:trakli/presentation/transactions/add_transaction_form_compact_layout.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_form.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';

import '../screenshots/ledger_fixtures.dart';
import '../screenshots/ledger_harness.dart';

class _MockTransferCubit extends Mock implements TransferCubit {}

class _MockRemoteConfigCubit extends Mock implements RemoteConfigCubit {}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final transfer = _MockTransferCubit();
    when(() => transfer.state).thenReturn(TransferState.initial());
    when(() => transfer.stream).thenAnswer((_) => const Stream.empty());
    final remote = _MockRemoteConfigCubit();
    when(() => remote.state)
        .thenReturn(const RemoteConfigState(RemoteFeatureConfig()));
    when(() => remote.stream).thenAnswer((_) => const Stream.empty());
    await tester.pumpWidget(
      ledgerApp(
        withShotProviders(
          const AddTransactionScreen(transactionType: TransactionType.expense),
          extra: [
            BlocProvider<TransferCubit>.value(value: transfer),
            BlocProvider<RemoteConfigCubit>.value(value: remote),
          ],
        ),
        dark: false,
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows the full form when no display mode was ever chosen',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpScreen(tester);

    expect(find.byType(LedgerTransactionForm), findsOneWidget);
    expect(find.byType(AddTransactionFormCompactLayout), findsNothing);
  });

  testWidgets('shows the compact form when compact was chosen', (tester) async {
    SharedPreferences.setMockInitialValues({'formDisplay': 'compact'});
    await pumpScreen(tester);

    expect(find.byType(AddTransactionFormCompactLayout), findsOneWidget);
    expect(find.byType(LedgerTransactionForm), findsNothing);
  });
}
