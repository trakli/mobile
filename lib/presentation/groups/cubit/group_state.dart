part of 'group_cubit.dart';

@freezed
class GroupState with _$GroupState {
  const factory GroupState({
    @Default([]) List<GroupEntity> groups,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    @Default(Failure.none()) Failure failure,
  }) = _GroupState;

  factory GroupState.initial() => const GroupState();
}
