

// @module
// abstract class AppModule {
//   @singleton
//   @preResolve
//   Future<AppDatabase> provideAppDatabase() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'trakli.db'));
//     return AppDatabase(NativeDatabase.createInBackground(file));
//   }
// }

// @module
// abstract class SyncModule {
//   @Singleton(as: DriftSynchronizer<AppDatabase>)
//   SynchAppDatabase provideSynchronizer(
//     AppDatabase appDatabase,
//     Dio dio,
//     Set<SyncTypeHandler> typeHandlers,
//   ) {
//     return SynchAppDatabase(
//       appDatabase: appDatabase,
//       typeHandlers: typeHandlers,
//       dio: dio,
//     );
//   }
// }

// @module
// abstract class TypeHandlersModule {
//   @singleton
//   TransactionTypeHandler provideTransactionTypeHandler(
//     AppDatabase db,
//     TransactionRemoteDataSource remoteDataSource,
//   ) {
//     return TransactionTypeHandler(db, remoteDataSource);
//   }
// }
