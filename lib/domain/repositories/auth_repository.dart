import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/data/datasources/auth/auth_local_data_source.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';
import 'package:trakli/data/exceptions/server_exceptions.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required TokenManager tokenManager,
  })  : _remoteDataSource = remoteDataSource,
        _tokenManager = tokenManager,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Check network connection
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      // Call remote data source
      final authResponse = await _remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      // Save tokens locally
      await _tokenManager.persistToken(authResponse.accessToken);
      await _tokenManager.persistRefreshToken(authResponse.refreshToken);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
