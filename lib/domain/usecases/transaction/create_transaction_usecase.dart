import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class CreateTransactionUseCase
    implements UseCase<Unit, CreateTransactionParams> {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateTransactionParams params) async {
    return repository.insertTransaction(
      params.amount,
      params.description,
      params.category,
      params.type,
      params.datetime,
    );
  }
}

class CreateTransactionParams {
  final double amount;
  final String description;
  final String category;
  final TransactionType type;
  final DateTime datetime;

  CreateTransactionParams({
    required this.amount,
    required this.description,
    required this.category,
    required this.type,
    required this.datetime,
  });
}
