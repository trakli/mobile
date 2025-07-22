import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/domain/usecases/subscription/fetch_subscription_usecase.dart';

part 'plans_cubit.freezed.dart';
part 'plans_state.dart';

@injectable
class PlansCubit extends Cubit<PlansState> {
  final FetchSubscriptionPlans _fetchSubscriptionPlans;

  PlansCubit(this._fetchSubscriptionPlans) : super(const PlansState.initial());

  Future<void> fetchSubscriptionPlans() async {
    emit(const PlansState.loading());
    final result = await _fetchSubscriptionPlans("en");
    result.fold(
      (failure) => emit(PlansState.error(failure)),
      (subscription) => emit(PlansState.loaded(subscription)),
    );
  }
}
