import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class GetAllTransactionsUseCase implements UseCase<void, NoParams> {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(NoParams params) async {
    // return await repository.getAllTransactions();

    return right(
      [
        TransactionEntity(
          clientId: '1',
          amount: 100,
          description: 'Test',
          type: TransactionType.expense,
          datetime: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
    );
  }
}
