import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart';
import 'package:trakli/domain/usecases/cloud_benefits/fetch_benefits_usecase.dart';

part 'benefits_cubit.freezed.dart';
part 'benefits_state.dart';

@injectable
class BenefitsCubit extends Cubit<BenefitsState> {
  final FetchBenefits _fetchBenefits;

  BenefitsCubit(this._fetchBenefits) : super(BenefitsState.initial()) {
    fetchBenefits();
  }

  Future<void> fetchBenefits() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _fetchBenefits(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (cloudBenefits) => emit(state.copyWith(
        isLoading: false,
        cloudBenefits: cloudBenefits,
        failure: const Failure.none(),
      )),
    );
  }
}
