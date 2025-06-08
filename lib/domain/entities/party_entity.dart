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
  final MediaEntity? media;

  const PartyEntity({
    required this.clientId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.id,
    this.userId,
    this.media,
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
        media,
      ];
}
