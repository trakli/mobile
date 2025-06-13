import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

@injectable
class ListenToGroupsUseCase
    implements StreamUseCase<List<GroupEntity>, NoParams> {
  final GroupRepository _repository;

  ListenToGroupsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<GroupEntity>>> call(NoParams params) {
    return _repository.listenToGroups();
  }
}
