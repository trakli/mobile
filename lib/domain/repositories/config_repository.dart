import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigRepository {
  Future<Either<Failure, List<ConfigEntity>>> fetchConfigs();

  Future<Either<Failure, ConfigEntity>> getConfig({
    required String key,
  });

  Future<Either<Failure, void>> saveConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  });
}
