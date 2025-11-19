import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@injectable
class EnsureDefaultWalletExistsUseCase
    implements UseCase<WalletEntity?, EnsureDefaultWalletParams> {
  final WalletRepository repository;

  EnsureDefaultWalletExistsUseCase(this.repository);

  @override
  Future<Either<Failure, WalletEntity?>> call(
      EnsureDefaultWalletParams params) async {
    final hasWallet = await repository.hasAnyWallet();

    return hasWallet.fold(
      (failure) => Left(failure),
      (hasWallet) async {
        if (!hasWallet) {
          return await repository.insertWallet(
            params.name,
            params.type,
            0.0,
            params.currencyCode,
            description: params.description,
            icon: params.icon,
          );
        }
        return const Right(null);
      },
    );
  }
}

class EnsureDefaultWalletParams {
  final String currencyCode;
  final String name;
  final WalletType type;
  final String? description;
  final MediaEntity? icon;

  const EnsureDefaultWalletParams({
    required this.currencyCode,
    required this.name,
    required this.type,
    this.description,
    this.icon,
  });
}
