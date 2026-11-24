import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/import/duplicate_match_entity.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/presentation/imports/import_review_status.dart';

TransactionSuggestionEntity _row({
  String? category,
  int? categoryId,
  DuplicateMatchEntity? duplicate,
}) =>
    TransactionSuggestionEntity(
      documentType: 'bank_statement',
      amount: 10,
      category: category,
      categoryId: categoryId,
      duplicate: duplicate,
    );

void main() {
  group('importRowStatus', () {
    test('a row with a category name is ready', () {
      expect(
          importRowStatus(_row(category: 'Groceries')), ImportRowStatus.ready);
    });

    test('a row matched to a category id is ready', () {
      expect(importRowStatus(_row(categoryId: 4)), ImportRowStatus.ready);
    });

    test('a row without a category needs one', () {
      expect(importRowStatus(_row()), ImportRowStatus.needsCategory);
      expect(
          importRowStatus(_row(category: '  ')), ImportRowStatus.needsCategory);
    });

    test('a duplicate wins over a present category', () {
      expect(
        importRowStatus(
          _row(category: 'Rent', duplicate: const DuplicateMatchEntity()),
        ),
        ImportRowStatus.duplicate,
      );
    });
  });

  test('ImportReviewCounts tallies each status once', () {
    final counts = ImportReviewCounts.of([
      _row(category: 'Groceries'),
      _row(categoryId: 2),
      _row(),
      _row(category: 'Fuel', duplicate: const DuplicateMatchEntity()),
      _row(duplicate: const DuplicateMatchEntity()),
    ]);
    expect(counts.ready, 2);
    expect(counts.needsCategory, 1);
    expect(counts.duplicates, 2);
  });

  test('ImportReviewCounts of no rows is all zero', () {
    final counts = ImportReviewCounts.of(const []);
    expect([counts.ready, counts.needsCategory, counts.duplicates], [0, 0, 0]);
  });
}
