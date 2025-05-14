import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class GetLoggedInUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  GetLoggedInUser(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return _repository.getLoggedInUser();
  }
}
