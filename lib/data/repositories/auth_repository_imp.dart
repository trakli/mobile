import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/auth/auth_local_data_source.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';
import 'package:trakli/data/datasources/auth/dto/auth_response_dto.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/data/mappers/user_mapper.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenManager _tokenManager;
  final PreferenceManager _preferenceManager;
  final _authStatusController = StreamController<AuthStatus>.broadcast();

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required TokenManager tokenManager,
    required PreferenceManager preferenceManager,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _tokenManager = tokenManager,
        _preferenceManager = preferenceManager;

  @override
  Stream<AuthStatus> get authStatus async* {
    final userId = await _preferenceManager.getUserId();

    if (userId != null) {
      final user = await _localDataSource.getUser(userId);
      if (user != null) {
        yield AuthStatus.authenticated;
      } else {
        yield AuthStatus.unauthenticated;
      }
    } else {
      yield AuthStatus.unauthenticated;
    }

    yield* _authStatusController.stream;
  }

  Future<UserEntity> _handleAuthResponse(
    AuthResponseDto authResponse, {
    bool shouldClearCache = false,
  }) async {
    final newUser = User.fromJson(authResponse.user);
    final currentUserId = await _preferenceManager.getUserId();
    if ((currentUserId != null && currentUserId != newUser.id) ||
        (shouldClearCache && currentUserId == null)) {
      await _localDataSource.clearDatabase();
    }
    await _tokenManager.persistToken(authResponse.accessToken);
    await _localDataSource.saveUser(newUser);
    await _preferenceManager.saveUserId(newUser.id);
    _authStatusController.add(AuthStatus.authenticated);
    return UserMapper.toDomain(newUser);
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      final authResponse = await _remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return _handleAuthResponse(authResponse, shouldClearCache: true);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> createUser({
    required String firstName,
    String? lastName,
    required String email,
    String? username,
    String? phone,
    required String password,
  }) async {
    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      final authResponse = await _remoteDataSource.createUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        password: password,
        email: email,
      );
      return _handleAuthResponse(authResponse);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      final authResponse = await _remoteDataSource.loginWithPhonePassword(
        phone: phone,
        password: password,
      );
      return _handleAuthResponse(authResponse, shouldClearCache: true);
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return RepositoryErrorHandler.handleApiCall<Unit>(() async {
      await _tokenManager.clearToken();
      await _preferenceManager.clearAll();
      await _localDataSource.deleteUser();
      await _localDataSource.clearDatabase();
      _authStatusController.add(AuthStatus.unauthenticated);

      return unit;
    });
  }

  void dispose() {
    _authStatusController.close();
  }

  @override
  Future<Either<Failure, UserEntity>> getLoggedInUser() async {
    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      final userId = await _preferenceManager.getUserId();

      if (userId == null) {
        throw NotFoundException('User not found');
      }

      final user = await _localDataSource.getUser(userId);

      if (user == null) {
        throw NotFoundException('User not found');
      }

      return UserMapper.toDomain(user);
    });
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    return RepositoryErrorHandler.handleApiCall<bool>(() async {
      return await _preferenceManager.isOnboardingCompleted();
    });
  }

  @override
  Future<Either<Failure, Unit>> onboardingCompleted() async {
    return RepositoryErrorHandler.handleApiCall<Unit>(() async {
      await _preferenceManager.onboardingCompleted();
      return unit;
    });
  }
}
