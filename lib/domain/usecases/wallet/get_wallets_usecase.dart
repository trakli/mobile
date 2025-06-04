import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';

@injectable
class GetWalletsUseCase implements UseCase<List<WalletEntity>, NoParams> {
  final WalletRepository _repository;

  GetWalletsUseCase(this._repository);

  @override
  Future<Either<Failure, List<WalletEntity>>> call(NoParams params) async {
    return await _repository.getAllWallets();
  }
}
