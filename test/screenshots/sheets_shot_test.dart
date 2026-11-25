import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/info_interfaces/empty_home_widget.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('icon picker', (tester) async {
    await captureLedgerShots(
      tester,
      'icon-picker',
      (dark) => withShotProviders(
        const Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Material(child: SelectIconBottomSheet()),
          ),
        ),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('empty home', (tester) async {
    await captureLedgerShots(
      tester,
      'empty-home',
      (dark) => withShotProviders(
        const Scaffold(body: SafeArea(child: EmptyHomeWidget())),
        extra: [BlocProvider(create: (_) => MainNavigationCubit())],
      ),
    );
  }, skip: !ledgerShotsEnabled);
}
