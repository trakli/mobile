import 'package:drift/drift.dart';
import 'package:trakli/domain/entities/party_entity.dart';

class PartyTypeConverter extends TypeConverter<PartyType, String>
    with JsonTypeConverter2<PartyType, String, String> {
  const PartyTypeConverter();

  @override
  PartyType fromSql(String fromDb) {
    return PartyTypeX.fromServerKey(fromDb);
  }

  @override
  String toSql(PartyType value) {
    return value.serverKey;
  }

  @override
  PartyType fromJson(String json) {
    return PartyTypeX.fromServerKey(json);
  }

  @override
  String toJson(PartyType value) {
    return value.serverKey;
  }
}
