import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';

enum ImportRowStatus { ready, needsCategory, duplicate }

ImportRowStatus importRowStatus(TransactionSuggestionEntity s) {
  if (s.duplicate != null) return ImportRowStatus.duplicate;
  final hasCategory =
      s.categoryId != null || (s.category?.trim().isNotEmpty ?? false);
  return hasCategory ? ImportRowStatus.ready : ImportRowStatus.needsCategory;
}

class ImportReviewCounts {
  final int ready;
  final int needsCategory;
  final int duplicates;

  const ImportReviewCounts({
    required this.ready,
    required this.needsCategory,
    required this.duplicates,
  });

  factory ImportReviewCounts.of(Iterable<TransactionSuggestionEntity> rows) {
    var ready = 0;
    var needs = 0;
    var dup = 0;
    for (final s in rows) {
      switch (importRowStatus(s)) {
        case ImportRowStatus.ready:
          ready++;
        case ImportRowStatus.needsCategory:
          needs++;
        case ImportRowStatus.duplicate:
          dup++;
      }
    }
    return ImportReviewCounts(
      ready: ready,
      needsCategory: needs,
      duplicates: dup,
    );
  }
}
