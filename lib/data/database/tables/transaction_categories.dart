// import 'package:drift/drift.dart';
// import 'package:trakli/data/database/tables/sync_table.dart';
// import 'package:trakli/data/database/tables/categories.dart';
// import 'package:trakli/data/database/tables/transactions.dart';

// @DataClassName('TransactionCategory')
// class TransactionCategories extends Table with SyncTable {
//   // Local references
//   TextColumn get transactionClientId =>
//       text().references(Transactions, #clientId)();

//   TextColumn get categoryClientId => text().references(Categories, #clientId)();

//   // Server references
//   IntColumn get transactionId => integer()();
//   IntColumn get categoryId => integer()();
// }
