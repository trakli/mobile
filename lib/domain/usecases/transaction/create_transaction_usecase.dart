import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class CreateTransactionUseCase
    implements UseCase<Unit, CreateTransactionParams> {
  final TransactionRepository repository;
  final ExchangeRateRepository exchangeRateRepository;

  CreateTransactionUseCase(this.repository, this.exchangeRateRepository);

  @override
  Future<Either<Failure, Unit>> call(CreateTransactionParams params) async {
    return repository.insertTransaction(
      params.amount,
      params.description,
      params.categoryIds,
      params.type,
      params.datetime,
      params.walletClientId,
      partyClientId: params.partyClientId,
      groupClientId: params.groupClientId,
    );
  }
}

class CreateTransactionParams {
  final double amount;
  final String description;
  final List<String> categoryIds;
  final TransactionType type;
  final DateTime datetime;
  final String walletClientId;
  final String? partyClientId;
  final String? groupClientId;

  CreateTransactionParams({
    required this.amount,
    required this.description,
    required this.categoryIds,
    required this.type,
    required this.datetime,
    required this.walletClientId,
    this.partyClientId,
    this.groupClientId,
  });
}
