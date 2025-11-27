import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'dart:async';

abstract class ConfigRepository {
  Future<Either<Failure, List<ConfigEntity>>> getAllConfigs();

  Future<Either<Failure, ConfigEntity>> getConfigByKey(String key);

  Future<Either<Failure, ConfigEntity>> saveConfig({
    required String key,
    required ConfigType type,
    required dynamic value,
  });

  Future<Either<Failure, Unit>> updateConfig(
    String key, {
    ConfigType? type,
    dynamic value,
  });

  Future<Either<Failure, Unit>> deleteConfig(String key);

  Stream<Either<Failure, List<ConfigEntity>>> listenToConfigs();
}
