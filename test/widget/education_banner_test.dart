import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/utils/education_banner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget({
    required String message,
    required IconData icon,
    VoidCallback? onDismiss,
  }) {
    return MediaQuery(
      data: const MediaQueryData(size: Size(375, 812)),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: EducationBanner(
                message: message,
                icon: icon,
                onDismiss: onDismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('EducationBanner', () {
    testWidgets('should display the provided message', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'This is an education message',
        icon: Icons.info_outline,
      ));
      await tester.pumpAndSettle();

      expect(find.text('This is an education message'), findsOneWidget);
    });

    testWidgets('should display the provided icon', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.people_outline,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('should show dismiss button when onDismiss is provided',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.info_outline,
        onDismiss: () {},
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should not show dismiss button when onDismiss is null',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.info_outline,
        onDismiss: null,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('should call onDismiss when dismiss button is tapped',
        (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool wasDismissed = false;

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.info_outline,
        onDismiss: () {
          wasDismissed = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(wasDismissed, isTrue);
    });

    testWidgets('should render EducationBanner widget', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.info_outline,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(EducationBanner), findsOneWidget);
    });

    testWidgets('should have container with proper styling', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(
        message: 'Test message',
        icon: Icons.info_outline,
      ));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(EducationBanner),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.decoration, isA<BoxDecoration>());
    });
  });
}
