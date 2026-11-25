import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/exports/cubit/export_cubit.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/bottom_sheets/transaction_details_bottom_sheet.dart';
import 'package:trakli/presentation/utils/custom_drawer.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockTransferCubit extends Mock implements TransferCubit {}

class _MockExportCubit extends Mock implements ExportCubit {}

class _MockPlansCubit extends Mock implements PlansCubit {}

T _stub<T extends StateStreamableSource<S>, S>(T cubit, S state) {
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  return cubit;
}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  BlocProvider<TransactionCubit> transactionProvider() {
    final cubit = _stub(
      MockTransactionCubit(),
      TransactionState.initial().copyWith(
        transactions: ShotData.transactions,
        wallets: ShotData.wallets,
      ),
    );
    when(() => cubit.loadWallets()).thenAnswer((_) async {});
    return BlocProvider<TransactionCubit>.value(value: cubit);
  }

  BlocProvider<TransferCubit> transferProvider() => BlocProvider.value(
        value: _stub(_MockTransferCubit(), TransferState.initial()),
      );

  testWidgets('transactions', (tester) async {
    if (getIt.isRegistered<ExportCubit>()) getIt.unregister<ExportCubit>();
    getIt.registerFactory<ExportCubit>(
      () => _stub(_MockExportCubit(), const ExportState()),
    );
    await captureLedgerShots(
      tester,
      'transactions',
      (dark) => withShotProviders(
        const HistoryScreen(),
        extra: [transactionProvider()],
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('transaction detail', (tester) async {
    final lunch = ShotData.transactions.first;
    await captureLedgerShots(
      tester,
      'transaction-detail',
      (dark) => withShotProviders(
        Stack(
          children: [
            const ColoredBox(color: Color(0x59000000)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: TransactionDetailsBottomSheet(
                  transaction: lunch,
                  accentColor: Colors.transparent,
                  onDelete: () {},
                  onEdit: () {},
                ),
              ),
            ),
          ],
        ),
        extra: [transferProvider()],
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('drawer', (tester) async {
    await captureLedgerShots(
      tester,
      'drawer',
      (dark) => withShotProviders(
        const Scaffold(
          body: SizedBox(width: 304, child: CustomDrawer()),
        ),
        extra: [
          BlocProvider<PlansCubit>.value(
            value: _stub(_MockPlansCubit(), PlansState.initial()),
          ),
        ],
      ),
    );
  }, skip: !ledgerShotsEnabled);
}
