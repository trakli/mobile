import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class UpdateTransactionUseCase
    implements UseCase<Unit, UpdateTransactionParams> {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateTransactionParams params) async {
    return await repository.updateTransaction(
      params.id,
      params.amount,
      params.description,
      params.category,
    );
  }
}

class UpdateTransactionParams {
  final String id;
  final double? amount;
  final String? description;
  final String? category;

  UpdateTransactionParams({
    required this.id,
    this.amount,
    this.description,
    this.category,
  });
}
