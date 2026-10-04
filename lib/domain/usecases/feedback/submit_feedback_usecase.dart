import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/domain/repositories/feedback_repository.dart';

@injectable
class SubmitFeedbackUseCase
    implements UseCase<FeedbackEntity, SubmitFeedbackUseCaseParams> {
  final FeedbackRepository repository;

  SubmitFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, FeedbackEntity>> call(
    SubmitFeedbackUseCaseParams params,
  ) {
    return repository.submitFeedback(
      type: params.type,
      subject: params.subject,
      message: params.message,
    );
  }
}

class SubmitFeedbackUseCaseParams extends Equatable {
  final FeedbackType type;
  final String? subject;
  final String message;

  const SubmitFeedbackUseCaseParams({
    required this.type,
    this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [type, subject, message];
}
