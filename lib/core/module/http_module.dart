import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:trakli/core/database/app_database.dart';

@module
abstract class InjectHttpClientModule {
  // InjectHttpClientModule({required this.tokenManager});

  // late TokenManager tokenManager;

  @Named('HttpUrl')
  @dev
  String get devHttpUrl => 'https://api.dev.mymocredit.com/api/v1/';

  @Named('HttpUrl')
  @prod
  String get prodHttpUrl => 'https://api.mymocredit.com/api/v1/';

  @lazySingleton
  Dio dio(@Named('HttpUrl') String url) {
    final dio = Dio(
      BaseOptions(baseUrl: url),
    );

    dio.interceptors.addAll([
      // RemoveNullValuesInterceptor(),
      // // TokenInterceptor(tokenManager),
      // LoggerInterceptor()
    ]);

    return dio;
  }

  // @Singleton(as: AppDatabase)
  // @lazySingleton
  // Future<AppDatabase> provideAppDatabase() async {
  //   final dbFolder = await getApplicationDocumentsDirectory();
  //   final file = File(p.join(dbFolder.path, 'trakli.db'));
  //   return AppDatabase(NativeDatabase.createInBackground(file));
  // }

  // @Singleton(as: DriftSynchronizer<AppDatabase>)
  // SynchAppDatabase provideSynchronizer(
  //   AppDatabase appDatabase,
  //   Dio dio,
  //   Set<SyncTypeHandler> typeHandlers,
  // ) {
  //   return SynchAppDatabase(
  //     appDatabase: appDatabase,
  //     typeHandlers: typeHandlers,
  //     dio: dio,
  //   );
  // }

  // @singleton
  // TransactionTypeHandler provideTransactionTypeHandler(
  //   AppDatabase db,
  //   TransactionRemoteDataSource remoteDataSource,
  // ) {
  //   return TransactionTypeHandler(db, remoteDataSource);
  // }
}

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
