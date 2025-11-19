import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/repositories/wallet_repository.dart';

@injectable
class AddWalletUseCase implements UseCase<WalletEntity, AddWalletUseCaseParams> {
  final WalletRepository _repository;

  AddWalletUseCase(this._repository);

  @override
  Future<Either<Failure, WalletEntity>> call(AddWalletUseCaseParams params) async {
    return await _repository.insertWallet(
      params.name,
      params.type,
      params.balance,
      params.currency,
      description: params.description,
      icon: params.icon,
    );
  }
}

class AddWalletUseCaseParams {
  final String name;
  final WalletType type;
  final double balance;
  final String currency;
  final String? description;
  final MediaEntity? icon;

  AddWalletUseCaseParams({
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.description,
    this.icon,
  });
}
