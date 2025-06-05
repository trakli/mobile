import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/party_repository.dart';

@injectable
class UpdatePartyUseCase implements UseCase<Unit, UpdatePartyUseCaseParams> {
  final PartyRepository _repository;

  UpdatePartyUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdatePartyUseCaseParams params) async {
    return await _repository.updateParty(
      params.clientId,
      name: params.name,
      description: params.description,
    );
  }
}

class UpdatePartyUseCaseParams {
  final String clientId;
  final String? name;
  final String? description;

  UpdatePartyUseCaseParams({
    required this.clientId,
    this.name,
    this.description,
  });
}
