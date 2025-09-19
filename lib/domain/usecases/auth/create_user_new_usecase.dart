import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class CreateUserNewUseCase
    implements UseCase<ApiResponse, CreateUserNewParams> {
  final AuthRepository _authRepository;

  CreateUserNewUseCase(this._authRepository);

  @override
  Future<Either<Failure, ApiResponse>> call(
    CreateUserNewParams params,
  ) async {
    return await _authRepository.createUserNew(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class CreateUserNewParams {
  final String email;
  final String password;
  final String firstName;
  final String? lastName;

  const CreateUserNewParams({
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName,
  });
}
