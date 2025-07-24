import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/repositories/party_repository.dart';
import 'package:trakli/domain/entities/media_entity.dart';

@injectable
class AddPartyUseCase implements UseCase<Unit, AddPartyUseCaseParams> {
  final PartyRepository _repository;

  AddPartyUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AddPartyUseCaseParams params) async {
    return await _repository.insertParty(params.name,
        description: params.description,
        media: params.media,
        type: params.type);
  }
}

class AddPartyUseCaseParams {
  final String name;
  final String? description;
  final MediaEntity? media;
  final PartyType? type;

  AddPartyUseCaseParams({
    required this.name,
    this.description,
    this.media,
    this.type,
  });
}
