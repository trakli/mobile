import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/core/util.dart';

part 'exchange_rate_dto.freezed.dart';
part 'exchange_rate_dto.g.dart';

@freezed
abstract class ExchangeRateDto with _$ExchangeRateDto {
  const factory ExchangeRateDto({
    @JsonKey(name: 'provider') required String provider,
    @JsonKey(name: 'base_code') required String baseCode,
    @JsonKey(name: 'rates') required Map<String, double> rates,
    @JsonKey(
        name: 'time_last_update_unix',
        fromJson: dateTimeFromUnixSeconds,
        toJson: dateTimeToUnixSeconds)
    required DateTime timeLastUpdated,
    @JsonKey(
        name: 'time_next_update_unix',
        fromJson: dateTimeFromUnixSeconds,
        toJson: dateTimeToUnixSeconds)
    required DateTime timeNextUpdated,
  }) = _ExchangeRateDto;

  factory ExchangeRateDto.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateDtoFromJson(json);
}
