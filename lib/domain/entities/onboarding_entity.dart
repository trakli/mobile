import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:currency_picker/currency_picker.dart';

part 'onboarding_entity.freezed.dart';
part 'onboarding_entity.g.dart';

class CurrencyConverter
    implements JsonConverter<Currency, Map<String, dynamic>> {
  const CurrencyConverter();

  @override
  Currency fromJson(Map<String, dynamic> json) {
    return Currency.from(json: json);
  }

  @override
  Map<String, dynamic> toJson(Currency currency) {
    return currency.toJson();
  }
}

@freezed
class OnboardingEntity with _$OnboardingEntity {
  const factory OnboardingEntity({
    @CurrencyConverter() Currency? selectedCurrency,
  }) = _OnboardingEntity;

  const OnboardingEntity._();

  bool get isOnboardingComplete => selectedCurrency != null;

  factory OnboardingEntity.fromJson(Map<String, dynamic> json) =>
      _$OnboardingEntityFromJson(json);
}
