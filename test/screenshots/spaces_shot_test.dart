import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/datasources/space/dto/space_dtos.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/share_to_space_sheet.dart';
import 'package:trakli/presentation/spaces/space_budget_screen.dart';
import 'package:trakli/presentation/spaces/space_home_view.dart';
import 'package:trakli/presentation/spaces/space_invitation_screen.dart';
import 'package:trakli/presentation/spaces/space_switcher_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class MockSpaceCubit extends Mock implements SpaceCubit {}

Map<String, dynamic> _data(String name) => Map<String, dynamic>.from(
      (jsonDecode(File('test/fixtures/spaces/$name').readAsStringSync())
          as Map)['data'] as Map,
    );

List<dynamic> _list(String name) =>
    (jsonDecode(File('test/fixtures/spaces/$name').readAsStringSync())
        as Map)['data'] as List;

SpaceState _state() {
  final spaces = SpaceListDto.fromJson(_data('workspaces_index.json'))
      .toEntity();
  final overview = SpaceOverviewDto.fromJson(_data('finance.json')).toEntity();
  final txs = SpacePageDto.transactions(_data('transactions.json')).items;
  final budgetTxs =
      SpacePageDto.transactions(_data('budget_transactions.json')).items;
  final members = _list('members.json')
      .map((m) => SpaceMemberDto.fromJson(Map<String, dynamic>.from(m as Map)))
      .toList();
  final slug = spaces.spaces.first.slug;
  return SpaceState.initial().copyWith(
    spaces: spaces.spaces,
    canCreate: spaces.canCreate,
    hasLoadedSpaces: true,
    activeSlug: slug,
    overview: overview,
    monthTransactions: txs,
    latest: txs,
    members: members,
    overviewsBySlug: {slug: overview},
    budgetTransactions: {overview.budgets.first.id: budgetTxs},
    invitation: SpaceInvitationDto.fromJson(_data('invitation_preview.json')),
  );
}

MockSpaceCubit _cubit(SpaceState state) {
  final cubit = MockSpaceCubit();
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  when(() => cubit.loadSpaces()).thenAnswer((_) async {});
  when(() => cubit.loadActive()).thenAnswer((_) async {});
  when(() => cubit.loadLabels(any())).thenAnswer((_) async {});
  return cubit;
}

Widget _sheetOver(Widget background, Widget sheet) {
  return Stack(
    children: [
      background,
      const ModalBarrier(color: Color(0x59000000)),
      Align(
        alignment: Alignment.bottomCenter,
        child: Builder(
          builder: (context) => Material(
            color: context.tones.bgSurface,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
            ),
            child: SafeArea(top: false, child: sheet),
          ),
        ),
      ),
    ],
  );
}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  late SpaceState state;
  setUp(() => state = _state());

  Widget wrap(Widget child, SpaceState s) => withShotProviders(
        child,
        extra: [BlocProvider<SpaceCubit>.value(value: _cubit(s))],
      );

  testWidgets('spaces', (tester) async {
    final personal = state.copyWith(activeSlug: null);
    await captureLedgerShots(
      tester,
      'spaces',
      (dark) => wrap(
        _sheetOver(HomeScreen(now: ShotData.now), const SpaceSwitcherSheet()),
        personal,
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('spaceHome', (tester) async {
    await captureLedgerShots(
      tester,
      'spaceHome',
      (dark) => wrap(
        Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.tones.bgPage,
            body: SafeArea(child: SpaceHomeView(now: ShotData.now)),
          ),
        ),
        state,
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('share', (tester) async {
    final tx = ShotData.transactions.firstWhere(
      (t) => t.transaction.id != null,
      orElse: () => ShotData.transactions.first,
    );
    await captureLedgerShots(
      tester,
      'share',
      (dark) => wrap(
        _sheetOver(
          HomeScreen(now: ShotData.now),
          ShareToSpaceSheet(
            transaction: tx,
            initialSlugs: [state.spaces.first.slug],
          ),
        ),
        state,
      ),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('invite', (tester) async {
    await captureLedgerShots(
      tester,
      'invite',
      (dark) => wrap(const SpaceInvitationScreen(token: 'tok'), state),
    );
  }, skip: !ledgerShotsEnabled);

  testWidgets('spaceBudget', (tester) async {
    final budget = state.overview!.budgets.first;
    await captureLedgerShots(
      tester,
      'spaceBudget',
      (dark) => wrap(
        SpaceBudgetScreen(budgetId: budget.id, now: ShotData.now),
        state,
      ),
    );
  }, skip: !ledgerShotsEnabled);

  test('fixture state carries what the screens need', () {
    expect(state.activeSpace, isNotNull);
    expect(state.overview!.budgets, isNotEmpty);
    expect(state.latest, isNotEmpty);
    expect(state.invitation!.status, SpaceInvitationStatus.pending);
  });
}
