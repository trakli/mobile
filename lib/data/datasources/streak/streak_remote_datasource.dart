import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/streak/dtos/streak_dto.dart';

abstract class StreakRemoteDataSource {
  Future<List<StreakDto>> getStreaks();
}

@Injectable(as: StreakRemoteDataSource)
class StreakRemoteDataSourceImpl implements StreakRemoteDataSource {
  final Dio dio;

  StreakRemoteDataSourceImpl({required this.dio});

  /// A user has at most one streak per type and period, so the largest page
  /// the API allows holds every one of them.
  @override
  Future<List<StreakDto>> getStreaks() async {
    final response = await ErrorHandler.handleApiCall(
      () => dio.get('streaks', queryParameters: {'limit': 100}),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    final page = apiResponse.data as Map? ?? const {};
    final items = page['data'] as List? ?? const [];
    return items
        .map(
            (item) => StreakDto.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }
}
