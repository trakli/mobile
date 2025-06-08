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

import '../core/module/http_module.dart' as _i488;
import '../core/module/sync_module.dart' as _i680;
import '../core/network/network_info.dart' as _i6;
import '../core/sync/sync_database.dart' as _i646;
import '../core/sync/sync_service.dart' as _i957;
import '../core/utils/services/shared_prefs.dart' as _i789;
import '../data/database/app_database.dart' as _i704;
import '../data/datasources/auth/auth_local_data_source.dart' as _i276;
import '../data/datasources/auth/auth_remote_data_source.dart' as _i496;
import '../data/datasources/auth/preference_manager.dart' as _i683;
import '../data/datasources/auth/token_manager.dart' as _i483;
import '../data/datasources/category/category_local_datasource.dart' as _i148;
import '../data/datasources/category/category_remote_datasource.dart' as _i558;
import '../data/datasources/exchange-rate/exchange_rate_local_datasource.dart'
    as _i900;
import '../data/datasources/exchange-rate/exchange_rate_remote_datasource.dart'
    as _i632;
import '../data/datasources/onboarding/onboarding_local_data_source.dart'
    as _i480;
import '../data/datasources/party/party_local_datasource.dart' as _i655;
import '../data/datasources/party/party_remote_datasource.dart' as _i656;
import '../data/datasources/transaction/transaction_local_datasource.dart'
    as _i662;
import '../data/datasources/transaction/transaction_remote_datasource.dart'
    as _i79;
import '../data/datasources/wallet/wallet_local_datasource.dart' as _i849;
import '../data/datasources/wallet/wallet_remote_datasource.dart' as _i624;
import '../data/repositories/auth_repository_imp.dart' as _i135;
import '../data/repositories/category_repository_impl.dart' as _i324;
import '../data/repositories/exchange_rate_imp.dart' as _i827;
import '../data/repositories/onboarding_repository_impl.dart' as _i386;
import '../data/repositories/party_repository_impl.dart' as _i168;
import '../data/repositories/transaction_repository_impl.dart' as _i114;
import '../data/repositories/wallet_repository_impl.dart' as _i305;
import '../data/sync/category_sync_handler.dart' as _i463;
import '../data/sync/party_sync_handler.dart' as _i280;
import '../data/sync/transaction_sync_handler.dart' as _i893;
import '../data/sync/wallet_sync_handler.dart' as _i849;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/category_repository.dart' as _i410;
import '../domain/repositories/exchange_rate_repository.dart' as _i1057;
import '../domain/repositories/onboarding_repository.dart' as _i867;
import '../domain/repositories/party_repository.dart' as _i661;
import '../domain/repositories/transaction_repository.dart' as _i118;
import '../domain/repositories/wallet_repository.dart' as _i368;
import '../domain/usecases/auth/get_loggedin_user.dart' as _i880;
import '../domain/usecases/auth/is_onboarding_completed.dart' as _i828;
import '../domain/usecases/auth/login_by_email_usecase.dart' as _i42;
import '../domain/usecases/auth/login_by_phone_usecase.dart' as _i498;
import '../domain/usecases/auth/login_with_email_password.dart' as _i768;
import '../domain/usecases/auth/login_with_email_usecase.dart' as _i524;
import '../domain/usecases/auth/login_with_phone_password.dart' as _i723;
import '../domain/usecases/auth/login_with_phone_usecase.dart' as _i400;
import '../domain/usecases/auth/logout_usecase.dart' as _i640;
import '../domain/usecases/auth/onboarding_completed.dart' as _i2;
import '../domain/usecases/auth/register_usecase.dart' as _i705;
import '../domain/usecases/auth/stream_auth_status.dart' as _i444;
import '../domain/usecases/category/add_category_usecase.dart' as _i445;
import '../domain/usecases/category/delete_category_usecase.dart' as _i292;
import '../domain/usecases/category/get_categories_usecase.dart' as _i961;
import '../domain/usecases/category/listen_to_categories_usecase.dart' as _i500;
import '../domain/usecases/category/update_category_usecase.dart' as _i986;
import '../domain/usecases/exchange_rate/listen_to_exchange_rate.dart' as _i397;
import '../domain/usecases/onboarding/get_onboarding_state.dart' as _i575;
import '../domain/usecases/onboarding/save_onboarding_state.dart' as _i243;
import '../domain/usecases/party/add_party_usecase.dart' as _i84;
import '../domain/usecases/party/delete_party_usecase.dart' as _i56;
import '../domain/usecases/party/get_parties_usecase.dart' as _i12;
import '../domain/usecases/party/listen_to_parties_usecase.dart' as _i714;
import '../domain/usecases/party/update_party_usecase.dart' as _i911;
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
import '../domain/usecases/wallet/add_wallet_usecase.dart' as _i80;
import '../domain/usecases/wallet/delete_wallet_usecase.dart' as _i62;
import '../domain/usecases/wallet/ensure_default_wallet_exists_usecase.dart'
    as _i225;
import '../domain/usecases/wallet/get_wallets_usecase.dart' as _i713;
import '../domain/usecases/wallet/listen_to_wallets_usecase.dart' as _i82;
import '../domain/usecases/wallet/update_wallet_usecase.dart' as _i418;
import '../presentation/auth/cubits/auth/auth_cubit.dart' as _i872;
import '../presentation/auth/cubits/login/login_cubit.dart' as _i15;
import '../presentation/auth/cubits/register/register_cubit.dart' as _i831;
import '../presentation/category/cubit/category_cubit.dart' as _i455;
import '../presentation/exchange_rate/cubit/exchange_rate_cubit.dart' as _i311;
import '../presentation/onboarding/cubit/onboarding_cubit.dart' as _i171;
import '../presentation/parties/cubit/party_cubit.dart' as _i841;
import '../presentation/transactions/cubit/transaction_cubit.dart' as _i117;
import '../presentation/wallets/cubit/wallet_cubit.dart' as _i1068;

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
  gh.factory<_i632.ExchangeRateRemoteDataSource>(
      () => _i632.ExchangeRateRemoteDataSourceImpl());
  gh.singleton<_i789.SharedPrefs>(() => _i789.SharedPrefsImpl());
  gh.factory<_i483.TokenManager>(() => const _i483.TokenManagerImpl());
  gh.factory<String>(
    () => injectHttpClientModule.devHttpUrl,
    instanceName: 'HttpUrl',
  );
  gh.singleton<_i683.PreferenceManager>(
      () => _i683.PreferenceManagerImpl()..init());
  gh.factory<_i655.PartyLocalDataSource>(
      () => _i655.PartyLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i276.AuthLocalDataSource>(
      () => _i276.AuthLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i849.WalletLocalDataSource>(
      () => _i849.WalletLocalDataSourceImpl(database: gh<_i704.AppDatabase>()));
  gh.factory<_i662.TransactionLocalDataSource>(
      () => _i662.TransactionLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.factory<_i148.CategoryLocalDataSource>(
      () => _i148.CategoryLocalDataSourceImpl(gh<_i704.AppDatabase>()));
  gh.lazySingleton<_i361.Dio>(
      () => injectHttpClientModule.dio(gh<String>(instanceName: 'HttpUrl')));
  gh.factory<_i558.CategoryRemoteDataSource>(
      () => _i558.CategoryRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i656.PartyRemoteDataSource>(
      () => _i656.PartyRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i463.CategorySyncHandler>(() => _i463.CategorySyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i558.CategoryRemoteDataSource>(),
      ));
  gh.factory<_i480.OnboardingLocalDataSource>(
      () => _i480.OnboardingLocalDataSourceImpl(gh<_i683.PreferenceManager>()));
  gh.factory<_i496.AuthRemoteDataSource>(
      () => _i496.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.factory<_i900.ExchangeRateLocalDataSource>(() =>
      _i900.ExchangeRateLocalDataSourceImpl(gh<_i683.PreferenceManager>()));
  gh.lazySingleton<_i410.CategoryRepository>(() => _i324.CategoryRepositoryImpl(
        syncHandler: gh<_i463.CategorySyncHandler>(),
        localDataSource: gh<_i148.CategoryLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
      ));
  gh.lazySingleton<_i280.PartySyncHandler>(() => _i280.PartySyncHandler(
        gh<_i704.AppDatabase>(),
        gh<_i656.PartyRemoteDataSource>(),
      ));
  gh.factory<_i624.WalletRemoteDataSource>(
      () => _i624.WalletRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i79.TransactionRemoteDataSource>(
      () => _i79.TransactionRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.singleton<_i1057.ExchangeRateRepository>(
      () => _i827.ExchangeRateRepositoryImpl(
            remoteDataSource: gh<_i632.ExchangeRateRemoteDataSource>(),
            localDataSource: gh<_i900.ExchangeRateLocalDataSource>(),
            onboardingLocalDataSource: gh<_i480.OnboardingLocalDataSource>(),
          ));
  gh.factory<_i986.UpdateCategoryUseCase>(
      () => _i986.UpdateCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i292.DeleteCategoryUseCase>(
      () => _i292.DeleteCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i445.AddCategoryUseCase>(
      () => _i445.AddCategoryUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i961.GetCategoriesUseCase>(
      () => _i961.GetCategoriesUseCase(gh<_i410.CategoryRepository>()));
  gh.singleton<_i867.OnboardingRepository>(() => _i386.OnboardingRepositoryImpl(
        gh<_i480.OnboardingLocalDataSource>(),
        gh<_i1057.ExchangeRateRepository>(),
      ));
  gh.lazySingleton<_i661.PartyRepository>(() => _i168.PartyRepositoryImpl(
        syncHandler: gh<_i280.PartySyncHandler>(),
        localDataSource: gh<_i655.PartyLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
      ));
  gh.singleton<_i800.AuthRepository>(() => _i135.AuthRepositoryImpl(
        remoteDataSource: gh<_i496.AuthRemoteDataSource>(),
        localDataSource: gh<_i276.AuthLocalDataSource>(),
        networkInfo: gh<_i6.NetworkInfo>(),
        tokenManager: gh<_i483.TokenManager>(),
        preferenceManager: gh<_i683.PreferenceManager>(),
      ));
  gh.factory<_i500.ListenToCategoriesUseCase>(
      () => _i500.ListenToCategoriesUseCase(gh<_i410.CategoryRepository>()));
  gh.factory<_i849.WalletSyncHandler>(() => _i849.WalletSyncHandler(
        remoteDataSource: gh<_i624.WalletRemoteDataSource>(),
        db: gh<_i704.AppDatabase>(),
      ));
  gh.lazySingleton<_i893.TransactionSyncHandler>(
      () => _i893.TransactionSyncHandler(
            gh<_i704.AppDatabase>(),
            gh<_i79.TransactionRemoteDataSource>(),
          ));
  gh.factory<_i705.RegisterUseCase>(
      () => _i705.RegisterUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i524.LoginWithEmailUseCase>(
      () => _i524.LoginWithEmailUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i400.LoginWithPhoneUseCase>(
      () => _i400.LoginWithPhoneUseCase(gh<_i800.AuthRepository>()));
  gh.factory<_i831.RegisterCubit>(
      () => _i831.RegisterCubit(gh<_i705.RegisterUseCase>()));
  gh.factory<_i42.LoginByEmailUsecase>(
      () => _i42.LoginByEmailUsecase(gh<_i800.AuthRepository>()));
  gh.factory<_i498.LoginByPhoneUsecase>(
      () => _i498.LoginByPhoneUsecase(gh<_i800.AuthRepository>()));
  gh.factory<_i828.IsOnboardingCompleted>(
      () => _i828.IsOnboardingCompleted(gh<_i800.AuthRepository>()));
  gh.factory<_i723.LoginWithPhonePassword>(
      () => _i723.LoginWithPhonePassword(gh<_i800.AuthRepository>()));
  gh.factory<_i444.StreamAuthStatus>(
      () => _i444.StreamAuthStatus(gh<_i800.AuthRepository>()));
  gh.factory<_i768.LoginWithEmailPassword>(
      () => _i768.LoginWithEmailPassword(gh<_i800.AuthRepository>()));
  gh.factory<_i2.OnboardingCompleted>(
      () => _i2.OnboardingCompleted(gh<_i800.AuthRepository>()));
  gh.factory<_i880.GetLoggedInUser>(
      () => _i880.GetLoggedInUser(gh<_i800.AuthRepository>()));
  gh.factory<_i243.SaveOnboardingState>(
      () => _i243.SaveOnboardingState(gh<_i867.OnboardingRepository>()));
  gh.factory<_i575.GetOnboardingState>(
      () => _i575.GetOnboardingState(gh<_i867.OnboardingRepository>()));
  gh.factory<_i56.DeletePartyUseCase>(
      () => _i56.DeletePartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i714.ListenToPartiesUseCase>(
      () => _i714.ListenToPartiesUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i911.UpdatePartyUseCase>(
      () => _i911.UpdatePartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i84.AddPartyUseCase>(
      () => _i84.AddPartyUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i12.GetPartiesUseCase>(
      () => _i12.GetPartiesUseCase(gh<_i661.PartyRepository>()));
  gh.factory<_i397.ListenExchangeRate>(
      () => _i397.ListenExchangeRate(gh<_i1057.ExchangeRateRepository>()));
  gh.factory<_i15.LoginCubit>(() => _i15.LoginCubit(
        gh<_i768.LoginWithEmailPassword>(),
        gh<_i723.LoginWithPhonePassword>(),
      ));
  gh.factory<_i455.CategoryCubit>(() => _i455.CategoryCubit(
        gh<_i445.AddCategoryUseCase>(),
        gh<_i986.UpdateCategoryUseCase>(),
        gh<_i292.DeleteCategoryUseCase>(),
        gh<_i961.GetCategoriesUseCase>(),
      ));
  gh.factory<_i640.LogoutUsecase>(
      () => _i640.LogoutUsecase(gh<_i800.AuthRepository>()));
  gh.lazySingleton<_i118.TransactionRepository>(
      () => _i114.TransactionRepositoryImpl(
            syncHandler: gh<_i893.TransactionSyncHandler>(),
            localDataSource: gh<_i662.TransactionLocalDataSource>(),
            db: gh<_i704.AppDatabase>(),
          ));
  gh.lazySingleton<_i368.WalletRepository>(() => _i305.WalletRepositoryImpl(
        syncHandler: gh<_i849.WalletSyncHandler>(),
        localDataSource: gh<_i849.WalletLocalDataSource>(),
        db: gh<_i704.AppDatabase>(),
      ));
  gh.factory<_i947.GetAllTransactionsUseCase>(
      () => _i947.GetAllTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i973.ListenToTransactionsUseCase>(() =>
      _i973.ListenToTransactionsUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i241.UpdateTransactionUseCase>(
      () => _i241.UpdateTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i163.DeleteTransactionUseCase>(
      () => _i163.DeleteTransactionUseCase(gh<_i118.TransactionRepository>()));
  gh.factory<_i171.OnboardingCubit>(() => _i171.OnboardingCubit(
        gh<_i575.GetOnboardingState>(),
        gh<_i243.SaveOnboardingState>(),
      ));
  gh.lazySingleton<Set<_i877.SyncTypeHandler<dynamic, dynamic, dynamic>>>(
      () => syncModule.provideSyncTypeHandlers(
            gh<_i893.TransactionSyncHandler>(),
            gh<_i463.CategorySyncHandler>(),
            gh<_i849.WalletSyncHandler>(),
            gh<_i280.PartySyncHandler>(),
          ));
  gh.factory<_i62.DeleteWalletUseCase>(
      () => _i62.DeleteWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i418.UpdateWalletUseCase>(
      () => _i418.UpdateWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i80.AddWalletUseCase>(
      () => _i80.AddWalletUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i713.GetWalletsUseCase>(
      () => _i713.GetWalletsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i669.CreateTransactionUseCase>(
      () => _i669.CreateTransactionUseCase(
            gh<_i118.TransactionRepository>(),
            gh<_i1057.ExchangeRateRepository>(),
          ));
  gh.factory<_i117.TransactionCubit>(() => _i117.TransactionCubit(
        getAllTransactionsUseCase: gh<_i1022.GetAllTransactionsUseCase>(),
        createTransactionUseCase: gh<_i1022.CreateTransactionUseCase>(),
        updateTransactionUseCase: gh<_i1022.UpdateTransactionUseCase>(),
        deleteTransactionUseCase: gh<_i1022.DeleteTransactionUseCase>(),
        listenToTransactionsUseCase: gh<_i1022.ListenToTransactionsUseCase>(),
      ));
  gh.factory<_i872.AuthCubit>(() => _i872.AuthCubit(
        gh<_i444.StreamAuthStatus>(),
        gh<_i880.GetLoggedInUser>(),
        gh<_i640.LogoutUsecase>(),
      ));
  gh.factory<_i82.ListenToWalletsUseCase>(
      () => _i82.ListenToWalletsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i225.EnsureDefaultWalletExistsUseCase>(() =>
      _i225.EnsureDefaultWalletExistsUseCase(gh<_i368.WalletRepository>()));
  gh.factory<_i841.PartyCubit>(() => _i841.PartyCubit(
        getPartiesUseCase: gh<_i12.GetPartiesUseCase>(),
        addPartyUseCase: gh<_i84.AddPartyUseCase>(),
        updatePartyUseCase: gh<_i911.UpdatePartyUseCase>(),
        deletePartyUseCase: gh<_i56.DeletePartyUseCase>(),
        listenToPartiesUseCase: gh<_i714.ListenToPartiesUseCase>(),
      ));
  gh.lazySingleton<_i646.SynchAppDatabase>(() => _i646.SynchAppDatabase(
        appDatabase: gh<_i704.AppDatabase>(),
        typeHandlers:
            gh<Set<_i877.SyncTypeHandler<dynamic, dynamic, dynamic>>>(),
        dio: gh<_i361.Dio>(),
        networkInfo: gh<_i6.NetworkInfo>(),
      ));
  gh.factory<_i311.ExchangeRateCubit>(
      () => _i311.ExchangeRateCubit(gh<_i397.ListenExchangeRate>()));
  gh.factory<_i1068.WalletCubit>(() => _i1068.WalletCubit(
        getWalletsUseCase: gh<_i713.GetWalletsUseCase>(),
        addWalletUseCase: gh<_i80.AddWalletUseCase>(),
        updateWalletUseCase: gh<_i418.UpdateWalletUseCase>(),
        deleteWalletUseCase: gh<_i62.DeleteWalletUseCase>(),
        listenToWalletsUseCase: gh<_i82.ListenToWalletsUseCase>(),
        ensureDefaultWalletExistsUseCase:
            gh<_i225.EnsureDefaultWalletExistsUseCase>(),
      ));
  return getIt;
}

class _$InjectHttpClientModule extends _i488.InjectHttpClientModule {}

class _$SyncModule extends _i680.SyncModule {}
