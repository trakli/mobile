import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

class DecimalConverter extends TypeConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromSql(String fromDb) {
    final d = Decimal.parse(fromDb);
    return d;
  }

  @override
  String toSql(Decimal value) {
    return value.toString();
  }
}
