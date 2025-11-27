import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'dart:async';

abstract class WalletRepository {
  Future<Either<Failure, List<WalletEntity>>> getAllWallets();

  Future<Either<Failure, WalletEntity>> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
    MediaEntity? icon,
  });

  Future<Either<Failure, WalletEntity>> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
    MediaEntity? icon,
  });

  Future<Either<Failure, Unit>> deleteWallet(String clientId);

  Stream<Either<Failure, List<WalletEntity>>> listenToWallets();

  Future<Either<Failure, bool>> hasAnyWallet();
}
