import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/usecases/space/accept_space_invitation_usecase.dart';
import 'package:trakli/domain/usecases/space/active_space_usecase.dart';
import 'package:trakli/domain/usecases/space/close_space_budget_period_usecase.dart';
import 'package:trakli/domain/usecases/space/create_space_usecase.dart';
import 'package:trakli/domain/usecases/space/decline_space_invitation_usecase.dart';
import 'package:trakli/domain/usecases/space/get_space_budget_transactions_usecase.dart';
import 'package:trakli/domain/usecases/space/get_space_members_usecase.dart';
import 'package:trakli/domain/usecases/space/get_space_overview_usecase.dart';
import 'package:trakli/domain/usecases/space/get_space_transactions_usecase.dart';
import 'package:trakli/domain/usecases/space/get_spaces_usecase.dart';
import 'package:trakli/domain/usecases/space/preview_space_invitation_usecase.dart';
import 'package:trakli/domain/usecases/space/share_transaction_to_space_usecase.dart';

part 'space_state.dart';
part 'space_cubit.freezed.dart';

@injectable
class SpaceCubit extends Cubit<SpaceState> {
  static const int maxPages = 8;

  final GetSpacesUseCase getSpaces;
  final CreateSpaceUseCase createSpaceUseCase;
  final GetSpaceOverviewUseCase getOverview;
  final GetSpaceTransactionsUseCase getTransactions;
  final GetSpaceMembersUseCase getMembers;
  final ShareTransactionToSpaceUseCase shareTransaction;
  final GetSpaceBudgetTransactionsUseCase getBudgetTransactions;
  final CloseSpaceBudgetPeriodUseCase closeBudgetPeriodUseCase;
  final PreviewSpaceInvitationUseCase previewInvitationUseCase;
  final AcceptSpaceInvitationUseCase acceptInvitationUseCase;
  final DeclineSpaceInvitationUseCase declineInvitationUseCase;
  final GetActiveSpaceSlugUseCase getActiveSlug;
  final SetActiveSpaceSlugUseCase setActiveSlug;

  SpaceCubit({
    required this.getSpaces,
    required this.createSpaceUseCase,
    required this.getOverview,
    required this.getTransactions,
    required this.getMembers,
    required this.shareTransaction,
    required this.getBudgetTransactions,
    required this.closeBudgetPeriodUseCase,
    required this.previewInvitationUseCase,
    required this.acceptInvitationUseCase,
    required this.declineInvitationUseCase,
    required this.getActiveSlug,
    required this.setActiveSlug,
  }) : super(SpaceState.initial());

  void _emit(SpaceState next) {
    if (!isClosed) emit(next);
  }

  Future<void> restore() async {
    final slug = await getActiveSlug();
    if (slug == null) return;
    _emit(state.copyWith(activeSlug: slug));
    await loadSpaces();
    if (state.activeSlug != null) await loadActive();
  }

  Future<void> loadSpaces() async {
    _emit(state.copyWith(
      isLoadingSpaces: true,
      failure: const Failure.none(),
    ));
    final result = await getSpaces(NoParams());
    result.fold(
      (failure) =>
          _emit(state.copyWith(isLoadingSpaces: false, failure: failure)),
      (list) {
        final activeGone = state.activeSlug != null &&
            !list.spaces.any((s) => s.slug == state.activeSlug);
        _emit(state.copyWith(
          isLoadingSpaces: false,
          hasLoadedSpaces: true,
          spaces: list.spaces,
          canCreate: list.canCreate,
        ));
        if (activeGone) switchTo(null);
      },
    );
  }

  /// Switches to [slug], or back to the personal ledger when null.
  Future<void> switchTo(String? slug) async {
    await setActiveSlug(slug);
    _emit(state.copyWith(
      activeSlug: slug,
      overview: null,
      monthTransactions: const [],
      latest: const [],
      members: const [],
      budgetTransactions: const {},
      failure: const Failure.none(),
    ));
    if (slug != null) await loadActive();
  }

  Future<void> loadActive({DateTime? now}) async {
    final slug = state.activeSlug;
    if (slug == null) return;
    _emit(state.copyWith(isLoadingSpace: true, failure: const Failure.none()));
    final today = now ?? DateTime.now();
    final monthStart = DateTime(today.year, today.month, 1);

    final overviewF = getOverview(slug);
    final monthF = _allPages(
      (page) => getTransactions(GetSpaceTransactionsParams(
        slug: slug,
        page: page,
        startDate: monthStart,
        endDate: today,
      )),
    );
    final latestF = getTransactions(GetSpaceTransactionsParams(slug: slug));
    final membersF = getMembers(slug);
    final overview = await overviewF;
    final month = await monthF;
    final latest = await latestF;
    final members = await membersF;
    if (state.activeSlug != slug) return;

    Failure? failure;
    void keep(Failure f) => failure ??= f;
    _emit(state.copyWith(
      isLoadingSpace: false,
      overview: overview.fold((f) {
        keep(f);
        return state.overview;
      }, (o) => o),
      monthTransactions: month.fold((f) {
        keep(f);
        return state.monthTransactions;
      }, (t) => t),
      latest: latest.fold((f) {
        keep(f);
        return state.latest;
      }, (p) => p.items),
      members: members.fold((f) {
        keep(f);
        return state.members;
      }, (m) => m),
      failure: failure ?? const Failure.none(),
    ));
  }

  Future<Either<Failure, List<SpaceTransactionEntity>>> _allPages(
    Future<Either<Failure, SpacePage<SpaceTransactionEntity>>> Function(
      int page,
    ) fetch,
  ) async {
    final items = <SpaceTransactionEntity>[];
    for (var page = 1; page <= maxPages; page++) {
      final result = await fetch(page);
      if (result.isLeft()) {
        return left(result.getLeft().toNullable()!);
      }
      final data = result.getRight().toNullable()!;
      items.addAll(data.items);
      if (page >= data.lastPage) break;
    }
    return right(items);
  }

  Future<SpaceEntity?> createSpace(String name, {String? description}) async {
    _emit(state.copyWith(isCreating: true, failure: const Failure.none()));
    final result = await createSpaceUseCase(
      CreateSpaceParams(name: name, description: description),
    );
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      _emit(state.copyWith(isCreating: false, failure: failure));
      return null;
    }
    final space = result.getRight().toNullable()!;
    _emit(state.copyWith(isCreating: false));
    await loadSpaces();
    await switchTo(space.slug);
    return space;
  }

  Future<void> loadLabels(String slug) async {
    if (state.overviewsBySlug.containsKey(slug)) return;
    final result = await getOverview(slug);
    result.fold(
      (failure) => _emit(state.copyWith(failure: failure)),
      (overview) => _emit(state.copyWith(
        overviewsBySlug: {...state.overviewsBySlug, slug: overview},
      )),
    );
  }

  /// Shares the transaction with server id [transactionId] into each space
  /// in [labelsBySlug], labelling it with the chosen category ids there.
  Future<bool> share(
    int transactionId,
    Map<String, List<int>> labelsBySlug,
  ) async {
    if (labelsBySlug.isEmpty) return false;
    _emit(state.copyWith(isSharing: true, failure: const Failure.none()));
    Failure? failure;
    var shared = 0;
    for (final entry in labelsBySlug.entries) {
      final result = await shareTransaction(ShareTransactionToSpaceParams(
        slug: entry.key,
        transactionId: transactionId,
        categoryIds: entry.value,
      ));
      result.fold((f) => failure ??= f, (_) => shared++);
    }
    _emit(state.copyWith(
      isSharing: false,
      shareSuccessCount: state.shareSuccessCount + shared,
      failure: failure ?? const Failure.none(),
    ));
    if (shared > 0 && labelsBySlug.containsKey(state.activeSlug)) {
      await loadActive();
    }
    return failure == null;
  }

  Future<void> loadBudget(int budgetId) async {
    final slug = state.activeSlug;
    if (slug == null) return;
    _emit(state.copyWith(isLoadingBudget: true, failure: const Failure.none()));
    final result = await _allPages(
      (page) => getBudgetTransactions(
        SpaceBudgetParams(slug: slug, budgetId: budgetId, page: page),
      ),
    );
    result.fold(
      (f) => _emit(state.copyWith(isLoadingBudget: false, failure: f)),
      (items) => _emit(state.copyWith(
        isLoadingBudget: false,
        budgetTransactions: {...state.budgetTransactions, budgetId: items},
      )),
    );
  }

  Future<void> closePeriod(int budgetId) async {
    final slug = state.activeSlug;
    if (slug == null) return;
    _emit(state.copyWith(isClosingPeriod: true, failure: const Failure.none()));
    final result = await closeBudgetPeriodUseCase(
      SpaceBudgetParams(slug: slug, budgetId: budgetId),
    );
    await result.fold(
      (failure) async =>
          _emit(state.copyWith(isClosingPeriod: false, failure: failure)),
      (_) async {
        _emit(state.copyWith(isClosingPeriod: false));
        await loadActive();
        await loadBudget(budgetId);
      },
    );
  }

  Future<void> previewInvitation(String token) async {
    _emit(state.copyWith(
      isLoadingInvitation: true,
      invitation: null,
      acceptedSlug: null,
      invitationDeclined: false,
      failure: const Failure.none(),
    ));
    final result = await previewInvitationUseCase(token);
    result.fold(
      (failure) =>
          _emit(state.copyWith(isLoadingInvitation: false, failure: failure)),
      (invitation) => _emit(state.copyWith(
        isLoadingInvitation: false,
        invitation: invitation,
      )),
    );
  }

  Future<void> acceptInvitation(String token) async {
    _emit(state.copyWith(
      isRespondingInvitation: true,
      failure: const Failure.none(),
    ));
    final result = await acceptInvitationUseCase(token);
    await result.fold(
      (failure) async => _emit(state.copyWith(
        isRespondingInvitation: false,
        failure: failure,
      )),
      (accepted) async {
        await loadSpaces();
        await switchTo(accepted.workspaceSlug);
        _emit(state.copyWith(
          isRespondingInvitation: false,
          acceptedSlug: accepted.workspaceSlug,
        ));
      },
    );
  }

  Future<void> declineInvitation(String token) async {
    _emit(state.copyWith(
      isRespondingInvitation: true,
      failure: const Failure.none(),
    ));
    final result = await declineInvitationUseCase(token);
    result.fold(
      (failure) => _emit(state.copyWith(
        isRespondingInvitation: false,
        failure: failure,
      )),
      (_) => _emit(state.copyWith(
        isRespondingInvitation: false,
        invitationDeclined: true,
      )),
    );
  }
}
