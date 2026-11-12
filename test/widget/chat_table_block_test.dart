import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_table_block.dart';
import 'package:trakli/presentation/utils/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A SmartQL-shaped result: raw column names, one wide free-text column.
  List<Map<String, dynamic>> wideRows() => [
        {
          'id': 1,
          'type': 'expense',
          'amount': 2000,
          'intent': 'record',
          'user_id': 1,
          'datetime': '2026-10-20',
          'party_id': 3,
          'wallet_id': 4,
          'description': 'Food today for I and norbet',
          'transfer_id': 7,
        },
        {
          'id': 2,
          'type': 'expense',
          'amount': 5000,
          'intent': 'record',
          'user_id': 1,
          'datetime': '2026-10-05',
          'party_id': 3,
          'wallet_id': 4,
          'description': 'Feeding',
          'transfer_id': 8,
        },
      ];

  Future<void> pumpTable(
    WidgetTester tester, {
    required List<Map<String, dynamic>> rows,
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
            body: ChatTableBlock(
              block: TableBlock(title: null, columns: const [], rows: rows),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Width of the laid-out Text for [label].
  double headerWidth(WidgetTester tester, String label) =>
      tester.getSize(find.text(label).first).width;

  group('ChatTableBlock', () {
    testWidgets('a ten-column table keeps its headers on one line', (
      tester,
    ) async {
      await pumpTable(tester, rows: wideRows());

      // Each header should be wider than it is tall, i.e. still one line.
      for (final header in [
        'Id',
        'Type',
        'Amount',
        'Description',
        'Transfer Id',
      ]) {
        final size = tester.getSize(find.text(header).first);
        expect(
          size.width,
          greaterThan(size.height),
          reason: '"$header" wrapped instead of staying on one line '
              '(${size.width}x${size.height})',
        );
      }
    });

    testWidgets('a wide table scrolls sideways instead of overflowing', (
      tester,
    ) async {
      await pumpTable(tester, rows: wideRows());

      final scroller = find.byType(SingleChildScrollView);
      expect(scroller, findsOneWidget);
      expect(
        tester.widget<SingleChildScrollView>(scroller).scrollDirection,
        Axis.horizontal,
      );

      // Content exceeds the viewport, so there is somewhere to scroll to.
      final position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
      expect(position.maxScrollExtent, greaterThan(0));

      expect(tester.takeException(), isNull);
    });

    testWidgets('a narrow table still fills the available width', (
      tester,
    ) async {
      await pumpTable(tester, rows: [
        {'type': 'expense', 'amount': 2000},
        {'type': 'income', 'amount': 500},
      ]);

      final table = tester.getSize(find.byType(Table));
      final card = tester.getSize(find.byType(ChatTableBlock));
      // Two short columns must stretch across the card, not huddle left.
      expect(table.width, greaterThan(card.width / 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in dark mode without overflowing', (tester) async {
      await pumpTable(tester, rows: wideRows(), dark: true);

      expect(find.text('Description'), findsOneWidget);
      expect(headerWidth(tester, 'Description'), greaterThan(0));
      expect(tester.takeException(), isNull);
    });
  });
}
