import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await _authRepository.createUser(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      phone: params.phone,
      password: params.password,
      email: params.email,
    );
  }
}

class RegisterParams {
  final String firstName;
  final String? lastName;
  final String username;
  final String phone;
  final String password;
  final String email;

  const RegisterParams({
    required this.firstName,
    this.lastName,
    required this.username,
    required this.phone,
    required this.password,
    required this.email,
  });
}
