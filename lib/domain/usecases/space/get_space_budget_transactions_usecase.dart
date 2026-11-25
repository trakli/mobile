import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

class SpaceBudgetParams {
  final String slug;
  final int budgetId;
  final int page;
  const SpaceBudgetParams({
    required this.slug,
    required this.budgetId,
    this.page = 1,
  });
}

@injectable
class GetSpaceBudgetTransactionsUseCase implements UseCase<SpacePage<SpaceTransactionEntity>, SpaceBudgetParams> {
  final SpaceRepository repository;

  GetSpaceBudgetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>> call(SpaceBudgetParams params) {
    return repository.getBudgetTransactions(
      params.slug,
      params.budgetId,
      page: params.page,
    );
  }
}
