import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/core/sync/sync_entity.dart';

Map<String, dynamic> _page(List<Map<String, dynamic>> rows) => {
      'current_page': 1,
      'last_page': 2,
      'per_page': 20,
      'data': rows,
    };

String _parseName(Object? json) {
  final row = json! as Map<String, dynamic>;
  return row['name'] as String;
}

void main() {
  group('PaginationResponse.lenient', () {
    test('parses every readable row and keeps the page metadata', () {
      final page = PaginationResponse.lenient(
        _page([
          {'name': 'a'},
          {'name': 'b'}
        ]),
        _parseName,
        entityType: SyncEntity.transfer,
      );

      expect(page.data, ['a', 'b']);
      expect(page.hasMore, isTrue);
    });

    // The whole point: one unreadable row cost us every transfer, every sync,
    // for five weeks.
    test('skips an unreadable row and keeps the rest', () {
      final page = PaginationResponse.lenient(
        _page([
          {'name': 'a'},
          {'name': null},
          {'name': 'c'}
        ]),
        _parseName,
        entityType: SyncEntity.transfer,
      );

      expect(page.data, ['a', 'c']);
    });

    test('an entirely unreadable page still advances paging', () {
      final page = PaginationResponse.lenient(
        _page([
          {'name': null}
        ]),
        _parseName,
        entityType: SyncEntity.transfer,
      );

      expect(page.data, isEmpty);
      expect(page.currentPage, 1);
      expect(page.hasMore, isTrue);
    });

    test('tolerates a page with no data key', () {
      final page = PaginationResponse.lenient(
        {'current_page': 2, 'last_page': 2, 'per_page': 20},
        _parseName,
        entityType: SyncEntity.transfer,
      );

      expect(page.data, isEmpty);
      expect(page.hasMore, isFalse);
    });
  });
}
