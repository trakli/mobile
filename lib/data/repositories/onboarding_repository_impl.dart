import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/onboarding/onboarding_local_data_source.dart';
import 'package:trakli/data/mappers/onboarding_mapper.dart';
import 'package:trakli/domain/entities/onboarding_entity.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';

@Injectable(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  OnboardingRepositoryImpl(
    this._localDataSource,
  );

  @override
  Future<Either<Failure, Unit>> saveOnboardingState(
      OnboardingEntity entity) async {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _localDataSource
          .saveOnboardingState(OnboardingMapper.toModel(entity));
      return unit;
    });
  }

  @override
  Future<Either<Failure, OnboardingEntity?>> getOnboardingState() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final model = await _localDataSource.getOnboardingState();
      return model != null ? OnboardingMapper.toEntity(model) : null;
    });
  }

  @override
  Future<Either<Failure, Unit>> resetOnboarding() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _localDataSource.resetOnboarding();
      return unit;
    });
  }
}
