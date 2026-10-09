import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/feedback/dtos/feedback_dto.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/domain/usecases/feedback/get_feedback_usecase.dart';
import 'package:trakli/domain/usecases/feedback/submit_feedback_usecase.dart';
import 'package:trakli/presentation/feedback/cubit/feedback_cubit.dart';

class _MockGetFeedback extends Mock implements GetFeedbackUseCase {}

class _MockSubmitFeedback extends Mock implements SubmitFeedbackUseCase {}

void main() {
  late _MockGetFeedback getFeedback;
  late _MockSubmitFeedback submitFeedback;

  const older = FeedbackEntity(
    id: 1,
    type: FeedbackType.bug,
    status: 'triaged',
    message: 'Crash on launch',
  );
  const sent = FeedbackEntity(
    id: 2,
    type: FeedbackType.feature,
    status: 'new',
    subject: 'Dark widgets',
    message: 'Please add a dark home widget',
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const SubmitFeedbackUseCaseParams(
        type: FeedbackType.general,
        message: 'x',
      ),
    );
  });

  setUp(() {
    getFeedback = _MockGetFeedback();
    submitFeedback = _MockSubmitFeedback();
  });

  FeedbackCubit buildCubit() => FeedbackCubit(getFeedback, submitFeedback);

  test('loads the history', () async {
    when(() => getFeedback(any()))
        .thenAnswer((_) async => const Right([older]));

    final cubit = buildCubit();
    await cubit.loadFeedback();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.items, [older]);
    expect(cubit.state.loadFailure.hasError, isFalse);
  });

  test('keeps a load failure apart from submission failures', () async {
    when(() => getFeedback(any()))
        .thenAnswer((_) async => const Left(Failure.networkError()));

    final cubit = buildCubit();
    await cubit.loadFeedback();

    expect(cubit.state.loadFailure, const Failure.networkError());
    expect(cubit.state.failure.hasError, isFalse);
  });

  test('puts a sent item first and trims what was typed', () async {
    when(() => getFeedback(any()))
        .thenAnswer((_) async => const Right([older]));
    when(() => submitFeedback(any()))
        .thenAnswer((_) async => const Right(sent));

    final cubit = buildCubit();
    await cubit.loadFeedback();
    await cubit.submitFeedback(
      type: FeedbackType.feature,
      subject: '  Dark widgets ',
      message: ' Please add a dark home widget\n',
    );

    final captured = verify(() => submitFeedback(captureAny())).captured.single
        as SubmitFeedbackUseCaseParams;
    expect(captured.subject, 'Dark widgets');
    expect(captured.message, 'Please add a dark home widget');

    expect(cubit.state.items, [sent, older]);
    expect(cubit.state.submittedCount, 1);
    expect(cubit.state.isSubmitting, isFalse);
  });

  test('sends a blank subject as none', () async {
    when(() => submitFeedback(any()))
        .thenAnswer((_) async => const Right(sent));

    await buildCubit().submitFeedback(
      type: FeedbackType.general,
      subject: '   ',
      message: 'Hi',
    );

    final captured = verify(() => submitFeedback(captureAny())).captured.single
        as SubmitFeedbackUseCaseParams;
    expect(captured.subject, isNull);
  });

  test('stores a submission failure without counting a send', () async {
    when(() => submitFeedback(any()))
        .thenAnswer((_) async => const Left(Failure.serverError('boom')));

    final cubit = buildCubit();
    await cubit.submitFeedback(type: FeedbackType.bug, message: 'Broken');

    expect(cubit.state.failure.hasError, isTrue);
    expect(cubit.state.submittedCount, 0);
    expect(cubit.state.items, isEmpty);
  });

  group('FeedbackDto', () {
    test('reads the server resource', () {
      final entity = FeedbackDto.fromJson({
        'id': 9,
        'owner_type': 'App\\Models\\User',
        'owner_id': 3,
        'form_key': 'support',
        'type': 'question',
        'status': 'in_progress',
        'subject': null,
        'message': 'How do budgets roll over?',
        'created_at': '2026-09-21T10:00:00.000000Z',
      }).toEntity();

      expect(entity.id, 9);
      expect(entity.type, FeedbackType.question);
      expect(entity.status, 'in_progress');
      expect(entity.subject, isNull);
      expect(entity.createdAt, DateTime.utc(2026, 9, 21, 10).toLocal());
    });

    test('falls back to general for an unknown type', () {
      final entity = FeedbackDto.fromJson({
        'id': 1,
        'type': 'praise',
        'status': 'new',
        'message': 'Love it',
      }).toEntity();

      expect(entity.type, FeedbackType.general);
      expect(entity.createdAt, isNull);
    });
  });
}
