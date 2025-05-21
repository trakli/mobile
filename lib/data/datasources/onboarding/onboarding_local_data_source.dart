import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/data/models/onboarding_model.dart';

abstract class OnboardingLocalDataSource {
  Future<void> saveOnboardingState(OnboardingModel model);
  Future<OnboardingModel?> getOnboardingState();
  Future<void> resetOnboarding();
}

@Injectable(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String _currencyKey = 'selected_currency';
  final PreferenceManager _preferenceManager;

  OnboardingLocalDataSourceImpl(this._preferenceManager);

  @override
  Future<void> saveOnboardingState(OnboardingModel model) async {
    if (model.selectedCurrency != null) {
      await _preferenceManager.prefs
          .setString(_currencyKey, jsonEncode(model.toJson()));
    }
  }

  @override
  Future<OnboardingModel?> getOnboardingState() async {
    final savedCurrencyCode = _preferenceManager.prefs.getString(_currencyKey);

    if (savedCurrencyCode == null) {
      return null;
    }

    final model = OnboardingModel.fromJson(jsonDecode(savedCurrencyCode));
    return model;
  }

  @override
  Future<void> resetOnboarding() async {
    await _preferenceManager.prefs.remove(_currencyKey);
  }
}
