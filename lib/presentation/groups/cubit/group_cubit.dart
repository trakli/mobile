import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/usecases/group/add_group_usecase.dart';
import 'package:trakli/domain/usecases/group/delete_group_usecase.dart';
import 'package:trakli/domain/usecases/group/update_group_usecase.dart';
import 'package:trakli/domain/usecases/group/get_groups_usecase.dart';
import 'package:trakli/domain/usecases/group/listen_to_groups_usecase.dart';
import 'package:trakli/domain/usecases/group/ensure_default_group_exists_usecase.dart';
import 'package:trakli/core/usecases/usecase.dart';

part 'group_state.dart';
part 'group_cubit.freezed.dart';

@injectable
class GroupCubit extends Cubit<GroupState> {
  final GetGroupsUseCase _getGroupsUseCase;
  final AddGroupUseCase _addGroupUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final DeleteGroupUseCase _deleteGroupUseCase;
  final ListenToGroupsUseCase _listenToGroupsUseCase;
  final EnsureDefaultGroupExistsUseCase _ensureDefaultWalletExistsUseCase;
  StreamSubscription? _subscription;

  GroupCubit(
    this._getGroupsUseCase,
    this._addGroupUseCase,
    this._updateGroupUseCase,
    this._deleteGroupUseCase,
    this._listenToGroupsUseCase,
    this._ensureDefaultWalletExistsUseCase,
  ) : super(const GroupState()) {
    _listenToGroups();
  }

  void _listenToGroups() {
    _subscription?.cancel();
    _subscription = _listenToGroupsUseCase(NoParams()).listen(
      (result) => result.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (groups) =>
            emit(state.copyWith(groups: groups, failure: const Failure.none())),
      ),
    );
  }

  Future<void> getGroups() async {
    emit(state.copyWith(isLoading: true));
    final result = await _getGroupsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
      (groups) => emit(state.copyWith(
          groups: groups, failure: const Failure.none(), isLoading: false)),
    );
  }

  Future<void> addGroup(
    String name, {
    String? description,
    MediaEntity? media,
  }) async {
    emit(state.copyWith(isSaving: true));
    final result = await _addGroupUseCase(
      AddGroupUseCaseParams(
        name: name,
        description: description,
        icon: media,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isSaving: false)),
      (_) =>
          emit(state.copyWith(failure: const Failure.none(), isSaving: false)),
    );
  }

  Future<void> updateGroup(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? media,
  }) async {
    emit(state.copyWith(isSaving: true));
    final result = await _updateGroupUseCase(
      UpdateGroupUseCaseParams(
        clientId: clientId,
        name: name,
        description: description,
        icon: media,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isSaving: false)),
      (_) =>
          emit(state.copyWith(failure: const Failure.none(), isSaving: false)),
    );
  }

  Future<void> ensureDefaultGroup({
    required String name,
    String? description,
    MediaEntity? media,
  }) async {
    emit(state.copyWith(isSaving: true));
    final result = await _ensureDefaultWalletExistsUseCase(
      EnsureDefaultGroupParams(
        name: name,
        description: description,
        icon: media,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isSaving: false)),
      (_) =>
          emit(state.copyWith(failure: const Failure.none(), isSaving: false)),
    );
  }

  Future<void> deleteGroup(String clientId) async {
    emit(state.copyWith(isDeleting: true));
    final result = await _deleteGroupUseCase(
      DeleteGroupUseCaseParams(clientId: clientId),
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isDeleting: false)),
      (_) => emit(
          state.copyWith(failure: const Failure.none(), isDeleting: false)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
