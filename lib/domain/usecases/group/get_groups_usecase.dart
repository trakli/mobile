import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

@injectable
class GetGroupsUseCase implements UseCase<List<GroupEntity>, NoParams> {
  final GroupRepository _repository;

  GetGroupsUseCase(this._repository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(NoParams params) async {
    return await _repository.getAllGroups();
  }
}
