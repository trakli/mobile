import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/exchange-rate/exchange_rate_local_datasource.dart';
import 'package:trakli/data/datasources/exchange-rate/exchange_rate_remote_datasource.dart';
import 'package:trakli/data/datasources/onboarding/onboarding_local_data_source.dart';
import 'package:trakli/data/mappers/exchange_rate_mapper.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';

@Singleton(as: ExchangeRateRepository)
class ExchangeRateRepositoryImpl extends ExchangeRateRepository {
  final ExchangeRateLocalDataSource localDataSource;
  final ExchangeRateRemoteDataSource remoteDataSource;
  final OnboardingLocalDataSource onboardingLocalDataSource;

  final _exchangeRateController =
      StreamController<ExchangeRateEntity>.broadcast();

  var defaultCurrencyCode = 'XAF';

  ExchangeRateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.onboardingLocalDataSource,
  });

  @override
  Stream<ExchangeRateEntity> get listenToExchangeRate async* {
    final exchangeRateDto =
        await localDataSource.getExchangeRate(defaultCurrencyCode);
    if (exchangeRateDto != null) {
      yield ExchangeRateMapper.toDomain(exchangeRateDto);
    }

    final exchangeRate =
        await localDataSource.getExchangeRate(defaultCurrencyCode);

    if (exchangeRate != null) {
      yield ExchangeRateMapper.toDomain(exchangeRate);
    }

    if ((exchangeRate == null) ||
        exchangeRate.timeNextUpdated.isBefore(DateTime.now())) {
      try {
        final exchangeRateRemote = await remoteDataSource.getExchangeRate();
        final exchangeRateEntity =
            ExchangeRateMapper.toDomain(exchangeRateRemote);

        await localDataSource.saveExchangeRate(
            exchangeRateRemote.baseCode, exchangeRateRemote);

        yield exchangeRateEntity;
      } on DioException catch (err) {
        throw ErrorHandler.handleDioException(err);
      } catch (error, stacktrace) {
        throw ErrorHandler.handleUnknownException(error, stacktrace);
      }
    }

    yield* _exchangeRateController.stream;
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> refreshExchangeRate() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final exchangeRateRemote = await remoteDataSource.getExchangeRate();

      await localDataSource.saveExchangeRate(
          exchangeRateRemote.baseCode, exchangeRateRemote);

      final exchangeRateEntity =
          ExchangeRateMapper.toDomain(exchangeRateRemote);

      _exchangeRateController.add(exchangeRateEntity);

      return exchangeRateEntity;
    });
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final exchangeRateRemote = await remoteDataSource.getExchangeRate();
      return ExchangeRateMapper.toDomain(exchangeRateRemote);
    });
  }
}
