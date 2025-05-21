part of 'onboarding_cubit.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.loading() = _Loading;
  const factory OnboardingState.success(OnboardingEntity entity) = _Success;
  const factory OnboardingState.error(Failure failure) = _Error;

  const OnboardingState._();

  OnboardingEntity? get entity =>
      this is _Success ? (this as _Success).entity : null;

  String? get currencySymbol => this is _Success
      ? (this as _Success).entity.selectedCurrency?.symbol
      : null;
}

// Create state
