import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/repositories/party_repository.dart';

@injectable
class GetPartiesUseCase implements UseCase<List<PartyEntity>, NoParams> {
  final PartyRepository _repository;

  GetPartiesUseCase(this._repository);

  @override
  Future<Either<Failure, List<PartyEntity>>> call(NoParams params) async {
    return await _repository.getAllParties();
  }
}
