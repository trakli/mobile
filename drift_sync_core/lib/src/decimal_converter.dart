import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

class DecimalConverter extends TypeConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromSql(String fromDb) {
    try {
      final d = Decimal.parse(fromDb);
      return d;
    } catch (e) {
      throw FormatException('Could not parse "$fromDb" as Decimal', e);
    }
  }

  @override
  String toSql(Decimal value) {
    return value.toString();
  }
}
