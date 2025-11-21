import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

enum ConfigType {
  string,
  @JsonValue('int')
  int,
  float,
  @JsonValue('bool')
  bool,
  array,
  json,
  date,
}

extension ConfigTypeX on ConfigType {
  String get serverKey {
    switch (this) {
      case ConfigType.string:
        return 'string';
      case ConfigType.int:
        return 'int';
      case ConfigType.float:
        return 'float';
      case ConfigType.bool:
        return 'bool';
      case ConfigType.array:
        return 'array';
      case ConfigType.json:
        return 'json';
      case ConfigType.date:
        return 'date';
    }
  }

  static ConfigType fromServerKey(String key) {
    switch (key) {
      case 'string':
        return ConfigType.string;
      case 'int':
        return ConfigType.int;
      case 'float':
        return ConfigType.float;
      case 'bool':
        return ConfigType.bool;
      case 'array':
        return ConfigType.array;
      case 'json':
        return ConfigType.json;
      case 'date':
        return ConfigType.date;
      default:
        throw ArgumentError('Unknown ConfigType server key: $key');
    }
  }
}

class ConfigEntity extends Equatable {
  final int id;
  final int userId;
  final String key;
  final ConfigType type;
  final dynamic value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConfigEntity({
    required this.id,
    required this.userId,
    required this.key,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        key,
        type,
        value,
        createdAt,
        updatedAt,
      ];
}
