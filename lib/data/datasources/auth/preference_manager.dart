import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/data/datasources/exchange-rate/dto/exchange_rate_dto.dart';

abstract class PreferenceManager {
  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> clearUserId();
  Future<void> clearAll();
  Future<void> onboardingCompleted();
  Future<bool> isOnboardingCompleted();
  Future<void> saveExchangeRate(
      String baseCurrency, ExchangeRateDto exchangeRate);
  Future<ExchangeRateDto?> getExchangeRate(String baseCurrency);

  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  SharedPreferences get prefs;
}

@Singleton(as: PreferenceManager)
class PreferenceManagerImpl implements PreferenceManager {
  late final SharedPreferences _prefs;

  @override
  SharedPreferences get prefs => _prefs;

  @override
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(KeyConstants.userIdKey, userId);
  }

  @override
  Future<void> onboardingCompleted() async {
    await _prefs.setBool(KeyConstants.onboardingCompletedKey, true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(KeyConstants.onboardingCompletedKey) ?? false;
  }

  @override
  Future<int?> getUserId() async {
    return _prefs.getInt(KeyConstants.userIdKey);
  }

  @override
  Future<void> clearUserId() async {
    await _prefs.remove(KeyConstants.userIdKey);
  }

  Future<void> initStart() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @postConstruct
  void init() {
    initStart();
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  @override
  Future<ExchangeRateDto?> getExchangeRate(String baseCurrency) async {
    final exchangeRate =
        _prefs.getString('${KeyConstants.exchangeRatePrefix}$baseCurrency');
    if (exchangeRate == null) {
      return null;
    }
    return ExchangeRateDto.fromJson(jsonDecode(exchangeRate));
  }

  @override
  Future<void> saveExchangeRate(
      String baseCurrency, ExchangeRateDto exchangeRate) async {
    _prefs.setString('${KeyConstants.exchangeRatePrefix}$baseCurrency',
        jsonEncode(exchangeRate.toJson()));
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  @override
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }
}
