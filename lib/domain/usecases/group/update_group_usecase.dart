import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

@injectable
class UpdateGroupUseCase implements UseCase<Unit, UpdateGroupUseCaseParams> {
  final GroupRepository _repository;

  UpdateGroupUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateGroupUseCaseParams params) async {
    return await _repository.updateGroup(
      params.clientId,
      name: params.name,
      description: params.description,
      icon: params.icon,
    );
  }
}

class UpdateGroupUseCaseParams {
  final String clientId;
  final String? name;
  final String? description;
  final MediaEntity? icon;

  UpdateGroupUseCaseParams({
    required this.clientId,
    this.name,
    this.description,
    this.icon,
  });
}
