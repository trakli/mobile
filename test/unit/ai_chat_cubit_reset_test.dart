import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/realtime/pusher_protocol.dart';
import 'package:trakli/core/realtime/reverb_socket_client.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/usecases/ai/confirm_action_usecase.dart';
import 'package:trakli/domain/usecases/ai/create_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/delete_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/get_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/list_sessions_usecase.dart';
import 'package:trakli/domain/usecases/ai/reject_action_usecase.dart';
import 'package:trakli/domain/usecases/ai/send_message_usecase.dart';
import 'package:trakli/domain/usecases/ai/upload_files_usecase.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';

class _MockListSessions extends Mock implements ListSessionsUseCase {}

class _MockGetSession extends Mock implements GetSessionUseCase {}

class _MockCreateSession extends Mock implements CreateSessionUseCase {}

class _MockSendMessage extends Mock implements SendMessageUseCase {}

class _MockDeleteSession extends Mock implements DeleteSessionUseCase {}

class _MockConfirmAction extends Mock implements ConfirmActionUseCase {}

class _MockRejectAction extends Mock implements RejectActionUseCase {}

class _MockUploadFiles extends Mock implements UploadFilesUseCase {}

class _MockSocket extends Mock implements ReverbSocketClient {}

void main() {
  late _MockListSessions listSessions;
  late _MockGetSession getSession;
  late _MockSocket socket;

  final at = DateTime(2026, 11, 3);

  ChatSessionDto session(int id, {String assistantStatus = 'processing'}) =>
      ChatSessionDto(
        id: id,
        createdAt: at,
        updatedAt: at,
        messages: [
          ChatMessageDto(
            id: id * 10,
            role: 'user',
            content: 'How much did I spend this month?',
            createdAt: at,
            updatedAt: at,
          ),
          ChatMessageDto(
            id: id * 10 + 1,
            role: 'assistant',
            status: assistantStatus,
            createdAt: at,
            updatedAt: at,
          ),
        ],
      );

  setUpAll(() {
    registerFallbackValue(const GetSessionParams(id: 0));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    listSessions = _MockListSessions();
    getSession = _MockGetSession();
    socket = _MockSocket();
    when(() => socket.turnEvents)
        .thenAnswer((_) => const Stream<ChatTurnFrame>.empty());
    when(() => socket.subscribeToSession(any())).thenAnswer((_) async {});
  });

  AiChatCubit build() => AiChatCubit(
        listSessionsUseCase: listSessions,
        getSessionUseCase: getSession,
        createSessionUseCase: _MockCreateSession(),
        sendMessageUseCase: _MockSendMessage(),
        deleteSessionUseCase: _MockDeleteSession(),
        confirmActionUseCase: _MockConfirmAction(),
        rejectActionUseCase: _MockRejectAction(),
        uploadFilesUseCase: _MockUploadFiles(),
        socket: socket,
      );

  test('reset drops the open chat, its live channel and its polling', () {
    fakeAsync((async) {
      when(() => getSession(any())).thenAnswer((_) async => Right(session(84)));
      final cubit = build();

      cubit.openSession(84);
      async.flushMicrotasks();
      expect(cubit.state.session?.id, 84);
      expect(cubit.state.isPolling, isTrue);
      verify(() => socket.subscribeToSession(84)).called(1);

      cubit.reset();

      expect(cubit.state, AiChatState.initial());
      verify(() => socket.unsubscribe()).called(1);

      // The in-flight reply would have kept polling for minutes.
      clearInteractions(getSession);
      async.elapse(const Duration(minutes: 5));
      verifyNever(() => getSession(any()));

      cubit.close();
    });
  });

  test('after reset the next account does not reopen the previous chat', () {
    fakeAsync((async) {
      // Account A has chat 84 open, then logs out.
      when(() => getSession(any())).thenAnswer(
          (_) async => Right(session(84, assistantStatus: 'completed')));
      final cubit = build();
      cubit.openSession(84);
      async.flushMicrotasks();
      cubit.reset();

      // Account B logs in and opens AI chat; their latest chat is 85.
      clearInteractions(getSession);
      when(() => listSessions(any())).thenAnswer(
          (_) async => Right([session(85, assistantStatus: 'completed')]));
      cubit.openInitial();
      async.flushMicrotasks();

      verifyNever(() => getSession(const GetSessionParams(id: 84)));
      verify(() => listSessions(any())).called(1);
      expect(cubit.state.session, isNull);
      expect(cubit.state.recentSession?.id, 85);

      cubit.close();
    });
  });
}
