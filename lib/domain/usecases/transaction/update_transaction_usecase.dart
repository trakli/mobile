import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class UpdateTransactionUseCase
    implements UseCase<Unit, UpdateTransactionParams> {
  final TransactionRepository repository;
  final ExchangeRateRepository exchangeRateRepository;

  UpdateTransactionUseCase(this.repository, this.exchangeRateRepository);

  @override
  Future<Either<Failure, Unit>> call(UpdateTransactionParams params) async {

    return repository.updateTransaction(
      params.id,
      params.amount,
      params.description,
      params.categoryIds,
      params.datetime,
      params.walletClientId,
    );
    // });
  }
}

class UpdateTransactionParams {
  final String id;
  final double? amount;
  final String? description;
  final List<String>? categoryIds;
  final DateTime? datetime;
  final String? currency;
  final String? walletClientId;

  UpdateTransactionParams({
    required this.id,
    this.amount,
    this.description,
    this.categoryIds,
    this.datetime,
    this.currency,
    this.walletClientId,
  });
}
