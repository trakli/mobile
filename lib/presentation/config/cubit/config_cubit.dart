import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/usecases/configs/get_configs_usecase.dart';

part 'config_cubit.freezed.dart';
part 'config_state.dart';

@injectable
class ConfigCubit extends Cubit<ConfigState> {
  final GetConfigsUseCase _getConfigsUseCase;

  ConfigCubit(this._getConfigsUseCase) : super(ConfigState.initial()) {
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
}
