import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

@injectable
class DeleteGroupUseCase implements UseCase<Unit, DeleteGroupUseCaseParams> {
  final GroupRepository _repository;

  DeleteGroupUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteGroupUseCaseParams params) async {
    return _repository.deleteGroup(params.clientId);
  }
}

class DeleteGroupUseCaseParams {
  final String clientId;

  DeleteGroupUseCaseParams({
    required this.clientId,
  });
}
