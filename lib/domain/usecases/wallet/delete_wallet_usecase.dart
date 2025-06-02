import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';

@injectable
class DeleteWalletUseCase implements UseCase<Unit, String> {
  final WalletRepository _repository;

  DeleteWalletUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String clientId) async {
    return await _repository.deleteWallet(clientId);
  }
}
