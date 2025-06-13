import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';

class GroupMapper {
  static GroupEntity toDomain(Group group) {
    return GroupEntity(
      clientId: group.clientId,
      name: group.name,
      description: group.description,
      createdAt: group.createdAt,
      id: group.id,
      userId: group.userId,
      updatedAt: group.updatedAt,
      icon: group.icon != null ? MediaEntity.fromModel(group.icon!) : null,
    );
  }

  static List<GroupEntity> toDomainList(List<Group> groups) {
    return groups.map((group) => toDomain(group)).toList();
  }
}
