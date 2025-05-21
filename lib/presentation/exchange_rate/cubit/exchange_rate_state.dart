part of 'exchange_rate_cubit.dart';

@freezed
class ExchangeRateState with _$ExchangeRateState {
  const factory ExchangeRateState.initial() = _Initial;
  const factory ExchangeRateState.success(ExchangeRateEntity entity) = _Success;

  const ExchangeRateState._();

  ExchangeRateEntity? get entity =>
      this is _Success ? (this as _Success).entity : null;
}
