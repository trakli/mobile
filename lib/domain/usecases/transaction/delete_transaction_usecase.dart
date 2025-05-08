import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';

import '../../repositories/transaction_repository.dart';

@injectable
class DeleteTransactionUseCase implements UseCase<Unit, String> {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteTransaction(id);
  }
}
