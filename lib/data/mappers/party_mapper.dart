import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/party_entity.dart';

class PartyMapper {
  static PartyEntity toDomain(Party party) {
    return PartyEntity(
      clientId: party.clientId,
      name: party.name,
      description: party.description,
      createdAt: party.createdAt,
      updatedAt: party.updatedAt,
      id: party.id,
      userId: party.userId,
      icon: party.icon?.toEntity(),
    );
  }

  static List<PartyEntity> toDomainList(List<Party> parties) {
    return parties.map((party) => toDomain(party)).toList();
  }
}
