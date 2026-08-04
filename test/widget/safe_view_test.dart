import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/widgets/safe_view.dart';

class _ThrowingWidget extends StatelessWidget {
  const _ThrowingWidget();

  @override
  Widget build(BuildContext context) => throw StateError('boom');
}

void main() {
  testWidgets('renders the child when it builds cleanly', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SafeView(builder: (_) => const Text('content')),
    ));

    expect(find.text('content'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsNothing);
  });

  testWidgets('shows the fallback when a descendant throws during build',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SafeView(builder: (_) => const _ThrowingWidget()),
    ));
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('retry rebuilds the guarded subtree', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SafeView(builder: (_) => const _ThrowingWidget()),
    ));
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(tester.takeException(), isA<StateError>());
    await tester.pump();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
