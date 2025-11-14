import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@injectable
class SaveConfigUseCase implements UseCase<void, SaveConfigUseCaseParams> {
  final ConfigRepository _repository;

  SaveConfigUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveConfigUseCaseParams param) async {
    return await _repository.saveConfig(
      key: param.key,
      type: param.type,
      clientId: param.clientId,
      value: param.value,
    );
  }
}

class SaveConfigUseCaseParams {
  final String key;
  final String type;
  final String clientId;
  final dynamic value;

  SaveConfigUseCaseParams({
    required this.key,
    required this.type,
    required this.clientId,
    required this.value,
  });
}
