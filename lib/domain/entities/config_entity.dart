import 'package:equatable/equatable.dart';

class ConfigEntity extends Equatable {
  final int id;
  final int userId;
  final String key;
  final dynamic value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConfigEntity({
    required this.id,
    required this.userId,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        key,
        value,
        createdAt,
        updatedAt,
      ];
}
