import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/feedback/feedback_remote_datasource.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/domain/repositories/feedback_repository.dart';

@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource _remote;

  FeedbackRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedback() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final items = await _remote.getFeedback();
      return items.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, FeedbackEntity>> submitFeedback({
    required FeedbackType type,
    String? subject,
    required String message,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final item = await _remote.submitFeedback(
        type: type.serverKey,
        subject: subject,
        message: message,
      );
      return item.toEntity();
    });
  }
}
