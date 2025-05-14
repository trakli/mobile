import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserEntity>> createUser({
    required String firstName,
    required String email,
    required String password,
    String? lastName,
    String? username,
    String? phone,
  });

  Stream<AuthStatus> get authStatus;

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity>> getLoggedInUser();

  Future<Either<Failure, bool>> isOnboardingCompleted();

  Future<Either<Failure, Unit>> onboardingCompleted();
}
