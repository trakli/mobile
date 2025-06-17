import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';

@injectable
class UpdateWalletUseCase implements UseCase<Unit, UpdateWalletUseCaseParams> {
  final WalletRepository _repository;

  UpdateWalletUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateWalletUseCaseParams params) async {
    return await _repository.updateWallet(
      params.clientId,
      name: params.name,
      type: params.type,
      balance: params.balance,
      currency: params.currency,
      description: params.description,
      icon: params.icon,
    );
  }
}

class UpdateWalletUseCaseParams {
  final String clientId;
  final String? name;
  final WalletType? type;
  final double? balance;
  final String? currency;
  final String? description;
  final MediaEntity? icon;

  UpdateWalletUseCaseParams({
    required this.clientId,
    this.name,
    this.type,
    this.balance,
    this.currency,
    this.description,
    this.icon,
  });
}
