import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class ListenToConfigsUseCase
    implements StreamUseCase<List<ConfigEntity>, NoParams> {
  final ConfigRepository _repository;

  ListenToConfigsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<ConfigEntity>>> call(NoParams params) {
    return _repository.listenToConfigs();
  }
}
