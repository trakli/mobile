import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class DeleteConfigUseCase implements UseCase<Unit, DeleteConfigUseCaseParams> {
  final ConfigRepository _repository;

  DeleteConfigUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteConfigUseCaseParams params) async {
    return _repository.deleteConfig(params.key);
  }
}

class DeleteConfigUseCaseParams {
  final String key;

  DeleteConfigUseCaseParams({
    required this.key,
  });
}

