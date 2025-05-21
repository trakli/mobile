import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/data/datasources/exchange-rate/dto/exchange_rate_dto.dart';

abstract class ExchangeRateLocalDataSource {
  Future<ExchangeRateDto?> getExchangeRate(String baseCurrency);
  Future<void> saveExchangeRate(
    String baseCurrency,
    ExchangeRateDto exchangeRate,
  );
}

@Injectable(as: ExchangeRateLocalDataSource)
class ExchangeRateLocalDataSourceImpl implements ExchangeRateLocalDataSource {
  final PreferenceManager _preferenceManager;

  ExchangeRateLocalDataSourceImpl(this._preferenceManager);

  @override
  Future<ExchangeRateDto?> getExchangeRate(String baseCurrency) async {
    final exchangeRate = await _preferenceManager.getExchangeRate(baseCurrency);
    return exchangeRate;
  }

  @override
  Future<void> saveExchangeRate(
      String baseCurrency, ExchangeRateDto exchangeRate) async {
    await _preferenceManager.saveExchangeRate(baseCurrency, exchangeRate);
  }
}
