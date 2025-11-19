import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class UpdateConfigUseCase implements UseCase<Unit, UpdateConfigUseCaseParams> {
  final ConfigRepository _repository;

  UpdateConfigUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateConfigUseCaseParams params) async {
    return await _repository.updateConfig(
      params.key,
      type: params.type,
      value: params.value,
    );
  }
}

class UpdateConfigUseCaseParams {
  final String key;
  final ConfigType? type;
  final dynamic value;

  UpdateConfigUseCaseParams({
    required this.key,
    this.type,
    this.value,
  });
}

