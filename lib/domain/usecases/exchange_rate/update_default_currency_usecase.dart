import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';

@injectable
class UpdateDefaultCurrencyUseCase
    implements UseCase<ExchangeRateEntity, UpdateDefaultCurrencyParams> {
  final ExchangeRateRepository _repository;

  UpdateDefaultCurrencyUseCase(this._repository);

  @override
  Future<Either<Failure, ExchangeRateEntity>> call(
      UpdateDefaultCurrencyParams params) async {
    return await _repository.updateDefaultCurrency(params.currencyCode);
  }
}

class UpdateDefaultCurrencyParams {
  final String currencyCode;

  const UpdateDefaultCurrencyParams({
    required this.currencyCode,
  });
}
