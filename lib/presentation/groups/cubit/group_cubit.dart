import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';

part 'group_state.dart';
part 'group_cubit.freezed.dart';

@injectable
class GroupCubit extends Cubit<GroupState> {
  final GroupRepository _repository;
  StreamSubscription? _subscription;

  GroupCubit(this._repository) : super(const GroupState()) {
    _listenToGroups();
  }

  void _listenToGroups() {
    _subscription?.cancel();
    _subscription = _repository.listenToGroups().listen(
          (result) => result.fold(
            (failure) => emit(state.copyWith(failure: failure)),
            (groups) => emit(
                state.copyWith(groups: groups, failure: const Failure.none())),
          ),
        );
  }

  Future<void> getGroups() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getAllGroups();
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
    final result = await _repository.insertGroup(
      name: name,
      description: description,
      icon: media,
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
    final result = await _repository.updateGroup(
      clientId,
      name: name,
      description: description,
      icon: media,
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isSaving: false)),
      (_) =>
          emit(state.copyWith(failure: const Failure.none(), isSaving: false)),
    );
  }

  Future<void> deleteGroup(String clientId) async {
    emit(state.copyWith(isDeleting: true));
    final result = await _repository.deleteGroup(clientId);
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
