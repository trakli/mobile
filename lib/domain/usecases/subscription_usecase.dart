import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/models/plan.dart';
import 'package:trakli/domain/repositories/subscription_repository.dart';

@injectable
class GetSubscriptionUseCase implements UseCase<SubscriptionEntity, NoParams> {
  final SubscriptionRepository _repository;

  GetSubscriptionUseCase(this._repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(NoParams params) async {
    return await _repository.getSubscription();
  }
}
