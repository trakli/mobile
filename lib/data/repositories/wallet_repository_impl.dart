import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/wallet/wallet_local_datasource.dart';
import 'package:trakli/data/mappers/wallet_mapper.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, Wallet, String, int>
    implements WalletRepository {
  final WalletLocalDataSource localDataSource;

  WalletRepositoryImpl({
    required WalletSyncHandler syncHandler,
    required this.localDataSource,
    required super.db,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<WalletEntity>>> getAllWallets() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallets = await localDataSource.getAllWallets();
      return WalletMapper.toDomainList(wallets);
    });
  }

  @override
  Future<Either<Failure, Unit>> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallet = await localDataSource.insertWallet(
        name,
        type,
        balance,
        currency,
        description: description,
      );

      unawaited(put(wallet));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final existingWallet = await localDataSource.getWallet(clientId);
      if (existingWallet == null) {
        throw NotFoundException('Wallet not found');
      }

      final wallet = await localDataSource.updateWallet(
        clientId,
        name: name,
        type: type,
        balance: balance,
        currency: currency,
        description: description,
      );

      unawaited(put(wallet));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteWallet(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallet = await localDataSource.getWallet(clientId);
      if (wallet == null) {
        throw NotFoundException('Wallet not found');
      }

      await localDataSource.deleteWallet(clientId);
      unawaited(syncHandler.deleteRemote(wallet));
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<WalletEntity>>> listenToWallets() {
    return localDataSource.listenToWallets().map((wallets) {
      return Right(WalletMapper.toDomainList(wallets));
    });
  }

  // @override
  // Future<Either<Failure, Unit>> createDefaultWallet({
  //   required String name,
  //   required WalletType type,
  //   required int userId,
  //   String? description,
  //   String? currencyCode,
  // }) {
  //   return RepositoryErrorHandler.handleApiCall(() async {
  //     // First check if there are any wallets
  //     final wallets = await localDataSource.getAllWallets();

  //     // Only create default wallet if there are no wallets
  //     if (wallets.isEmpty) {
  //       final now = DateTime.now();

  //       await localDataSource.insertWallet(
  //         name,
  //         type,
  //         0.0, // Initial balance
  //         currencyCode ?? "USD",
  //         description: description,
  //       );
  //     }

  //     return Right(unit);
  //   });
  // }

  @override
  Future<Either<Failure, bool>> hasAnyWallet() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final wallets = await localDataSource.getAllWallets();
      return wallets.isNotEmpty;
    });
  }
}
