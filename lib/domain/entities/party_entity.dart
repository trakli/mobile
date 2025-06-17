import 'package:equatable/equatable.dart';
import 'package:trakli/domain/entities/media_entity.dart';

class PartyEntity extends Equatable {
  final String clientId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? id;
  final int? userId;
  final MediaEntity? icon;

  const PartyEntity({
    required this.clientId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.id,
    this.userId,
    this.icon,
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
      ];
}
