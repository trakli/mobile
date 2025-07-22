part of 'plans_cubit.dart';

@freezed
class PlansState with _$PlansState {
  const factory PlansState({
    required SubscriptionEntity? subscription,
    required bool isLoading,
    required bool isLoaded,
    required Failure failure,
  }) = _PlansState;

  factory PlansState.initial() => const PlansState(
    subscription: null,
    isLoading: false,
    isLoaded: false,
    failure: Failure.none(),
  );
}
