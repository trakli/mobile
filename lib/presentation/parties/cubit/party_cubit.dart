import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/usecases/party/add_party_usecase.dart';
import 'package:trakli/domain/usecases/party/delete_party_usecase.dart';
import 'package:trakli/domain/usecases/party/get_parties_usecase.dart';
import 'package:trakli/domain/usecases/party/update_party_usecase.dart';
import 'package:trakli/domain/usecases/party/listen_to_parties_usecase.dart';

part 'party_state.dart';
part 'party_cubit.freezed.dart';

@injectable
class PartyCubit extends Cubit<PartyState> {
  final GetPartiesUseCase getPartiesUseCase;
  final AddPartyUseCase addPartyUseCase;
  final UpdatePartyUseCase updatePartyUseCase;
  final DeletePartyUseCase deletePartyUseCase;
  final ListenToPartiesUseCase listenToPartiesUseCase;
  StreamSubscription? _partiesSubscription;

  PartyCubit({
    required this.getPartiesUseCase,
    required this.addPartyUseCase,
    required this.updatePartyUseCase,
    required this.deletePartyUseCase,
    required this.listenToPartiesUseCase,
  }) : super(PartyState.initial()) {
    listenToParties();
  }

  Future<void> getParties() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));

    final result = await getPartiesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (parties) => emit(state.copyWith(
        isLoading: false,
        parties: parties,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> addParty(
    String name, {
    String? description,
    MediaEntity? media,
    required PartyType type,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));

    final result = await addPartyUseCase(
      AddPartyUseCaseParams(
        name: name,
        description: description,
        media: media,
        type: type,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> updateParty(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? media,
    required PartyType type,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));

    final result = await updatePartyUseCase(
      UpdatePartyUseCaseParams(
        clientId: clientId,
        name: name,
        description: description,
        media: media,
        type: type,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> deleteParty(String clientId) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));

    final result = await deletePartyUseCase(
      DeletePartyUseCaseParams(
        clientId: clientId,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isDeleting: false, failure: failure)),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  void listenToParties() {
    _partiesSubscription?.cancel();
    _partiesSubscription = listenToPartiesUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (parties) => emit(state.copyWith(
          parties: parties,
          failure: const Failure.none(),
        )),
      ),
    );
  }

  @override
  Future<void> close() {
    _partiesSubscription?.cancel();
    return super.close();
  }
}
