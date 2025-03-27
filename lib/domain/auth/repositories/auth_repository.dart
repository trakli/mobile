import 'package:dartz/dartz.dart';
import 'package:trakli/core/error/failures.dart';
import 'package:trakli/data/auth/models/models.dart' show LoginBody;
import 'package:trakli/domain/auth/entities/entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> requestLogin(LoginBody body);
}
