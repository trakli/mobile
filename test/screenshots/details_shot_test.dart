import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/category/category_detail_screen.dart';
import 'package:trakli/presentation/groups/group_detail_screen.dart';
import 'package:trakli/presentation/parties/party_detail_screen.dart';
import 'package:trakli/presentation/wallets/wallet_detail_screen.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('wallet detail', (tester) async {
    await captureLedgerShots(
      tester,
      'wallet-detail',
      (dark) => withShotProviders(WalletDetailScreen(wallet: ShotData.main)),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('category detail', (tester) async {
    await captureLedgerShots(
      tester,
      'category-detail',
      (dark) => withShotProviders(
        CategoryDetailScreen(category: ShotData.groceries),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('group detail', (tester) async {
    await captureLedgerShots(
      tester,
      'group-detail',
      (dark) => withShotProviders(
        GroupDetailScreen(group: ShotData.household),
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('party detail', (tester) async {
    await captureLedgerShots(
      tester,
      'party-detail',
      (dark) => withShotProviders(PartyDetailScreen(party: ShotData.tomas)),
    );
  }, skip: !ledgerShotsEnabled);
}
