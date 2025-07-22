part of 'plans_cubit.dart';

@freezed
class PlansState with _$PlansState {
  const factory PlansState.initial() = _Initial;
  const factory PlansState.loading() = _Loading;
  const factory PlansState.loaded(SubscriptionEntity subscription) = _Loaded;
  const factory PlansState.error(Failure failure) = _Error;
}
