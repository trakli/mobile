import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/feedback/dtos/feedback_dto.dart';

abstract class FeedbackRemoteDataSource {
  Future<List<FeedbackDto>> getFeedback();

  Future<FeedbackDto> submitFeedback({
    required String type,
    String? subject,
    required String message,
  });
}

@Injectable(as: FeedbackRemoteDataSource)
class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final Dio dio;

  FeedbackRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<FeedbackDto>> getFeedback() async {
    final response = await ErrorHandler.handleApiCall(
      () => dio.get('feedback'),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    final items = apiResponse.data as List? ?? const [];
    return items
        .map((item) =>
            FeedbackDto.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<FeedbackDto> submitFeedback({
    required String type,
    String? subject,
    required String message,
  }) async {
    final response = await ErrorHandler.handleApiCall(
      () => dio.post(
        'feedback',
        data: {
          'type': type,
          if (subject != null && subject.isNotEmpty) 'subject': subject,
          'message': message,
        },
      ),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return FeedbackDto.fromJson(
        (apiResponse.data as Map).cast<String, dynamic>());
  }
}
