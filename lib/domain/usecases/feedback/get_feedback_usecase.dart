import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/domain/repositories/feedback_repository.dart';

@injectable
class GetFeedbackUseCase implements UseCase<List<FeedbackEntity>, NoParams> {
  final FeedbackRepository repository;

  GetFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, List<FeedbackEntity>>> call(NoParams params) {
    return repository.getFeedback();
  }
}
