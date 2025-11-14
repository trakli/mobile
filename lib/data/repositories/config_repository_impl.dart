import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/configuration/configuration_remote_datasource.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@Singleton(as: ConfigRepository)
class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigRemoteDataSource _remoteDataSource;

  ConfigRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, List<ConfigEntity>>> getConfigs() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final response = await _remoteDataSource.fetchConfigs();
      return response;
    });
  }

  @override
  Future<Either<Failure, void>> saveConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  }) async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final response = await _remoteDataSource.saveConfig(
        key: key,
        type: type,
        clientId: clientId,
        value: value,
      );
      return response;
    });
  }
}
