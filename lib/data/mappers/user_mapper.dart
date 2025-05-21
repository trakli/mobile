import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity toDomain(User user) {
    return UserEntity(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      phone: user.phone,
      email: user.email,
    );
  }

  static List<UserEntity> toDomainList(List<User> users) {
    return users.map((user) => toDomain(user)).toList();
  }

  static User toData(UserEntity user) {
    return User(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      phone: user.phone,
      email: user.email,
    );
  }
}
