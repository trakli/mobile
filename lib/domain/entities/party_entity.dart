import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

enum PartyType {
  individual,
  organization,
  business,
  partnership,
  @JsonValue('non_profit')
  nonProfit,
  @JsonValue('government_agency')
  governmentAgency,
  @JsonValue('educational_institution')
  educationalInstitution,
  @JsonValue('healthcare_provider')
  healthcareProvider,
}

extension PartyTypeX on PartyType {
  String get serverKey {
    switch (this) {
      case PartyType.individual:
        return 'individual';
      case PartyType.organization:
        return 'organization';
      case PartyType.business:
        return 'business';
      case PartyType.partnership:
        return 'partnership';
      case PartyType.nonProfit:
        return 'non_profit';
      case PartyType.governmentAgency:
        return 'government_agency';
      case PartyType.educationalInstitution:
        return 'educational_institution';
      case PartyType.healthcareProvider:
        return 'healthcare_provider';
    }
  }

  String get customName {
    switch (this) {
      case PartyType.individual:
        return LocaleKeys.partyTypeIndividual.tr();
      case PartyType.organization:
        return LocaleKeys.partyTypeOrganization.tr();
      case PartyType.business:
        return LocaleKeys.partyTypeBusiness.tr();
      case PartyType.partnership:
        return LocaleKeys.partyTypePartnership.tr();
      case PartyType.nonProfit:
        return LocaleKeys.partyTypeNonProfit.tr();
      case PartyType.governmentAgency:
        return LocaleKeys.partyTypeGovernmentAgency.tr();
      case PartyType.educationalInstitution:
        return LocaleKeys.partyTypeEducationalInstitution.tr();
      case PartyType.healthcareProvider:
        return LocaleKeys.partyTypeHealthcareProvider.tr();
    }
  }

  static PartyType fromServerKey(String key) {
    switch (key) {
      case 'individual':
        return PartyType.individual;
      case 'organization':
        return PartyType.organization;
      case 'business':
        return PartyType.business;
      case 'partnership':
        return PartyType.partnership;
      case 'non_profit':
        return PartyType.nonProfit;
      case 'government_agency':
        return PartyType.governmentAgency;
      case 'educational_institution':
        return PartyType.educationalInstitution;
      case 'healthcare_provider':
        return PartyType.healthcareProvider;
      default:
        throw ArgumentError('Unknown PartyType server key: $key');
    }
  }
}

class PartyEntity extends Equatable {
  final String clientId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? id;
  final int? userId;
  final MediaEntity? icon;
  final PartyType? type;

  const PartyEntity({
    required this.clientId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.id,
    this.userId,
    this.icon,
    this.type,
  });

  @override
  List<Object?> get props => [
        clientId,
        name,
        description,
        createdAt,
        updatedAt,
        id,
        userId,
        icon,
        type,
      ];
}
