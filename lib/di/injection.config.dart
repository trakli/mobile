// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:drift_sync_core/drift_sync_core.dart' as _i877;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/database/app_database.dart' as _i935;
import '../core/module/http_module.dart' as _i488;
import '../core/module/sync_module.dart' as _i680;
import '../core/network/network_info.dart' as _i6;
import '../core/sync/sync_database.dart' as _i646;
import '../core/sync/sync_service.dart' as _i957;
import '../core/utils/services/shared_prefs.dart' as _i789;
import '../data/datasources/auth/auth_local_data_source.dart' as _i276;
import '../data/datasources/auth/auth_remote_data_source.dart' as _i496;
import '../data/datasources/auth/token_manager.dart' as _i483;
import '../data/datasources/transaction/mock_transaction_remote_datasource.dart'
    as _i150;
import '../data/datasources/transaction/transaction_local_datasource.dart'
    as _i662;
import '../data/datasources/transaction/transaction_remote_datasource.dart'
    as _i79;
import '../data/repositories/transaction_repository_impl.dart' as _i114;
import '../data/sync/transaction_sync_handler.dart' as _i893;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/transaction_repository.dart' as _i118;
import '../domain/usecases/auth/create_user_usecase.dart' as _i170;
import '../domain/usecases/auth/login_usecase.dart' as _i363;
import '../domain/usecases/transaction/create_transaction_usecase.dart'
    as _i669;
import '../domain/usecases/transaction/delete_transaction_usecase.dart'
    as _i163;
import '../domain/usecases/transaction/get_all_transactions_usecase.dart'
    as _i947;
import '../domain/usecases/transaction/listen_to_transactions_usecase.dart'
    as _i973;
import '../domain/usecases/transaction/update_transaction_usecase.dart'
    as _i241;
import '../domain/usecases/transaction/usecase.dart' as _i1022;
import '../presentation/bloc/transaction/transaction_cubit.dart' as _i218;

const String _dev = 'dev';
const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectHttpClientModule = _$InjectHttpClientModule();
  final syncModule = _$SyncModule();
  gh.singleton<_i957.SyncService>(() => _i957.SyncService());
  gh.factory<_i6.NetworkInfo>(() => _i6.NetworkInfoImpl()..init());
  gh.factory<_i662.TransactionLocalDataSource>(
      () => _i662.TransactionLocalDataSourceImpl(gh<_i935.AppDatabase>()));
  gh.factory<_i276.AuthLocalDataSource>(() => _i276.AuthLocalDataSourceImpl());
  gh.factory<_i79.TransactionRemoteDataSource>(
      () => _i150.MockTransactionRemoteDataSource());
  gh.singletonAsync<_i789.SharedPrefs>(() {
    final i = _i789.SharedPrefsImpl();
    return i.init().then((_) => i);
  });
  gh.factory<_i483.TokenManager>(() => const _i483.TokenManagerImpl());
  gh.factory<String>(
    () => injectHttpClientModule.devHttpUrl,
    instanceName: 'HttpUrl',
    registerFor: {_dev},
  );
  gh.lazySingleton<_i893.TransactionSyncHandler>(
      () => _i893.TransactionSyncHandler(
            gh<_i935.AppDatabase>(),
            gh<_i79.TransactionRemoteDataSource>(),
          ));
  gh.lazySingleton<_i361.Dio>(
      () => injectHttpClientModule.dio(gh<String>(instanceName: 'HttpUrl')));
  gh.factory<String>(
    () => injectHttpClientModule.prodHttpUrl,
    instanceName: 'HttpUrl',
    registerFor: {_prod},
  );
  gh.factory<_i496.AuthRemoteDataSource>(
      () => _i496.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<Set<_i877.SyncTypeHandler<dynamic, dynamic>>>(() =>
      syncModule.provideSyncTypeHandlers(gh<_i893.TransactionSyncHandler>()));
  gh.lazySingleton<_i118.TransactionRepository>(
      () => _i114.TransactionRepositoryImpl(
            syncHandler: gh<_i893.TransactionSyncHandler>(),
            localDataSource: gh<_i662.TransactionLocalDataSource>(),
            db: gh<_i935.AppDatabase>(),
          ));
  gh.factory<_i800.AuthRepository>(() => _i800.AuthRepositoryImpl(
        remoteDataSource: gh<_i496.AuthRemoteDataSource>(),
        localDataSource: gh<_i276.AuthLocalDataSource>(),
        networkInfo: gh<_i6.NetworkInfo>(),
        tokenManager: gh<_i483.TokenManager>(),
      ));
  gh.lazySingleton<_i646.SynchAppDatabase>(() => _i646.SynchAppDatabase(
        appDatabase: gh<_i935.AppDatabase>(),
        typeHandlers: gh<Set<_i877.SyncTypeHandler<dynamic, dynamic>>>(),
        dio: gh<_i361.Dio>(),
        networkInfo: gh<_i6.NetworkInfo>(),
      ));
  gh.factory<_i947.GetAllTransactionsUseCase>(
      () => _i947.GetAllTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i669.CreateTransactionUseCase>(
      () => _i669.CreateTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i973.ListenToTransactionsUseCase>(() =>
      _i973.ListenToTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i241.UpdateTransactionUseCase>(
      () => _i241.UpdateTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i163.DeleteTransactionUseCase>(
      () => _i163.DeleteTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i218.TransactionCubit>(() => _i218.TransactionCubit(
        getAllTransactionsUseCase: gh<_i1022.GetAllTransactionsUseCase>(),
        createTransactionUseCase: gh<_i1022.CreateTransactionUseCase>(),
        updateTransactionUseCase: gh<_i1022.UpdateTransactionUseCase>(),
        deleteTransactionUseCase: gh<_i1022.DeleteTransactionUseCase>(),
        listenToTransactionsUseCase: gh<_i1022.ListenToTransactionsUseCase>(),
      ));
  gh.factory<_i363.LoginUsecase>(
      () => _i363.LoginUsecase(gh<_i800.AuthRepository>()));
  gh.factory<_i170.CreateUserUsecase>(
      () => _i170.CreateUserUsecase(gh<_i800.AuthRepository>()));
  return getIt;
}

class _$InjectHttpClientModule extends _i488.InjectHttpClientModule {}

class _$SyncModule extends _i680.SyncModule {}
