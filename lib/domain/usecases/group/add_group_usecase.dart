import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

@injectable
class AddGroupUseCase implements UseCase<GroupEntity, AddGroupUseCaseParams> {
  final GroupRepository _repository;

  AddGroupUseCase(this._repository);

  @override
  Future<Either<Failure, GroupEntity>> call(
      AddGroupUseCaseParams params) async {
    return await _repository.insertGroup(
      name: params.name,
      description: params.description,
      icon: params.icon,
    );
  }
}

class AddGroupUseCaseParams {
  final String name;
  final String? description;
  final MediaEntity? icon;

  AddGroupUseCaseParams({
    required this.name,
    this.description,
    this.icon,
  });
}
