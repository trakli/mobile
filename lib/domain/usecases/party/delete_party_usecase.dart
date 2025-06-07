import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/party_repository.dart';

@injectable
class DeletePartyUseCase implements UseCase<Unit, DeletePartyUseCaseParams> {
  final PartyRepository _repository;

  DeletePartyUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeletePartyUseCaseParams params) async {
    return await _repository.deleteParty(params.clientId);
  }
}

class DeletePartyUseCaseParams {
  final String clientId;

  DeletePartyUseCaseParams({
    required this.clientId,
  });
}
