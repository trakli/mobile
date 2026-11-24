part of 'space_cubit.dart';

@freezed
class SpaceState with _$SpaceState {
  const factory SpaceState({
    @Default([]) List<SpaceEntity> spaces,
    @Default(false) bool canCreate,
    @Default(false) bool hasLoadedSpaces,
    String? activeSlug,
    SpaceOverviewEntity? overview,
    @Default([]) List<SpaceTransactionEntity> monthTransactions,
    @Default([]) List<SpaceTransactionEntity> latest,
    @Default([]) List<SpaceMemberEntity> members,
    @Default({}) Map<int, List<SpaceTransactionEntity>> budgetTransactions,
    @Default({}) Map<String, SpaceOverviewEntity> overviewsBySlug,
    SpaceInvitationEntity? invitation,
    String? acceptedSlug,
    @Default(false) bool invitationDeclined,
    @Default(false) bool isLoadingSpaces,
    @Default(false) bool isLoadingSpace,
    @Default(false) bool isLoadingBudget,
    @Default(false) bool isCreating,
    @Default(false) bool isSharing,
    @Default(false) bool isClosingPeriod,
    @Default(false) bool isLoadingInvitation,
    @Default(false) bool isRespondingInvitation,
    @Default(0) int shareSuccessCount,
    @Default(Failure.none()) Failure failure,
  }) = _SpaceState;

  factory SpaceState.initial() => const SpaceState();

  const SpaceState._();

  bool get isPersonal => activeSlug == null;

  SpaceEntity? get activeSpace {
    for (final s in spaces) {
      if (s.slug == activeSlug) return s;
    }
    return null;
  }

  SpaceEntity? spaceBySlug(String slug) {
    for (final s in spaces) {
      if (s.slug == slug) return s;
    }
    return null;
  }
}
