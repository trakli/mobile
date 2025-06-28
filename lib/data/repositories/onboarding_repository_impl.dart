import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/onboarding/onboarding_local_data_source.dart';
import 'package:trakli/data/mappers/onboarding_mapper.dart';
import 'package:trakli/domain/entities/onboarding_entity.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';
import 'dart:async';

@Singleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;
  final ExchangeRateRepository _exchangeRateRepository;
  final _onboardingStateController =
      StreamController<OnboardingEntity?>.broadcast();

  OnboardingRepositoryImpl(
    this._localDataSource,
    this._exchangeRateRepository,
  );

  @override
  Future<Either<Failure, Unit>> saveOnboardingState(
      OnboardingEntity entity) async {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _localDataSource
          .saveOnboardingState(OnboardingMapper.toModel(entity));

      final code = entity.selectedCurrency?.code;

      if (code != null) {
        await _exchangeRateRepository.updateDefaultCurrency(code);
      }

      if (!_onboardingStateController.isClosed) {
        _onboardingStateController.add(entity);
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, OnboardingEntity?>> getOnboardingState() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      final model = await _localDataSource.getOnboardingState();
      final entity = model != null ? OnboardingMapper.toEntity(model) : null;
      _onboardingStateController.add(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, Unit>> resetOnboarding() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _localDataSource.resetOnboarding();
      _onboardingStateController.add(null);
      return unit;
    });
  }

  void dispose() {
    _onboardingStateController.close();
  }

  @override
  Stream<OnboardingEntity?> get onboardingState async* {
    final model = await _localDataSource.getOnboardingState();
    final entity = model != null ? OnboardingMapper.toEntity(model) : null;

    if (entity != null) {
      yield entity;
    }

    yield* _onboardingStateController.stream;
  }
}
