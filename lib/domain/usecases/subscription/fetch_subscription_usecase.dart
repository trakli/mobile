import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/domain/repositories/subscription_repository.dart';

@injectable
class FetchSubscriptionPlans implements UseCase<SubscriptionEntity, FetchSubscriptionUseCaseParams> {
  final SubscriptionRepository _repository;

  FetchSubscriptionPlans(this._repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(FetchSubscriptionUseCaseParams params) {
    return _repository.fetchSubscriptionPlans(region: params.region);
  }
}

class FetchSubscriptionUseCaseParams {
  final String region;

  FetchSubscriptionUseCaseParams({
    required this.region,
  });
}
