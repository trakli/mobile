import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

@injectable
class GetSpaceMembersUseCase implements UseCase<List<SpaceMemberEntity>, String> {
  final SpaceRepository repository;

  GetSpaceMembersUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpaceMemberEntity>>> call(String params) {
    return repository.getMembers(params);
  }
}
