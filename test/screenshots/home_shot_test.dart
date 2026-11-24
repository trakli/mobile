import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/activity/activity_screen.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/transactions/quick_add/quick_add_sheet.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('home', (tester) async {
    await captureLedgerShots(
      tester,
      'home',
      (dark) => withShotProviders(HomeScreen(now: ShotData.now)),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('quick add', (tester) async {
    await captureLedgerShots(
      tester,
      'add',
      (dark) => withShotProviders(
        Stack(
          children: [
            HomeScreen(now: ShotData.now),
            const ModalBarrier(color: Color(0x59000000)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                type: MaterialType.transparency,
                child: QuickAddSheet(
                  now: ShotData.now,
                  initialText: '12.50 lunch at Chez Lou, cash',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('activity', (tester) async {
    await captureLedgerShots(
      tester,
      'activity',
      (dark) => withShotProviders(ActivityScreen(now: ShotData.now)),
    );
  }, skip: !ledgerShotsEnabled);
}
