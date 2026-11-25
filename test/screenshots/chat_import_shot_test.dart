import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/entities/import/duplicate_match_entity.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/entities/import/import_session_status.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/presentation/ai_chat/ai_chat_screen.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/dictation/dictation_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockAiChatCubit extends Mock implements AiChatCubit {}

class _MockDictationCubit extends Mock implements DictationCubit {}

class _MockImportCubit extends Mock implements ImportCubit {}

T _stub<T extends StateStreamableSource<S>, S>(T cubit, S state) {
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  return cubit;
}

final _cashWallet = ShotData.cash.copyWith(id: 4);

List<BlocProvider> _lookupProviders() {
  final wallets = _stub(
    MockWalletCubit(),
    WalletState.initial().copyWith(
      wallets: [
        ...ShotData.wallets.where((w) => w != ShotData.cash),
        _cashWallet
      ],
    ),
  );
  when(() => wallets.loadWallets()).thenAnswer((_) async {});
  final parties = _stub(
    MockPartyCubit(),
    PartyState.initial().copyWith(parties: ShotData.parties),
  );
  when(() => parties.getParties()).thenAnswer((_) async {});
  final categories = _stub(
    MockCategoryCubit(),
    CategoryState.initial().copyWith(categories: ShotData.categories),
  );
  when(() => categories.loadCategories()).thenAnswer((_) async {});
  return [
    BlocProvider<WalletCubit>.value(value: wallets),
    BlocProvider<PartyCubit>.value(value: parties),
    BlocProvider<CategoryCubit>.value(value: categories),
  ];
}

AiChatState _chatState() {
  final now = DateTime.now();
  final today = now.toIso8601String();
  final user = ChatMessageDto(
    id: 1,
    role: 'user',
    content: 'Log 12.50 lunch at Chez Lou, cash. Am I over on eating out?',
    status: 'completed',
    createdAt: now,
    updatedAt: now,
  );
  final assistant = ChatMessageDto(
    id: 2,
    role: 'assistant',
    content: "Yes, **€34.60 over** the €180 budget. Here's the lunch:",
    status: 'completed',
    createdAt: now,
    updatedAt: now,
    result: {
      'blocks': [
        {
          'type': 'markdown',
          'text': "Yes, **€34.60 over** the €180 budget. Here's the lunch:",
        },
        {
          'type': 'proposed_action',
          'id': 7,
          'action_type': 'transaction.create',
          'summary': 'Record expense of 12.5 at Chez Lou',
          'risk': 'low',
          'status': 'proposed',
          'fields': [
            {
              'key': 'type',
              'label': 'Type',
              'type': 'enum',
              'value': 'expense',
              'display': 'Expense',
              'options': ['income', 'expense']
            },
            {
              'key': 'amount',
              'label': 'Amount',
              'type': 'number',
              'value': 12.5,
              'display': '12.5'
            },
            {
              'key': 'wallet_id',
              'label': 'Wallet',
              'type': 'wallet',
              'value': 4,
              'display': 'Cash'
            },
            {
              'key': 'party_id',
              'label': 'Party',
              'type': 'party',
              'value': 3,
              'display': 'Chez Lou'
            },
            {
              'key': 'description',
              'label': 'Description',
              'type': 'text',
              'value': 'Lunch at Chez Lou',
              'display': 'Lunch at Chez Lou'
            },
            {
              'key': 'categories',
              'label': 'Categories',
              'type': 'categories',
              'value': [3],
              'display': 'Eating out'
            },
            {
              'key': 'datetime',
              'label': 'When',
              'type': 'datetime',
              'value': today,
              'display': today
            },
          ],
        },
      ],
    },
  );
  return AiChatState(
    session: ChatSessionDto(id: 1, createdAt: now, updatedAt: now),
    messages: [user, assistant],
  );
}

ImportSessionEntity _importSession() {
  TransactionSuggestionEntity row(String desc, double amount,
          {String? category, bool duplicate = false}) =>
      TransactionSuggestionEntity(
        documentType: 'bank_statement',
        amount: amount,
        currency: 'EUR',
        type: TransactionType.expense,
        description: desc,
        category: category,
        duplicate: duplicate ? const DuplicateMatchEntity() : null,
      );
  final created = DateTime(2026, 10, 31, 9, 12, 0);
  return ImportSessionEntity(
    id: 11,
    fileName: 'Bank statement, October.pdf',
    fileType: 'pdf',
    status: ImportSessionStatus.ready,
    createdAt: created,
    updatedAt: created.add(const Duration(seconds: 6)),
    suggestions: [
      row('CB UBER EATS PARIS', 24.60, category: 'Eating out'),
      row('CB UBER EATS PARIS', 24.60, category: 'Eating out', duplicate: true),
      row('CB PAYPAL *ABCSTORE', 32.99),
      row('RETRAIT DAB 25/10', 60, category: 'Transfer to Cash'),
      row('CB SPOTIFY', 10.99, category: 'Subscriptions'),
    ],
  );
}

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
    registerFallbackValue(Duration.zero);
  });

  testWidgets('chat', (tester) async {
    if (!ledgerShotsEnabled) return;
    await captureLedgerShots(tester, 'chat', (dark) {
      final chat = _stub(_MockAiChatCubit(), _chatState());
      when(() => chat.openInitial()).thenAnswer((_) async {});
      when(() => chat.pausePolling()).thenReturn(null);
      final dictation = _stub(_MockDictationCubit(), DictationState.initial());
      when(() => dictation.cancel()).thenAnswer((_) async {});
      if (getIt.isRegistered<AiChatCubit>()) getIt.unregister<AiChatCubit>();
      if (getIt.isRegistered<DictationCubit>()) {
        getIt.unregister<DictationCubit>();
      }
      getIt.registerSingleton<AiChatCubit>(chat);
      getIt.registerFactory<DictationCubit>(() => dictation);
      return withShotProviders(
        const AiChatScreen(),
        extra: _lookupProviders(),
      );
    });
  });

  testWidgets('scan', (tester) async {
    if (!ledgerShotsEnabled) return;
    await captureLedgerShots(tester, 'scan', (dark) {
      final cubit = _stub(
        _MockImportCubit(),
        ImportState.initial().copyWith(
          currentSession: _importSession(),
          failure: const Failure.none(),
        ),
      );
      when(() => cubit.loadSession(any())).thenAnswer((_) async {});
      when(() => cubit.startPollingSession(any(),
          interval: any(named: 'interval'))).thenReturn(null);
      when(() => cubit.stopPolling()).thenReturn(null);
      return withShotProviders(
        const SuggestionReviewScreen(sessionId: 11),
        extra: [
          ..._lookupProviders(),
          BlocProvider<ImportCubit>.value(value: cubit),
        ],
      );
    });
  });
}
