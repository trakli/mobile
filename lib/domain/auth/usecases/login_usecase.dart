import 'package:dartz/dartz.dart';
import 'package:trakli/core/error/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/auth/models/models.dart';
import 'package:trakli/domain/auth/entities/entities.dart';
import 'package:trakli/domain/auth/repositories/auth_repository.dart';

class LoginUsecase extends UseCase<LoginEntity, LoginBody> {
  LoginUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LoginEntity>> call(LoginBody params) {
    return _repository.requestLogin(params);
  }
}
