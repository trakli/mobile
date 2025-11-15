import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/usecases/configs/get_configs_usecase.dart';
import 'package:trakli/domain/usecases/configs/save_config_usecase.dart';

part 'config_cubit.freezed.dart';
part 'config_state.dart';

@injectable
class ConfigCubit extends Cubit<ConfigState> {
  final GetConfigsUseCase _getConfigsUseCase;
  final SaveConfigUseCase _saveConfigUseCase;

  ConfigCubit(
    this._getConfigsUseCase,
    this._saveConfigUseCase,
  ) : super(ConfigState.initial()) {
    getConfigs();
  }

  Future<void> getConfigs() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getConfigsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (configs) => emit(state.copyWith(
        isLoading: false,
        configs: configs,
        failure: const Failure.none(),
      )),
    );
  }

  //todo
  Future<void> saveConfig({required String clientId}) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _saveConfigUseCase(SaveConfigUseCaseParams(
      key: ConfigConstants.defaultLang,
      type: "string",
      clientId: clientId,
      value: 'en',
    ));

    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (configs) => emit(state.copyWith(
        isLoading: false,
        configs: state.configs,
        failure: const Failure.none(),
      )),
    );
  }
}
