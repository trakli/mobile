import 'package:currency_picker/currency_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_model.freezed.dart';
part 'onboarding_model.g.dart';

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
class OnboardingModel with _$OnboardingModel {
  const factory OnboardingModel({
    @CurrencyConverter() Currency? selectedCurrency,
    String? defaultGroup,
    bool? editWalletAmount,
  }) = _OnboardingModel;

  const OnboardingModel._();

  factory OnboardingModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingModelFromJson(json);
}
