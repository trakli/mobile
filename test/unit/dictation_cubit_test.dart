import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/services/speech_recognition_service.dart';
import 'package:trakli/presentation/ai_chat/dictation/dictation_cubit.dart';

class _MockSpeechService extends Mock implements SpeechRecognitionService {}

void main() {
  late _MockSpeechService speech;
  late void Function() onStopped;
  late void Function(SpeechRecognitionIssue) onError;
  late void Function(String) onWords;
  String? listenedLocale;

  setUp(() {
    speech = _MockSpeechService();
    listenedLocale = null;
    when(() => speech.initialize(
          onStopped: any(named: 'onStopped'),
          onError: any(named: 'onError'),
        )).thenAnswer((invocation) async {
      onStopped = invocation.namedArguments[#onStopped] as void Function();
      onError = invocation.namedArguments[#onError] as void Function(
          SpeechRecognitionIssue);
      return true;
    });
    when(() => speech.hasPermission()).thenAnswer((_) async => true);
    when(() => speech.localeIds())
        .thenAnswer((_) async => ['en_US', 'fr_FR', 'de-DE']);
    when(() => speech.listen(
          onWords: any(named: 'onWords'),
          localeId: any(named: 'localeId'),
        )).thenAnswer((invocation) async {
      onWords = invocation.namedArguments[#onWords] as void Function(String);
      listenedLocale = invocation.namedArguments[#localeId] as String?;
    });
    when(() => speech.stop()).thenAnswer((_) async {});
    when(() => speech.cancel()).thenAnswer((_) async {});
  });

  DictationCubit build() => DictationCubit(speech);

  blocTest<DictationCubit, DictationState>(
    'starts listening and streams recognized words',
    build: build,
    act: (cubit) async {
      await cubit.start(languageCode: 'fr');
      onWords('bonjour');
      onWords('bonjour tout le monde');
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(
          status: DictationStatus.listening, recognizedWords: 'bonjour'),
      DictationState(
        status: DictationStatus.listening,
        recognizedWords: 'bonjour tout le monde',
      ),
    ],
    verify: (_) => expect(listenedLocale, 'fr_FR'),
  );

  blocTest<DictationCubit, DictationState>(
    'falls back to the device default locale when the app language is unsupported',
    build: build,
    act: (cubit) => cubit.start(languageCode: 'ru'),
    verify: (_) {
      verify(() => speech.listen(
            onWords: any(named: 'onWords'),
            localeId: null,
          )).called(1);
    },
  );

  blocTest<DictationCubit, DictationState>(
    'toggle stops an active session',
    build: build,
    act: (cubit) async {
      await cubit.toggle(languageCode: 'en');
      await cubit.toggle(languageCode: 'en');
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(status: DictationStatus.idle),
    ],
    verify: (_) => verify(() => speech.stop()).called(1),
  );

  blocTest<DictationCubit, DictationState>(
    'returns to idle when recognition ends on its own',
    build: build,
    act: (cubit) async {
      await cubit.start();
      onWords('lunch');
      onStopped();
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(
          status: DictationStatus.listening, recognizedWords: 'lunch'),
      DictationState(status: DictationStatus.idle, recognizedWords: 'lunch'),
    ],
  );

  blocTest<DictationCubit, DictationState>(
    'cancel ignores words that arrive afterwards',
    build: build,
    act: (cubit) async {
      await cubit.start();
      await cubit.cancel();
      onWords('late result');
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(status: DictationStatus.idle),
    ],
    verify: (_) => verify(() => speech.cancel()).called(1),
  );

  blocTest<DictationCubit, DictationState>(
    'reports a denied permission and keeps the mic available for a retry',
    setUp: () {
      when(() => speech.initialize(
            onStopped: any(named: 'onStopped'),
            onError: any(named: 'onError'),
          )).thenAnswer((_) async => false);
      when(() => speech.hasPermission()).thenAnswer((_) async => false);
    },
    build: build,
    act: (cubit) => cubit.start(),
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(error: DictationError.permissionDenied),
    ],
    verify: (_) => verifyNever(() => speech.listen(
          onWords: any(named: 'onWords'),
          localeId: any(named: 'localeId'),
        )),
  );

  blocTest<DictationCubit, DictationState>(
    'marks the recognizer unavailable when permission exists but init fails',
    setUp: () {
      when(() => speech.initialize(
            onStopped: any(named: 'onStopped'),
            onError: any(named: 'onError'),
          )).thenAnswer((_) async => false);
    },
    build: build,
    act: (cubit) async {
      await cubit.start();
      await cubit.start();
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(isAvailable: false, error: DictationError.unavailable),
    ],
  );

  blocTest<DictationCubit, DictationState>(
    'surfaces recognition errors and treats silence as a quiet stop',
    build: build,
    act: (cubit) async {
      await cubit.start();
      onError(SpeechRecognitionIssue.noSpeech);
      await cubit.start();
      onError(SpeechRecognitionIssue.failed);
    },
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(),
      DictationState(status: DictationStatus.starting),
      DictationState(status: DictationStatus.listening),
      DictationState(error: DictationError.failed),
    ],
  );

  blocTest<DictationCubit, DictationState>(
    'emits failed when the plugin throws while starting',
    setUp: () {
      when(() => speech.listen(
            onWords: any(named: 'onWords'),
            localeId: any(named: 'localeId'),
          )).thenThrow(Exception('boom'));
    },
    build: build,
    act: (cubit) => cubit.start(),
    expect: () => const [
      DictationState(status: DictationStatus.starting),
      DictationState(error: DictationError.failed),
    ],
  );

  blocTest<DictationCubit, DictationState>(
    'cancels an active session when closed',
    build: build,
    act: (cubit) => cubit.start(),
    verify: (_) => verify(() => speech.cancel()).called(1),
  );

  test('resolveLocaleId matches on language for both separator styles', () {
    expect(DictationCubit.resolveLocaleId(['en_US', 'de-DE'], 'de'), 'de-DE');
    expect(DictationCubit.resolveLocaleId(['en_US'], 'EN'), 'en_US');
    expect(DictationCubit.resolveLocaleId(['en_US'], 'it'), isNull);
    expect(DictationCubit.resolveLocaleId(['en_US'], null), isNull);
  });
}
