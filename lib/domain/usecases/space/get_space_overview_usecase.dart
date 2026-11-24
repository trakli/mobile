import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

@injectable
class GetSpaceOverviewUseCase implements UseCase<SpaceOverviewEntity, String> {
  final SpaceRepository repository;

  GetSpaceOverviewUseCase(this.repository);

  @override
  Future<Either<Failure, SpaceOverviewEntity>> call(String params) {
    return repository.getOverview(params);
  }
}
