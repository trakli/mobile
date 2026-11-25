import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

@injectable
class DeclineSpaceInvitationUseCase implements UseCase<Unit, String> {
  final SpaceRepository repository;

  DeclineSpaceInvitationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.declineInvitation(params);
  }
}
