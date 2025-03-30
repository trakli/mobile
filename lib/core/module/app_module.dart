import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/sync/transaction_type_handler.dart';

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
