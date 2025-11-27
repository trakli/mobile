import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class SaveConfigUseCase
    implements UseCase<ConfigEntity, SaveConfigUseCaseParams> {
  final ConfigRepository _repository;

  SaveConfigUseCase(this._repository);

  @override
  Future<Either<Failure, ConfigEntity>> call(
      SaveConfigUseCaseParams params) async {
    return await _repository.saveConfig(
      key: params.key,
      type: params.type,
      value: params.value,
    );
  }
}

class SaveConfigUseCaseParams {
  final String key;
  final ConfigType type;
  final dynamic value;

  SaveConfigUseCaseParams({
    required this.key,
    required this.type,
    required this.value,
  });
}
