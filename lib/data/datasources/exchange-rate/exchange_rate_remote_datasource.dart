import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/network/interceptors/logger_interceptor.dart';
import 'package:trakli/data/datasources/exchange-rate/dto/exchange_rate_dto.dart';

abstract class ExchangeRateRemoteDataSource {
  Future<ExchangeRateDto> getExchangeRate();
}

@Injectable(as: ExchangeRateRemoteDataSource)
class ExchangeRateRemoteDataSourceImpl implements ExchangeRateRemoteDataSource {
  late final Dio _dio;
  final String _baseUrl = 'https://open.er-api.com/';

  ExchangeRateRemoteDataSourceImpl() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    _dio.interceptors.addAll([
      LoggerInterceptor(),
    ]);
  }

  @override
  Future<ExchangeRateDto> getExchangeRate() {
    return ErrorHandler.handleApiCall(() async {
      // XAF is used as the default currency code for the app
      final response = await _dio.get('v6/latest/XAF');
      return ExchangeRateDto.fromJson(response.data);
    });
  }
}
