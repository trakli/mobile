import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

class GetSpaceTransactionsParams {
  final String slug;
  final int page;
  final DateTime? startDate;
  final DateTime? endDate;
  const GetSpaceTransactionsParams({
    required this.slug,
    this.page = 1,
    this.startDate,
    this.endDate,
  });
}

@injectable
class GetSpaceTransactionsUseCase implements UseCase<SpacePage<SpaceTransactionEntity>, GetSpaceTransactionsParams> {
  final SpaceRepository repository;

  GetSpaceTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>> call(GetSpaceTransactionsParams params) {
    return repository.getTransactions(
      params.slug,
      page: params.page,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
