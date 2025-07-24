import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/subscription/dto/subscription_dto.dart';

abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionDto> fetchSubscriptionPlans({
    required String region,
  });
}

@Injectable(as: SubscriptionRemoteDataSource)
class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  SubscriptionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<SubscriptionDto> fetchSubscriptionPlans({
    required String region,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final response = await _dio.get(
        'cloud/plans',
        queryParameters: {'region': region},
      );
      final apiResponse = ApiResponse.fromJson(response.data);
      return SubscriptionDto.fromJson(apiResponse.data);
    });
  }
}
