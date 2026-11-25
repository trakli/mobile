import 'package:intl/intl.dart';

/// U+2212, the typographic minus sign, so negative amounts line up with
/// tabular plus signs.
const String ledgerMinus = '−';

class LedgerMoney {
  LedgerMoney._();

  static int decimalsFor(String code) {
    try {
      return NumberFormat.simpleCurrency(name: code).decimalDigits ?? 2;
    } catch (_) {
      return 2;
    }
  }

  static String? _prefixSymbol(String code) {
    try {
      final symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
      final isShortSymbol = symbol.runes.length <= 2 &&
          !RegExp(r'^[A-Za-z]+$').hasMatch(symbol) &&
          symbol != code;
      return isShortSymbol ? symbol : null;
    } catch (_) {
      return null;
    }
  }

  /// Formats [value] in [currencyCode]: `€1,781.65`, `184,500 XAF`.
  /// [sign] prefixes `+` on positive values; negatives always get a minus.
  /// [short] drops a zero fraction (`€1,050`) and [compactDecimals] forces
  /// a digit count (0 for whole-unit summaries).
  static String format(
    double value,
    String currencyCode, {
    bool sign = false,
    bool short = false,
    int? decimals,
  }) {
    final abs = value.abs();
    var digits = decimals ?? decimalsFor(currencyCode);
    if (short && (abs - abs.roundToDouble()).abs() < 0.005) digits = 0;
    final number = NumberFormat.decimalPatternDigits(decimalDigits: digits)
        .format(abs);
    final prefix = value < 0 && abs >= 0.005
        ? ledgerMinus
        : (sign && value > 0 ? '+' : '');
    final symbol = _prefixSymbol(currencyCode);
    if (symbol != null) return '$prefix$symbol$number';
    return '$prefix$number $currencyCode';
  }
}

/// Converts between currencies with rates quoted against one base currency
/// (`rates[base] == 1`). Unknown codes convert at 1.
double ledgerConvert(
  double amount,
  String from,
  String to,
  Map<String, double>? rates,
) {
  if (from == to || rates == null) return amount;
  final inBase = amount / (rates[from] ?? 1);
  return inBase * (rates[to] ?? 1);
}
