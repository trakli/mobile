import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/repositories/party_repository.dart';

@injectable
class ListenToPartiesUseCase
    implements StreamUseCase<List<PartyEntity>, NoParams> {
  final PartyRepository _repository;

  ListenToPartiesUseCase(this._repository);

  @override
  Stream<Either<Failure, List<PartyEntity>>> call(NoParams params) {
    return _repository.listenToParties();
  }
}
