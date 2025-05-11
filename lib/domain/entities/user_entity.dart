import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String firstName,
    required String email,
    String? lastName,
    String? username,
    String? phone,
  }) = _UserEntity;

  const UserEntity._();

  String get fullName =>
      '$firstName ${(lastName == null || lastName!.isEmpty) ? '' : '$lastName'}';
}
