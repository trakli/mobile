import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/widgets/safe_view.dart';

class _ThrowingWidget extends StatelessWidget {
  const _ThrowingWidget();

  @override
  Widget build(BuildContext context) => throw StateError('boom');
}

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp(
      theme: ThemeData(extensions: const [AppTones.light]),
      home: child,
    ),
  );
}

void main() {
  testWidgets('renders the child when it builds cleanly', (tester) async {
    await tester
        .pumpWidget(_wrap(SafeView(builder: (_) => const Text('content'))));

    expect(find.text('content'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsNothing);
  });

  testWidgets('shows the fallback when a descendant throws during build',
      (tester) async {
    await tester
        .pumpWidget(_wrap(SafeView(builder: (_) => const _ThrowingWidget())));
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('retry rebuilds the guarded subtree', (tester) async {
    await tester
        .pumpWidget(_wrap(SafeView(builder: (_) => const _ThrowingWidget())));
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    await tester.tap(find.bySubtype<ElevatedButton>());
    await tester.pump();
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
