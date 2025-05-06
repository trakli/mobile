// import 'package:drift/drift.dart';
// import 'package:trakli/data/database/tables/sync_table.dart';
// import 'package:trakli/data/database/tables/wallets.dart';

// @DataClassName('Transfer')
// class Transfers extends Table with SyncTable {
//   RealColumn get amount => real()();
//   RealColumn get exchangeRate => real().withDefault(const Constant(1.0))();
//   IntColumn get userId => integer()();

//   // Local wallet references
//   TextColumn get fromWalletClientId => text().references(Wallets, #clientId)();
//   TextColumn get toWalletClientId => text().references(Wallets, #clientId)();

//   // Server wallet references
//   IntColumn get fromWalletId => integer()();
//   IntColumn get toWalletId => integer()();
// }
