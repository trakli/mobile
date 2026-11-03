import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/message_bubble.dart';
import 'package:trakli/presentation/utils/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ChatMessageDto assistant({required String status, String? content}) =>
      ChatMessageDto(
        id: 42,
        role: 'assistant',
        status: status,
        content: content,
        createdAt: DateTime(2026, 11, 3),
        updatedAt: DateTime(2026, 11, 3),
      );

  Future<void> pumpRow(
    WidgetTester tester, {
    required ChatMessageDto message,
    List<String> progress = const [],
    bool dark = false,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          // Built here, not at registration: AppTheme reads ScreenUtil sizes.
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: Scaffold(
            body: MessageRow(message: message, progress: progress),
          ),
        ),
      ),
    );
    // The in-flight indicators animate forever, so pump a frame rather
    // than settle.
    await tester.pump(const Duration(milliseconds: 100));
  }

  for (final (name, dark) in [('light', false), ('dark', true)]) {
    testWidgets(
        'in-flight turn lists its live steps, current one spinning ($name)',
        (tester) async {
      await pumpRow(
        tester,
        message: assistant(status: 'processing'),
        progress: const ['Reading your wallets', 'Checking your budgets'],
        dark: dark,
      );

      expect(find.text('Reading your wallets'), findsOneWidget);
      expect(find.text('Checking your budgets'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('in-flight turn without steps yet shows no step list',
      (tester) async {
    await pumpRow(tester, message: assistant(status: 'pending'));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('a settled turn shows its answer, not leftover steps',
      (tester) async {
    await pumpRow(
      tester,
      message: assistant(status: 'completed', content: 'You spent 120 EUR.'),
      progress: const ['Checking your budgets'],
    );

    expect(find.text('Checking your budgets'), findsNothing);
    expect(find.textContaining('You spent 120 EUR.'), findsOneWidget);
  });
}
