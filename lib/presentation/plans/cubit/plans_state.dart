part of 'plans_cubit.dart';

@freezed
class PlansState with _$PlansState {
  const factory PlansState({
    required SubscriptionEntity? subscription,
    required bool isLoading,
    required Failure failure,
  }) = _PlansState;

  factory PlansState.initial() => const PlansState(
    subscription: null,
    isLoading: false,
    failure: Failure.none(),
  );
}
