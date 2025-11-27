import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class GetConfigsUseCase implements UseCase<List<ConfigEntity>, NoParams> {
  final ConfigRepository _repository;

  GetConfigsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ConfigEntity>>> call(NoParams param) async {
    return await _repository.getAllConfigs();
  }
}
