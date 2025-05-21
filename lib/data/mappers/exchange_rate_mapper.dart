import 'package:trakli/data/datasources/exchange-rate/dto/exchange_rate_dto.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';

class ExchangeRateMapper {
  static ExchangeRateEntity toDomain(ExchangeRateDto dto) {
    return ExchangeRateEntity(
      provider: dto.provider,
      baseCode: dto.baseCode,
      rates: dto.rates,
      timeLastUpdated: dto.timeLastUpdated,
      timeNextUpdated: dto.timeNextUpdated,
    );
  }
}
