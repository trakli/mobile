import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';

@injectable
class ListenToWalletsUseCase
    implements StreamUseCase<List<WalletEntity>, NoParams> {
  final WalletRepository repository;

  ListenToWalletsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<WalletEntity>>> call(NoParams params) {
    return repository.listenToWallets();
  }
}
