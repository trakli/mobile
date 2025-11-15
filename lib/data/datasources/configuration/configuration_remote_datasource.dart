import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/configuration/dto/config_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigRemoteDataSource {
  Future<List<ConfigEntity>> fetchConfigs();

  Future<ConfigEntity> getConfig({
    required String key,
  });

  Future<void> saveConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  });

  Future<void> updateConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  });

  Future<void> deleteConfig({
    required String key,
  });
}

@Injectable(as: ConfigRemoteDataSource)
class CategoryRemoteDataSourceImpl implements ConfigRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<ConfigEntity>> fetchConfigs() async {
    final response = await dio.get('configurations');

    final apiResponse = ApiResponse.fromJson(response.data);

    if (apiResponse.data is List) {
      return (apiResponse.data as List)
          .map((e) => ConfigDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    }
    return [];
  }

  @override
  Future<ConfigEntity> getConfig({
    required String key,
  }) async {
    final response = await dio.get(
      'configurations',
      queryParameters: {
        'key': key,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);

    return ConfigDto.fromJson(apiResponse.data).toEntity();
  }

  @override
  Future<void> saveConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  }) async {
    await dio.post(
      'configurations',
      data: {
        'key': key,
        'value': value,
        'type': type,
        'client_id': clientId,
      },
    );

    // final apiResponse = ApiResponse.fromJson(response.data);
    return;
  }

  @override
  Future<void> updateConfig({
    required String key,
    required String type,
    required String clientId,
    required dynamic value,
  }) async {
    await dio.put(
      'configurations',
      queryParameters: {
        'key': key,
      },
      data: {
        'value': value,
        'type': type,
        'client_id': clientId,
      },
    );

    // final apiResponse = ApiResponse.fromJson(response.data);
    return;
  }

  @override
  Future<void> deleteConfig({
    required String key,
  }) async {
    await dio.delete(
      'configurations',
      queryParameters: {
        'key': key,
      },
    );

    // final apiResponse = ApiResponse.fromJson(response.data);
    //
    // return ConfigDto.fromJson(apiResponse.data).toEntity();
    return;
  }
}
