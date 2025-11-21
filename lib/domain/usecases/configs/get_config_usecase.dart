import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class GetConfigUseCase implements UseCase<ConfigEntity, GetConfigUseCaseParams> {
  final ConfigRepository _repository;

  GetConfigUseCase(this._repository);

  @override
  Future<Either<Failure, ConfigEntity>> call(GetConfigUseCaseParams params) async {
    return await _repository.getConfigByKey(params.key);
  }
}

class GetConfigUseCaseParams {
  final String key;

  GetConfigUseCaseParams({
    required this.key,
  });
}

