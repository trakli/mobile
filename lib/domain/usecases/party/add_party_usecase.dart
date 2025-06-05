import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/party_repository.dart';

@injectable
class AddPartyUseCase implements UseCase<Unit, AddPartyUseCaseParams> {
  final PartyRepository _repository;

  AddPartyUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AddPartyUseCaseParams params) async {
    return await _repository.insertParty(
      params.name,
      description: params.description,
    );
  }
}

class AddPartyUseCaseParams {
  final String name;
  final String? description;

  AddPartyUseCaseParams({
    required this.name,
    this.description,
  });
}
