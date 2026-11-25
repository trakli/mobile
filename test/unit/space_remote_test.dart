import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/space/space_remote_datasource.dart';
import 'package:trakli/data/repositories/space_repository_impl.dart';
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
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/space_switcher_sheet.dart';

class _Reply {
  final int status;
  final String body;
  _Reply(this.status, this.body);
}

class _FixtureAdapter implements HttpClientAdapter {
  final Map<String, _Reply> replies;
  final List<RequestOptions> requests = [];

  _FixtureAdapter(this.replies);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final key = '${options.method} ${options.path}';
    final reply = replies[key];
    if (reply == null) throw StateError('No fixture for $key');
    return ResponseBody.fromString(
      reply.body,
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

_Reply _ok(String name) => _Reply(
      200,
      File('test/fixtures/spaces/$name').readAsStringSync(),
    );

_Reply _status(int status, String name) => _Reply(
      status,
      File('test/fixtures/spaces/$name').readAsStringSync(),
    );

const _slug = 'achu-family';

void main() {
  late _FixtureAdapter adapter;
  late SpaceRepositoryImpl repo;

  void serve(Map<String, _Reply> replies) {
    adapter = _FixtureAdapter(replies);
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost/api/v1/'))
      ..httpClientAdapter = adapter;
    repo = SpaceRepositoryImpl(remote: SpaceRemoteDataSourceImpl(dio: dio));
  }

  SpaceCubit cubitFor(SpaceRepositoryImpl r) => SpaceCubit(
        getSpaces: GetSpacesUseCase(r),
        createSpaceUseCase: CreateSpaceUseCase(r),
        getOverview: GetSpaceOverviewUseCase(r),
        getTransactions: GetSpaceTransactionsUseCase(r),
        getMembers: GetSpaceMembersUseCase(r),
        shareTransaction: ShareTransactionToSpaceUseCase(r),
        getBudgetTransactions: GetSpaceBudgetTransactionsUseCase(r),
        closeBudgetPeriodUseCase: CloseSpaceBudgetPeriodUseCase(r),
        previewInvitationUseCase: PreviewSpaceInvitationUseCase(r),
        acceptInvitationUseCase: AcceptSpaceInvitationUseCase(r),
        declineInvitationUseCase: DeclineSpaceInvitationUseCase(r),
        getActiveSlug: GetActiveSpaceSlugUseCase(r),
        setActiveSlug: SetActiveSpaceSlugUseCase(r),
      );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('SpaceRepository over captured responses', () {
    test('lists spaces with role, member count and create permission',
        () async {
      serve({'GET workspaces': _ok('workspaces_index.json')});
      final list = (await repo.getSpaces()).getOrElse((f) => throw f);
      expect(list.canCreate, isTrue);
      expect(list.spaces.single.slug, _slug);
      expect(list.spaces.single.name, 'Achu family');
      expect(list.spaces.single.role, SpaceRole.owner);
      expect(list.spaces.single.canManage, isTrue);
      expect(list.spaces.single.readOnly, isFalse);
      expect(list.spaces.single.memberCount, 1);
    });

    test('reads a member view of the same space', () async {
      serve({'GET workspaces': _ok('workspaces_index_member.json')});
      final s = (await repo.getSpaces()).getOrElse((f) => throw f).spaces.single;
      expect(s.role, SpaceRole.member);
      expect(s.canManage, isFalse);
      expect(s.memberCount, 2);
    });

    test('creates a space from name and description', () async {
      serve({'POST workspaces': _ok('workspace_create.json')});
      final s = (await repo.createSpace(
        name: 'Achu family',
        description: 'Home and groceries',
      ))
          .getOrElse((f) => throw f);
      expect(s.slug, _slug);
      expect(adapter.requests.single.data,
          {'name': 'Achu family', 'description': 'Home and groceries'});
    });

    test('parses finance with string budget amounts and progress', () async {
      serve({'GET workspaces/$_slug/finance': _ok('finance.json')});
      final o = (await repo.getOverview(_slug)).getOrElse((f) => throw f);
      final groceries = o.budgets.firstWhere((b) => b.name == 'Groceries');
      expect(groceries.amount, 600);
      expect(groceries.currency, 'EUR');
      expect(groceries.categoryIds, [81]);
      expect(groceries.progress!.periodEnd, DateTime(2026, 11, 30));
      expect(groceries.spent, 126);
      expect(groceries.remaining, 474);
      expect(o.categoryById(82)!.name, 'Utilities');
      expect(o.totals.map((t) => t.currency), containsAll(['USD', 'EUR']));
      expect(o.wallets, isNotEmpty);
    });

    test('pages transactions with date filters', () async {
      serve({'GET workspaces/$_slug/transactions': _ok('transactions.json')});
      final page = (await repo.getTransactions(
        _slug,
        startDate: DateTime(2026, 11, 1),
        endDate: DateTime(2026, 11, 24),
      ))
          .getOrElse((f) => throw f);
      expect(adapter.requests.single.queryParameters, {
        'page': 1,
        'start_date': '2026-11-01',
        'end_date': '2026-11-24',
      });
      expect(page.items, hasLength(4));
      final edf = page.items.first;
      expect(edf.description, 'EDF electricity');
      expect(edf.currency, 'USD');
      expect(edf.isIncome, isFalse);
      expect(edf.categoryIds, [82]);
      expect(edf.contributor, '');
      expect(page.lastPage, 1);
    });

    test('member without a name has a null display name', () async {
      serve({'GET workspaces/$_slug/members': _ok('members.json')});
      final members = (await repo.getMembers(_slug)).getOrElse((f) => throw f);
      expect(members.first.role, 'owner');
      expect(members.first.name, isNull);
    });

    test('shares, then labels the shared copy', () async {
      final shared = jsonDecode(
              File('test/fixtures/spaces/share_transaction.json')
                  .readAsStringSync())['data']['id'] as int;
      serve({
        'POST workspaces/$_slug/shares/transactions':
            _ok('share_transaction.json'),
        'PUT workspaces/$_slug/transactions/$shared/classification':
            _ok('classify_transaction.json'),
      });
      final tx = (await repo.shareTransaction(
        _slug,
        transactionId: 77,
        categoryIds: [82],
      ))
          .getOrElse((f) => throw f);
      expect(adapter.requests.first.data,
          {'transaction_id': 77, 'confirmed': true});
      expect(adapter.requests.last.data,
          containsPair('category_ids', [82]));
      expect(tx.source, SpaceTransactionSource.sharedTransaction);
    });

    test('shares without labelling when no label is chosen', () async {
      serve({
        'POST workspaces/$_slug/shares/transactions':
            _ok('share_transaction.json'),
      });
      await repo.shareTransaction(_slug, transactionId: 77);
      expect(adapter.requests, hasLength(1));
    });

    test('previews and accepts an invitation', () async {
      serve({
        'GET workspaces/invitations/tok': _ok('invitation_preview.json'),
        'POST workspaces/invitations/tok/accept':
            _ok('invitation_accept.json'),
      });
      final inv = (await repo.previewInvitation('tok'))
          .getOrElse((f) => throw f);
      expect(inv.workspaceName, 'Achu family');
      expect(inv.status, SpaceInvitationStatus.pending);
      expect(inv.invitedBy, isNull);
      final accepted =
          (await repo.acceptInvitation('tok')).getOrElse((f) => throw f);
      expect(accepted.workspaceSlug, _slug);
    });

    test('a refused action keeps the server explanation', () async {
      serve({
        'POST workspaces/$_slug/budgets/1/close-period':
            _status(403, 'close_period_forbidden.json'),
      });
      final failure = (await repo.closeBudgetPeriod(_slug, 1))
          .getLeft()
          .toNullable();
      expect(failure!.customMessage,
          'You do not have permission to access this workspace.');
    });

    test('an unknown invitation is not found', () async {
      serve({
        'GET workspaces/invitations/nope':
            _status(404, 'invitation_not_found.json'),
      });
      final failure =
          (await repo.previewInvitation('nope')).getLeft().toNullable();
      expect(failure, const Failure.notFound());
    });
  });

  group('SpaceCubit', () {
    Map<String, _Reply> spaceReplies() => {
          'GET workspaces': _ok('workspaces_index.json'),
          'GET workspaces/$_slug/finance': _ok('finance.json'),
          'GET workspaces/$_slug/transactions': _ok('transactions.json'),
          'GET workspaces/$_slug/members': _ok('members.json'),
          'GET workspaces/$_slug/budgets/1/transactions':
              _ok('budget_transactions.json'),
        };

    test('switching loads the space and remembers it', () async {
      serve(spaceReplies());
      final cubit = cubitFor(repo);
      await cubit.loadSpaces();
      await cubit.switchTo(_slug);

      expect(cubit.state.activeSpace!.name, 'Achu family');
      expect(cubit.state.overview!.budgets, isNotEmpty);
      expect(cubit.state.monthTransactions, hasLength(4));
      expect(cubit.state.latest, hasLength(4));
      expect(cubit.state.members, isNotEmpty);
      expect(cubit.state.failure, const Failure.none());
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SpaceRepositoryImpl.activeSpaceKey), _slug);

      await cubit.switchTo(null);
      expect(cubit.state.isPersonal, isTrue);
      expect(cubit.state.overview, isNull);
      expect(prefs.getString(SpaceRepositoryImpl.activeSpaceKey), isNull);
      await cubit.close();
    });

    test('restores the remembered space on start', () async {
      SharedPreferences.setMockInitialValues(
          {SpaceRepositoryImpl.activeSpaceKey: _slug});
      serve(spaceReplies());
      final cubit = cubitFor(repo);
      await cubit.restore();
      expect(cubit.state.activeSlug, _slug);
      expect(cubit.state.overview, isNotNull);
      await cubit.close();
    });

    test('falls back to Personal when the remembered space is gone',
        () async {
      SharedPreferences.setMockInitialValues(
          {SpaceRepositoryImpl.activeSpaceKey: 'left-this-one'});
      serve(spaceReplies());
      final cubit = cubitFor(repo);
      await cubit.restore();
      expect(cubit.state.isPersonal, isTrue);
      await cubit.close();
    });

    test('loads the transactions counted by a budget', () async {
      serve(spaceReplies());
      final cubit = cubitFor(repo);
      await cubit.loadSpaces();
      await cubit.switchTo(_slug);
      await cubit.loadBudget(1);
      expect(cubit.state.budgetTransactions[1], isNotEmpty);
      await cubit.close();
    });

    test('a refused period close surfaces as the failure', () async {
      serve({
        ...spaceReplies(),
        'POST workspaces/$_slug/budgets/1/close-period':
            _status(403, 'close_period_forbidden.json'),
      });
      final cubit = cubitFor(repo);
      await cubit.loadSpaces();
      await cubit.switchTo(_slug);
      await cubit.closePeriod(1);
      expect(cubit.state.isClosingPeriod, isFalse);
      expect(cubit.state.failure.customMessage,
          'You do not have permission to access this workspace.');
      await cubit.close();
    });
  });

  group('spaceInvitationToken', () {
    test('reads the token from an invitation link', () {
      expect(
        spaceInvitationToken('https://app.example.com/invitations/abc123?x=1'),
        'abc123',
      );
      expect(spaceInvitationToken('  abc123 '), 'abc123');
      expect(spaceInvitationToken('https://example.com/other'), isNull);
      expect(spaceInvitationToken(''), isNull);
    });
  });
}
