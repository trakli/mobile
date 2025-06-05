part of 'party_cubit.dart';

@freezed
class PartyState with _$PartyState {
  const factory PartyState({
    required List<PartyEntity> parties,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
  }) = _PartyState;

  factory PartyState.initial() => const PartyState(
        parties: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );
}
