import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/domain/usecases/subscription/fetch_subscription_usecase.dart';


part 'plans_state.dart';
part 'plans_cubit.freezed.dart';

@injectable
class PlansCubit extends Cubit<PlansState> {
  final FetchSubscriptionPlans _fetchSubscriptionPlans;

  PlansCubit(this._fetchSubscriptionPlans) : super(PlansState.initial()){
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _fetchSubscriptionPlans(
      FetchSubscriptionUseCaseParams(region: "en"),
    );
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (subscription) => emit(state.copyWith(
        isLoading: false,
        subscription: subscription,
        failure: const Failure.none(),
      )),
    );
  }
}
