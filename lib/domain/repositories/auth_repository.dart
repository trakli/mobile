import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/data/datasources/auth/auth_local_data_source.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> createUser({
    required String email,
    required String password,
    required String name,
  });
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required TokenManager tokenManager,
  })  : _remoteDataSource = remoteDataSource,
        _tokenManager = tokenManager;

  @override
  Future<Either<Failure, Unit>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return RepositoryErrorHandler.handleApiCall<Unit>(() async {
      // Check network connection
      final authResponse = await _remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      // Save tokens locally
      await _tokenManager.persistToken(authResponse.accessToken);
      await _tokenManager.persistRefreshToken(authResponse.refreshToken);

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    return RepositoryErrorHandler.handleApiCall<Unit>(() async {
      final authResponse = await _remoteDataSource.createUser(
        email: email,
        password: password,
        name: name,
      );

      await _tokenManager.persistToken(authResponse.accessToken);
      await _tokenManager.persistRefreshToken(authResponse.refreshToken);

      return unit;
    });
  }
}
