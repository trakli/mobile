import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';

@injectable
class ListenExchangeRate
    implements NoEitherStreamUseCase<ExchangeRateEntity, NoParams> {
  late final ExchangeRateRepository repository;

  ListenExchangeRate(this.repository);

  @override
  Stream<ExchangeRateEntity> call(NoParams params) {
    return repository.listenToExchangeRate;
  }
}
