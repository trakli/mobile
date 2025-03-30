// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'dart:io';

// // --- Database Setup ---

// // Define the database schema using drift
// part 'database.g.dart';

// class Transactions extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get description => text()();
//   RealColumn get amount => real()();
//   DateTimeColumn get date => dateTime()();
//   BoolColumn get synced => boolean().withDefault(const Constant(false))();
//   // Add other columns as needed
// }

// class Transfers extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get fromAccountId => integer()();
//   IntColumn get toAccountId => integer()();
//   RealColumn get amount => real()();
//   DateTimeColumn get date => dateTime()();
//   BoolColumn get synced => boolean().withDefault(const Constant(false))();
//   // Add other columns as needed
// }

// // Define the database class
// @DriftDatabase(tables: [Transactions, Transfers])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;
// }

// LazyDatabase _openConnection() {
//   // the LazyDatabase util lets us find the right location for the file async.
//   return LazyDatabase(() async {
//     // put the database file, called db.sqlite here, into the documents folder
//     // for your app.
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase.createInBackground(file);
//   });
// }

// // --- TableSyncHandler ---

// mixin TableSyncHandler<Tbl extends Table, Row extends Insertable<Row>> {
//   TableInfo<Tbl, Row> get table;

//   Future<void> deleteLocal(Row entity) async {
//     await table.deleteOne(entity);
//   }

//   Future<void> upsertLocal(Row entity) async {
//     await table.insertOne(entity, mode: InsertMode.insertOrReplace);
//   }

//   Future<void> upsertAllLocal(List<Row> list) async {
//     await table.insertAll(list, mode: InsertMode.insertOrReplace);
//   }

//   Future<void> deleteAllLocal() async {
//     await table.deleteAll();
//   }

//   Future<List<Row>> getUnsynced() async {
//     final query = table.select()
//       ..where((tbl) => tbl.getColumnByName('synced')!.equals(false));
//     return query.get();
//   }

//   Future<void> markAsSynced(Row entity) async {
//     final updatedEntity = entity.copyWith(synced: const Value(true));
//     await table.update(table).replace(updatedEntity);
//   }
// }

// // --- TransactionSyncHandler ---

// class TransactionSyncHandler with TableSyncHandler<Transactions, Transaction> {
//   final AppDatabase db;

//   TransactionSyncHandler(this.db);

//   @override
//   TableInfo<Transactions, Transaction> get table => db.transactions;

//   // Example of adding a custom method
//   Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
//     final query = db.transactions.select()
//       ..where((tbl) => tbl.date.equals(date));
//     return await query.get();
//   }
// }

// // --- TransferSyncHandler ---

// class TransferSyncHandler with TableSyncHandler<Transfers, Transfer> {
//   final AppDatabase db;

//   TransferSyncHandler(this.db);

//   @override
//   TableInfo<Transfers, Transfer> get table => db.transfers;

//   // Example of adding a custom method
//   Future<List<Transfer>> getTransfersByAccount(int accountId) async {
//     final query = db.transfers.select()
//       ..where((tbl) =>
//           tbl.fromAccountId.equals(accountId) |
//           tbl.toAccountId.equals(accountId));
//     return await query.get();
//   }
// }

// // --- Sync Service ---

// class SyncService {
//   final TransactionSyncHandler transactionSyncHandler;
//   final TransferSyncHandler transferSyncHandler;
//   // Add other sync handlers here

//   SyncService({
//     required this.transactionSyncHandler,
//     required this.transferSyncHandler,
//   });

//   // Simulate API call
//   Future<void> _simulateApiCall(String type, dynamic data) async {
//     print('Simulating API call for $type: $data');
//     await Future.delayed(
//         const Duration(seconds: 1)); // Simulate network latency
//     // In a real app, you would make an actual API call here
//   }

//   Future<void> sync() async {
//     print('Starting sync...');

//     // Sync Transactions
//     final unsyncedTransactions = await transactionSyncHandler.getUnsynced();
//     for (final transaction in unsyncedTransactions) {
//       try {
//         await _simulateApiCall('Transaction', transaction.toJson());
//         await transactionSyncHandler.markAsSynced(transaction);
//         print('Synced transaction: ${transaction.id}');
//       } catch (e) {
//         print('Error syncing transaction ${transaction.id}: $e');
//         // Handle error (e.g., retry later, log, etc.)
//       }
//     }

//     // Sync Transfers
//     final unsyncedTransfers = await transferSyncHandler.getUnsynced();
//     for (final transfer in unsyncedTransfers) {
//       try {
//         await _simulateApiCall('Transfer', transfer.toJson());
//         await transferSyncHandler.markAsSynced(transfer);
//         print('Synced transfer: ${transfer.id}');
//       } catch (e) {
//         print('Error syncing transfer ${transfer.id}: $e');
//         // Handle error (e.g., retry later, log, etc.)
//       }
//     }

//     print('Sync completed.');
//   }
// }

// // --- Example Usage ---

// Future<void> main() async {
//   // Ensure that the Flutter framework is initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize the database
//   final db = AppDatabase();

//   // Initialize the sync handlers
//   final transactionSyncHandler = TransactionSyncHandler(db);
//   final transferSyncHandler = TransferSyncHandler(db);

//   // Initialize the sync service
//   final syncService = SyncService(
//     transactionSyncHandler: transactionSyncHandler,
//     transferSyncHandler: transferSyncHandler,
//   );

//   // Example: Add some transactions and transfers
//   final now = DateTime.now();
//   await transactionSyncHandler.upsertLocal(TransactionsCompanion(
//     description: const Value('Transaction 1'),
//     amount: const Value(100.0),
//     date: Value(now),
//   ).toInsertable());
//   await transactionSyncHandler.upsertLocal(TransactionsCompanion(
//     description: const Value('Transaction 2'),
//     amount: const Value(200.0),
//     date: Value(now.add(const Duration(days: 1))),
//   ).toInsertable());

//   await transferSyncHandler.upsertLocal(TransfersCompanion(
//     fromAccountId: const Value(1),
//     toAccountId: const Value(2),
//     amount: const Value(50.0),
//     date: Value(now),
//   ).toInsertable());

//   // Example: Run the sync service
//   await syncService.sync();

//   // Example: Add more transactions after sync
//   await transactionSyncHandler.upsertLocal(TransactionsCompanion(
//     description: const Value('Transaction 3'),
//     amount: const Value(150.0),
//     date: Value(now.add(const Duration(days: 2))),
//   ).toInsertable());

//   // Example: Run the sync service again
//   await syncService.sync();

//   // Example: Get transactions by date
//   final transactionsToday =
//       await transactionSyncHandler.getTransactionsByDate(now);
//   print(
//       'Transactions today: ${transactionsToday.map((e) => e.toJson()).toList()}');

//   // Example: Get transfers by account
//   final transfersForAccount1 =
//       await transferSyncHandler.getTransfersByAccount(1);
//   print(
//       'Transfers for account 1: ${transfersForAccount1.map((e) => e.toJson()).toList()}');

//   // Close the database
//   await db.close();
// }
