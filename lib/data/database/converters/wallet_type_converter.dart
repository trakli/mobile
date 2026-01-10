import 'package:drift/drift.dart';
import 'package:trakli/presentation/utils/enums.dart';

class WalletTypeConverter extends TypeConverter<WalletType, String>
    with JsonTypeConverter2<WalletType, String, String> {
  const WalletTypeConverter();

  @override
  WalletType fromSql(String fromDb) {
    return WalletType.fromServerKey(fromDb);
  }

  @override
  String toSql(WalletType value) {
    return value.serverKey;
  }

  @override
  WalletType fromJson(String json) {
    return WalletType.fromServerKey(json);
  }

  @override
  String toJson(WalletType value) {
    return value.serverKey;
  }
}
