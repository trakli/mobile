import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class QuickAddParse {
  final double? amount;
  final CategoryEntity? category;
  final WalletEntity? wallet;
  final PartyEntity? party;
  final DateTime? date;
  final String description;

  /// Set when the category came from earlier transactions rather than a
  /// name match in the sentence.
  final bool categoryFromHistory;

  const QuickAddParse({
    this.amount,
    this.category,
    this.wallet,
    this.party,
    this.date,
    this.description = '',
    this.categoryFromHistory = false,
  });

  TransactionType? get typeHint => category?.type;
}

/// Reads a one-line entry such as "12.50 lunch at Chez Lou, cash yesterday".
///
/// Amount: the first number. Category, wallet and person: the longest name
/// of an existing entity found as whole words. When no category name is in
/// the sentence, the category used most often on earlier transactions with
/// the matched person, or with a description sharing a word, is suggested.
/// Dates: today and yesterday in every app language.
class QuickAddParser {
  final List<CategoryEntity> categories;
  final List<WalletEntity> wallets;
  final List<PartyEntity> parties;
  final List<TransactionCompleteEntity> history;

  const QuickAddParser({
    required this.categories,
    required this.wallets,
    required this.parties,
    this.history = const [],
  });

  static const _today = {
    'today',
    "aujourd'hui",
    'aujourdhui',
    'heute',
    'hoy',
    'oggi',
    'сегодня',
  };
  static const _yesterday = {'yesterday', 'hier', 'gestern', 'ayer', 'ieri', 'вчера'};

  static const _stopWords = {
    'a', 'an', 'and', 'at', 'for', 'from', 'in', 'of', 'on', 'the', 'to',
    'with', 'my', 'de', 'du', 'la', 'le', 'les', 'au', 'et', 'pour', 'avec',
    'der', 'die', 'das', 'und', 'mit', 'el', 'en', 'y', 'con', 'il', 'di',
  };

  static final _amountPattern = RegExp(
    r'(?<![\w.,])([$€£¥₦]?)\s?(\d{1,3}(?:[ ,]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?)(k?)(?![\w])',
    caseSensitive: false,
  );

  static String fold(String s) {
    const from = 'àáâãäåçèéêëìíîïñòóôõöùúûüýÿœæ';
    const to = 'aaaaaaceeeeiiiinooooouuuuyyoa';
    final b = StringBuffer();
    for (final r in s.toLowerCase().runes) {
      final c = String.fromCharCode(r);
      final i = from.indexOf(c);
      b.write(i >= 0 ? to[i] : c);
    }
    return b.toString();
  }

  static double? parseAmount(String raw) {
    var digits = raw.replaceAll(' ', '');
    final lastComma = digits.lastIndexOf(',');
    final lastDot = digits.lastIndexOf('.');
    if (lastComma > lastDot) {
      final decimals = digits.length - lastComma - 1;
      digits = decimals <= 2
          ? digits.replaceAll('.', '').replaceFirst(',', '.', lastComma)
          : digits.replaceAll(',', '');
      digits = digits.replaceAll(',', '');
    } else {
      digits = digits.replaceAll(',', '');
    }
    return double.tryParse(digits);
  }

  /// Returns [start, end) of [needle] in [hay] on word boundaries, or null.
  static (int, int)? _findWords(String hay, String needle) {
    if (needle.trim().isEmpty) return null;
    final pattern = RegExp(
      '(?<![\\p{L}\\p{N}])${RegExp.escape(needle.trim())}(?![\\p{L}\\p{N}])',
      unicode: true,
    );
    final m = pattern.firstMatch(hay);
    return m == null ? null : (m.start, m.end);
  }

  static (T, int, int)? _longest<T>(
    String folded,
    Iterable<T> items,
    String Function(T) name,
  ) {
    (T, int, int)? best;
    for (final item in items) {
      final hit = _findWords(folded, fold(name(item)));
      if (hit == null) continue;
      if (best == null || hit.$2 - hit.$1 > best.$3 - best.$2) {
        best = (item, hit.$1, hit.$2);
      }
    }
    return best;
  }

  /// Matches one word of a multi-word name when no other item shares it,
  /// so "momo" finds "MTN MoMo" and "tomas" finds "Tomás Reyes".
  static (T, int, int)? _byUniqueWord<T>(
    String folded,
    Iterable<T> items,
    String Function(T) name, {
    required bool firstOnly,
  }) {
    final byWord = <String, Set<T>>{};
    for (final item in items) {
      final words = fold(name(item)).trim().split(RegExp(r'\s+'));
      if (words.length < 2) continue;
      for (final w in firstOnly ? words.take(1) : words) {
        if (w.length < 3) continue;
        byWord.putIfAbsent(w, () => {}).add(item);
      }
    }
    (T, int, int)? best;
    for (final e in byWord.entries) {
      if (e.value.length != 1) continue;
      final hit = _findWords(folded, e.key);
      if (hit == null) continue;
      if (best == null || hit.$1 < best.$2) {
        best = (e.value.first, hit.$1, hit.$2);
      }
    }
    return best;
  }

  QuickAddParse parse(String text, {DateTime? now}) {
    final clock = now ?? DateTime.now();
    final folded = fold(text);
    final cut = <(int, int)>[];

    double? amount;
    final amountMatch = _amountPattern.firstMatch(folded);
    if (amountMatch != null) {
      amount = parseAmount(amountMatch.group(2)!);
      if (amount != null && amountMatch.group(3)!.isNotEmpty) amount *= 1000;
      cut.add((amountMatch.start, amountMatch.end));
    }

    DateTime? date;
    for (final w in RegExp(r"[\p{L}']+", unicode: true).allMatches(folded)) {
      final word = w.group(0)!;
      if (_today.contains(word)) {
        date = DateTime(clock.year, clock.month, clock.day);
        cut.add((w.start, w.end));
      } else if (_yesterday.contains(word)) {
        final y = clock.subtract(const Duration(days: 1));
        date = DateTime(y.year, y.month, y.day);
        cut.add((w.start, w.end));
      }
    }

    final wallet = _longest(folded, wallets, (w) => w.name) ??
        _byUniqueWord(folded, wallets, (w) => w.name, firstOnly: false) ??
        _walletByType(folded);
    if (wallet != null) cut.add((wallet.$2, wallet.$3));

    final party =
        _longest(folded, parties, (p) => p.name) ??
            _byUniqueWord(folded, parties, (p) => p.name, firstOnly: true);

    var categoryHit = _longest(folded, categories, (c) => c.name);
    if (categoryHit != null &&
        party != null &&
        categoryHit.$2 >= party.$2 &&
        categoryHit.$3 <= party.$3) {
      categoryHit = null;
    }
    CategoryEntity? category = categoryHit?.$1;
    var fromHistory = false;
    if (category == null) {
      category = _categoryFromHistory(folded, party?.$1);
      fromHistory = category != null;
    }

    return QuickAddParse(
      amount: amount,
      category: category,
      wallet: wallet?.$1,
      party: party?.$1,
      date: date,
      description: _describe(text, cut),
      categoryFromHistory: fromHistory,
    );
  }

  (WalletEntity, int, int)? _walletByType(String folded) {
    for (final type in WalletType.values) {
      final hit = _findWords(folded, fold(type.customName));
      if (hit == null) continue;
      final match = wallets.where((w) => w.type == type).toList();
      if (match.length == 1) return (match.first, hit.$1, hit.$2);
    }
    return null;
  }

  CategoryEntity? _categoryFromHistory(String folded, PartyEntity? party) {
    if (history.isEmpty) return null;
    final words = RegExp(r'[\p{L}\p{N}]+', unicode: true)
        .allMatches(folded)
        .map((m) => m.group(0)!)
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toSet();
    final score = <String, int>{};
    for (final t in history) {
      if (t.categories.isEmpty) continue;
      var weight = 0;
      if (party != null && t.party?.clientId == party.clientId) weight += 3;
      final desc = fold(t.transaction.description);
      for (final w in words) {
        if (_findWords(desc, w) != null) weight += 1;
      }
      if (weight == 0) continue;
      final id = t.categories.first.clientId;
      score[id] = (score[id] ?? 0) + weight;
    }
    if (score.isEmpty) return null;
    final bestId =
        score.entries.reduce((a, b) => b.value > a.value ? b : a).key;
    for (final c in categories) {
      if (c.clientId == bestId) return c;
    }
    return null;
  }

  static String _describe(String text, List<(int, int)> cut) {
    final keep = List<bool>.filled(text.length, true);
    for (final (s, e) in cut) {
      for (var i = s; i < e && i < keep.length; i++) {
        keep[i] = false;
      }
    }
    final b = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (keep[i]) b.write(text[i]);
    }
    var out = b
        .toString()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\s+([,.;])'), r'$1')
        .replaceAll(RegExp(r'([,;])\s*([,;])'), r'$1')
        .trim();
    out = out.replaceAll(RegExp(r'^[,.;:\s]+|[,.;:\s]+$'), '').trim();
    out = out.replaceAll(RegExp(r'\s+(on|in|with|from|by)$'), '').trim();
    if (out.isEmpty) return out;
    return out[0].toUpperCase() + out.substring(1);
  }
}
