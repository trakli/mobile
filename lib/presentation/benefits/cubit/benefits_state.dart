part of 'benefits_cubit.dart';

@freezed
class BenefitsState with _$BenefitsState {
  const factory BenefitsState({
    required CloudBenefitEntity? cloudBenefits,
    required bool isLoading,
    required Failure failure,
  }) = _BenefitsState;

  factory BenefitsState.initial() => const BenefitsState(
    cloudBenefits: null,
    isLoading: false,
    failure: Failure.none(),
  );
}
