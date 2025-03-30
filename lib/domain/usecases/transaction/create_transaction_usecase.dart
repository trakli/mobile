import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
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
    );
  }
}

class CreateTransactionParams {
  final double amount;
  final String description;
  final String category;

  CreateTransactionParams({
    required this.amount,
    required this.description,
    required this.category,
  });
}
