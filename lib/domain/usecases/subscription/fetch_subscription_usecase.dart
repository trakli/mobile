import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/domain/repositories/subscription_repository.dart';

@injectable
class FetchSubscriptionPlans implements UseCase<SubscriptionEntity, String> {
  final SubscriptionRepository _repository;

  FetchSubscriptionPlans(this._repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(String region) {
    return _repository.fetchSubscriptionPlans(region: region);
  }
}
