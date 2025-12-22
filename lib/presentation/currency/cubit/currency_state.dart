part of 'currency_cubit.dart';

@freezed
class CurrencyState with _$CurrencyState {
  const factory CurrencyState.initial() = _Initial;
  const factory CurrencyState.loading() = _Loading;
  const factory CurrencyState.loaded(Currency currency) = _Loaded;
  const factory CurrencyState.error(Failure failure) = _Error;

  const CurrencyState._();

  Currency? get currency => whenOrNull(
        loaded: (currency) => currency,
      );
}
