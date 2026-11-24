import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/services/speech_recognition_service.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/dictation/dictation_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_composer.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class _MockSpeechService extends Mock implements SpeechRecognitionService {}

void main() {
  late _MockSpeechService speech;
  late DictationCubit cubit;
  late TextEditingController controller;
  late FocusNode focus;
  late List<String> sent;
  void Function(String)? onWords;

  setUp(() {
    speech = _MockSpeechService();
    onWords = null;
    when(() => speech.initialize(
          onStopped: any(named: 'onStopped'),
          onError: any(named: 'onError'),
        )).thenAnswer((_) async => true);
    when(() => speech.hasPermission()).thenAnswer((_) async => true);
    when(() => speech.localeIds()).thenAnswer((_) async => ['en_US']);
    when(() => speech.listen(
          onWords: any(named: 'onWords'),
          localeId: any(named: 'localeId'),
        )).thenAnswer((invocation) async {
      onWords = invocation.namedArguments[#onWords] as void Function(String);
    });
    when(() => speech.stop()).thenAnswer((_) async {});
    when(() => speech.cancel()).thenAnswer((_) async {});
    cubit = DictationCubit(speech);
    controller = TextEditingController();
    focus = FocusNode();
    sent = [];
  });

  tearDown(() async {
    await cubit.close();
    controller.dispose();
    focus.dispose();
  });

  Future<void> pumpComposer(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          theme: ThemeData(
            extensions: const [AppTones.light, AppElevations.light],
          ),
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Composer(
                  controller: controller,
                  focus: focus,
                  isSending: false,
                  onSend: (String text, List<File> files, String? type) =>
                      sent.add(text),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  String hintText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).decoration!.hintText!;

  testWidgets('shows an idle mic with the regular hint', (tester) async {
    await pumpComposer(tester);

    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(hintText(tester), LocaleKeys.aiChatComposerPlaceholder);
  });

  testWidgets('tapping the mic listens and appends dictated words',
      (tester) async {
    await pumpComposer(tester);
    await tester.enterText(find.byType(TextField), 'Show me');

    await tester.tap(find.byType(DictationButton));
    await tester.pump();

    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    expect(hintText(tester), LocaleKeys.aiChatDictationListening);

    onWords!('groceries this month');
    await tester.pump();

    expect(controller.text, 'Show me groceries this month');
    expect(sent, isEmpty);
  });

  testWidgets('tapping the mic again stops listening', (tester) async {
    await pumpComposer(tester);

    await tester.tap(find.byType(DictationButton));
    await tester.pump();
    await tester.tap(find.byType(DictationButton));
    await tester.pump();

    verify(() => speech.stop()).called(1);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
  });

  testWidgets('sending cancels dictation and ignores late words',
      (tester) async {
    await pumpComposer(tester);

    await tester.tap(find.byType(DictationButton));
    await tester.pump();
    onWords!('rent paid');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(sent, ['rent paid']);
    verify(() => speech.cancel()).called(1);

    controller.clear();
    onWords!('rent paid twice');
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
  });

  testWidgets('disables the mic when the recognizer is unavailable',
      (tester) async {
    when(() => speech.initialize(
          onStopped: any(named: 'onStopped'),
          onError: any(named: 'onError'),
        )).thenAnswer((_) async => false);
    await pumpComposer(tester);

    await tester.tap(find.byType(DictationButton));
    await tester.pump();

    expect(find.byIcon(Icons.mic_off_rounded), findsOneWidget);
    expect(
      tester.widget<Tooltip>(find.byType(Tooltip).last).message,
      LocaleKeys.aiChatDictationUnavailable,
    );

    clearInteractions(speech);
    await tester.tap(find.byType(DictationButton));
    await tester.pump();
    verifyNever(() => speech.initialize(
          onStopped: any(named: 'onStopped'),
          onError: any(named: 'onError'),
        ));
  });
}
