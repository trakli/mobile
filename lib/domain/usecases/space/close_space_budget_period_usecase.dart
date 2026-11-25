import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/space_repository.dart';
import 'package:trakli/domain/usecases/space/get_space_budget_transactions_usecase.dart';

@injectable
class CloseSpaceBudgetPeriodUseCase implements UseCase<Unit, SpaceBudgetParams> {
  final SpaceRepository repository;

  CloseSpaceBudgetPeriodUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SpaceBudgetParams params) {
    return repository.closeBudgetPeriod(params.slug, params.budgetId);
  }
}
