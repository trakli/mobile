import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/benefits/dto/cloud_benefit_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';

abstract class CloudBenefitRemoteDataSource {
  Future<CloudBenefitDto> fetchCloudBenefits();
}

@Injectable(as: CloudBenefitRemoteDataSource)
class CloudBenefitRemoteDataSourceImpl implements CloudBenefitRemoteDataSource {
  CloudBenefitRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CloudBenefitDto> fetchCloudBenefits() async {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.get(
        'cloud/benefits',
      );
      final apiResponse = ApiResponse.fromJson(response.data);
      return CloudBenefitDto.fromJson(apiResponse.data);
    });
  }
}
