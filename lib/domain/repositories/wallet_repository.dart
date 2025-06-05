import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'dart:async';

abstract class WalletRepository {
  Future<Either<Failure, List<WalletEntity>>> getAllWallets();

  Future<Either<Failure, Unit>> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
  });

  Future<Either<Failure, Unit>> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
  });

  Future<Either<Failure, Unit>> deleteWallet(String clientId);

  Stream<Either<Failure, List<WalletEntity>>> listenToWallets();

  // Future<Either<Failure, Unit>> createDefaultWallet({
  //   required String name,
  //   required WalletType type,
  //   required int userId,
  //   String? description,
  //   String? currencyCode,
  // });

  Future<Either<Failure, bool>> hasAnyWallet();
}
