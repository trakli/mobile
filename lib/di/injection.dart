import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
  ignoreUnregisteredTypes: [AppDatabase, SyncTypeHandler<Transaction, String>],
)
void configureDependencies(String env) {
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  $initGetIt(getIt, environment: env);
}
