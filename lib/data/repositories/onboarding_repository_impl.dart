import 'dart:convert';
import 'package:currency_picker/currency_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';

@Injectable(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const String _currencyKey = 'selected_currency';

  // final SharedPrefs _prefs;
  final PreferenceManager _preferenceManager;

  OnboardingRepositoryImpl(this._preferenceManager);

  @override
  Future<Either<Failure, Unit>> saveOnboardingState(
      OnboardingEntity entity) async {
    return RepositoryErrorHandler.handleApiCall(() async {
      if (entity.selectedCurrency != null) {
        await _preferenceManager.prefs.setString(
            _currencyKey, jsonEncode(entity.selectedCurrency!.toJson()));
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, OnboardingEntity?>> getOnboardingState() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      // If no complete state exists, try to reconstruct from individual preferences
      final savedCurrencyCode =
          _preferenceManager.prefs.getString(_currencyKey);

      if (savedCurrencyCode == null) {
        return null;
      }

      return OnboardingEntity(
        selectedCurrency: Currency.from(json: jsonDecode(savedCurrencyCode)),
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> resetOnboarding() async {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _preferenceManager.prefs.remove(_currencyKey);
      return unit;
    });
  }
}
