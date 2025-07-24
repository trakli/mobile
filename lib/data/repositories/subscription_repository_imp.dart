import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/subscription/subscription_remote_data_source.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/domain/repositories/subscription_repository.dart';

@Singleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remoteDataSource;

  SubscriptionRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, SubscriptionEntity>> fetchSubscriptionPlans({
    required String region,
  }) async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final response = await _remoteDataSource.fetchSubscriptionPlans(
        region: region,
      );
      return response.toEntity();
    });
  }
}
