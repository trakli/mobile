part of 'config_cubit.dart';

@freezed
class ConfigState with _$ConfigState {
  const factory ConfigState({
    required List<ConfigEntity> configs,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
  }) = _ConfigState;

  factory ConfigState.initial() => const ConfigState(
    configs: [],
    isLoading: false,
    isSaving: false,
    isDeleting: false,
    failure: Failure.none(),
  );
}
