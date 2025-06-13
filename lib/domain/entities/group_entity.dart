import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/media_entity.dart';

part 'group_entity.freezed.dart';

@freezed
class GroupEntity with _$GroupEntity {
  const factory GroupEntity({
    required String clientId,
    required String name,
    String? description,
    required DateTime createdAt,
    int? id,
    int? userId,
    required DateTime updatedAt,
    MediaEntity? icon,
  }) = _GroupEntity;

  const GroupEntity._();
}
