import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/configuration/dto/config_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/entities/config_entity.dart';

abstract class ConfigRemoteDataSource {
  Future<List<ConfigEntity>> getConfigs();
}

@Injectable(as: ConfigRemoteDataSource)
class CategoryRemoteDataSourceImpl implements ConfigRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<ConfigEntity>> getConfigs() async {
    final response = await dio.get('configurations');

    final apiResponse = ApiResponse.fromJson(response.data);

    if (apiResponse.data is List) {
      return (apiResponse.data as List)
          .map((e) => ConfigDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    }
    return [];
  }
}
