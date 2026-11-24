import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_screen.dart';
import 'package:trakli/presentation/statistics/statistics_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('statistics flow', (tester) async {
    await captureLedgerShots(
      tester,
      'stats',
      (_) => withShotProviders(
        const StatisticsScreen(initialTab: StatisticsTab.flow),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('statistics calendar', (tester) async {
    await captureLedgerShots(
      tester,
      'calendar',
      (_) => withShotProviders(
        const StatisticsScreen(initialTab: StatisticsTab.calendar),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('month in review', (tester) async {
    final txs = ShotData.transactions
        .where((t) => t.transaction.description != 'Spotify')
        .toList();
    final data = buildMonthInReview(txs)!;
    await captureLedgerShots(
      tester,
      'recap',
      (_) => withShotProviders(
        Builder(
          builder: (context) => MonthInReviewScreen(
            data: data,
            autoAdvance: false,
            initialPage: data.longestNoSpendRun != null &&
                    data.longestNoSpendRun!.days >= 2
                ? 3
                : 0,
          ),
        ),
      ),
    );
  }, skip: !ledgerShotsEnabled);
}
