import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class CreateUserUsecase extends UseCase<void, CreateUserParams> {
  CreateUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(CreateUserParams params) {
    return _repository.createUser(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class CreateUserParams {
  final String email;
  final String password;
  final String name;

  CreateUserParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
