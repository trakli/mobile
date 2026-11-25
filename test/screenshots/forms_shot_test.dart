import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('confirm dialog', (tester) async {
    await captureLedgerShots(
      tester,
      'dialog',
      (dark) => withShotProviders(
        const Scaffold(
          body: PopUpDialog(
            title: 'Delete wallet',
            subTitle:
                'This removes Main account and its transactions. This cannot be undone.',
            dialogType: DialogType.negative,
            mainActionText: 'Delete',
          ),
        ),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('add wallet', (tester) async {
    await captureLedgerShots(
      tester,
      'add-wallet',
      (dark) => withShotProviders(const AddWalletScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('add category', (tester) async {
    await captureLedgerShots(
      tester,
      'add-category',
      (dark) => withShotProviders(
        const AddCategoryScreen(type: TransactionType.expense),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('add budget', (tester) async {
    await captureLedgerShots(
      tester,
      'add-budget',
      (dark) => withShotProviders(const AddBudgetScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('add party', (tester) async {
    await captureLedgerShots(
      tester,
      'add-party',
      (dark) => withShotProviders(const AddPartyScreen()),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('add group', (tester) async {
    await captureLedgerShots(
      tester,
      'add-group',
      (dark) => withShotProviders(const AddGroupScreen()),
    );
  }, skip: !ledgerShotsEnabled);
}
