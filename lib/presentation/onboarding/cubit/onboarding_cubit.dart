import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/onboarding_entity.dart';
import 'package:trakli/domain/usecases/onboarding/get_onboarding_state.dart';
import 'package:trakli/domain/usecases/onboarding/save_onboarding_state.dart';

part 'onboarding_state.dart';
part 'onboarding_cubit.freezed.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingState _getOnboardingState;
  final SaveOnboardingState _saveOnboardingState;

  OnboardingCubit(
    this._getOnboardingState,
    this._saveOnboardingState,
  ) : super(const OnboardingState.initial());

  Future<void> getOnboardingState() async {
    emit(const OnboardingState.loading());

    final result = await _getOnboardingState(NoParams());

    result.fold(
      (failure) => emit(OnboardingState.error(failure)),
      (entity) =>
          emit(OnboardingState.success(entity ?? const OnboardingEntity())),
    );
  }

  Future<void> saveOnboardingState(OnboardingEntity entity) async {
    emit(const OnboardingState.loading());

    final result =
        await _saveOnboardingState(SaveOnboardingStateParams(entity: entity));

    result.fold(
      (failure) => emit(OnboardingState.error(failure)),
      (_) => emit(OnboardingState.success(entity)),
    );
  }

  void selectCurrency(Currency currency) {
    final entity = state.entity?.copyWith(selectedCurrency: currency);
    if (entity != null) {
      saveOnboardingState(entity);
    }
  }
}
