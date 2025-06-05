import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@injectable
class EnsureDefaultWalletExistsUseCase
    implements UseCase<Unit, EnsureDefaultWalletParams> {
  final WalletRepository repository;

  EnsureDefaultWalletExistsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(EnsureDefaultWalletParams params) async {
    final hasWallet = await repository.hasAnyWallet();

    return hasWallet.fold(
      (failure) => Left(failure),
      (hasWallet) async {
        if (!hasWallet) {
          return await repository.insertWallet(
            params.name,
            params.type,
            0,
            params.currencyCode,
            description: params.description,
          );
        }
        return const Right(unit);
      },
    );
  }
}

class EnsureDefaultWalletParams {
  final String currencyCode;
  final String name;
  final WalletType type;
  final String? description;

  const EnsureDefaultWalletParams({
    required this.currencyCode,
    required this.name,
    required this.type,
    this.description,
  });
}
