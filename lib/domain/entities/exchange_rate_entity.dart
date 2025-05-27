import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_entity.freezed.dart';

@freezed
abstract class ExchangeRateEntity with _$ExchangeRateEntity {
  const factory ExchangeRateEntity({
    required String provider,
    required String baseCode,
    required Map<String, double> rates,
    required DateTime timeLastUpdated,
    required DateTime timeNextUpdated,
  }) = _ExchangeRateEntity;
}
