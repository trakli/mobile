import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

class CreateSpaceParams {
  final String name;
  final String? description;
  const CreateSpaceParams({required this.name, this.description});
}

@injectable
class CreateSpaceUseCase implements UseCase<SpaceEntity, CreateSpaceParams> {
  final SpaceRepository repository;

  CreateSpaceUseCase(this.repository);

  @override
  Future<Either<Failure, SpaceEntity>> call(CreateSpaceParams params) {
    return repository.createSpace(name: params.name, description: params.description);
  }
}
