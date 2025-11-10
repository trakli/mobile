import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigRepository {
  Future<Either<Failure, List<ConfigEntity>>> getConfigs();
}
