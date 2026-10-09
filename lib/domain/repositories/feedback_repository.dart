import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';

/// Feedback lives on the server only; nothing is stored or synced locally.
abstract class FeedbackRepository {
  /// The user's own submissions, newest first.
  Future<Either<Failure, List<FeedbackEntity>>> getFeedback();

  Future<Either<Failure, FeedbackEntity>> submitFeedback({
    required FeedbackType type,
    String? subject,
    required String message,
  });
}
