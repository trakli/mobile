import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/mappers/config_mapper.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigRemoteDataSource {
  Future<List<Config>> getAllConfigs({
    DateTime? syncedSince,
    bool? noClientId,
  });

  Future<Config?> getConfig(String id);

  Future<Config> insertConfig(Config config);

  Future<Config> updateConfig(Config config);

  Future<void> deleteConfig(String id);

  // Legacy methods for backward compatibility
  Future<List<ConfigEntity>> fetchConfigs();
}

@Injectable(as: ConfigRemoteDataSource)
class ConfigRemoteDataSourceImpl implements ConfigRemoteDataSource {
  final Dio dio;

  ConfigRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Config>> getAllConfigs({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (syncedSince != null) {
      queryParams['synced_since'] = formatServerIsoDateTimeString(syncedSince);
    }
    if (noClientId != null) {
      queryParams['no_client_id'] = noClientId;
    }
    final response =
        await dio.get('configurations', queryParameters: queryParams);

    final apiResponse = ApiResponse.fromJson(response.data);

    final paginatedResponse = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (Object? json) => Config.fromJson(
          JsonDefaultsHelper.addDefaults(json! as Map<String, dynamic>)),
    );

    return paginatedResponse.data;
  }

  @override
  Future<Config?> getConfig( String id) async {
    final response = await dio.get('configurations/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Config.fromJson(apiResponse.data);
  }

  @override
  Future<Config> insertConfig(Config config) async {
    final data = {
      'key': config.key,
      'type': config.type.serverKey,
      'value': config.value,
      'client_id': config.clientId,
      'created_at': formatServerIsoDateTimeString(config.createdAt),
    };

    final response = await dio.post('configurations', data: data);

    final apiResponse = ApiResponse.fromJson(response.data);
    return Config.fromJson(apiResponse.data);
  }

  @override
  Future<Config> updateConfig(Config config) async {
    final response = await dio.put(
      'configurations/${config.key}',
      data: {
        'type': config.type.serverKey,
        'value': config.value,
        'client_id': config.clientId,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Config.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteConfig(String id) async {
    await dio.delete('configurations/$id');
  }

  // Legacy methods for backward compatibility
  @override
  Future<List<ConfigEntity>> fetchConfigs() async {
    final configs = await getAllConfigs();
    return ConfigMapper.toDomainList(configs);
  }

}
