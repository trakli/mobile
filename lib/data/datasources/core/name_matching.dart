/// Name comparison for the local duplicate guards.
///
/// The API decides what counts as a duplicate with `utf8mb4_unicode_ci`, so
/// the client has to fold case the same way or the guard and the server
/// disagree. The fold therefore happens in Dart: SQLite's built-in `lower()`
/// only folds ASCII, so a stored `CAFÉ` lowers to `cafÉ` while Dart's
/// `toLowerCase()` gives `café`. Comparing the two in SQL never matches, the
/// duplicate is written locally, and the next sync folds it into the existing
/// row — which is the record-vanishing symptom the guards exist to prevent.
///
/// The client's equivalence class must stay a subset of the server's: these
/// guards may refuse a write the server would accept, but must never accept
/// one the server would fold.
library;

/// Trims and case-folds [value] the way the guards compare names.
String normalizeName(String value) => value.trim().toLowerCase();

/// The first row in [rows] whose name matches [query] once both are
/// normalized, skipping the row whose client id equals [excluding].
///
/// Callers pass every candidate row and the comparison runs in Dart. These
/// tables hold tens of rows per user, so the scan costs less than getting the
/// collation wrong.
T? firstMatchingName<T>(
  Iterable<T> rows,
  String query, {
  required String Function(T row) nameOf,
  required String Function(T row) clientIdOf,
  String? excluding,
}) {
  final normalized = normalizeName(query);
  for (final row in rows) {
    if (excluding != null && clientIdOf(row) == excluding) continue;
    if (normalizeName(nameOf(row)) == normalized) return row;
  }
  return null;
}
