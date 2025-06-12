// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupEntity {
  String get clientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  MediaEntity? get icon => throw _privateConstructorUsedError;

  /// Create a copy of GroupEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupEntityCopyWith<GroupEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupEntityCopyWith<$Res> {
  factory $GroupEntityCopyWith(
          GroupEntity value, $Res Function(GroupEntity) then) =
      _$GroupEntityCopyWithImpl<$Res, GroupEntity>;
  @useResult
  $Res call(
      {String clientId,
      String name,
      String? description,
      DateTime createdAt,
      int? id,
      int? userId,
      DateTime updatedAt,
      MediaEntity? icon});
}

/// @nodoc
class _$GroupEntityCopyWithImpl<$Res, $Val extends GroupEntity>
    implements $GroupEntityCopyWith<$Res> {
  _$GroupEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? updatedAt = null,
    Object? icon = freezed,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as MediaEntity?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupEntityImplCopyWith<$Res>
    implements $GroupEntityCopyWith<$Res> {
  factory _$$GroupEntityImplCopyWith(
          _$GroupEntityImpl value, $Res Function(_$GroupEntityImpl) then) =
      __$$GroupEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      String name,
      String? description,
      DateTime createdAt,
      int? id,
      int? userId,
      DateTime updatedAt,
      MediaEntity? icon});
}

/// @nodoc
class __$$GroupEntityImplCopyWithImpl<$Res>
    extends _$GroupEntityCopyWithImpl<$Res, _$GroupEntityImpl>
    implements _$$GroupEntityImplCopyWith<$Res> {
  __$$GroupEntityImplCopyWithImpl(
      _$GroupEntityImpl _value, $Res Function(_$GroupEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? updatedAt = null,
    Object? icon = freezed,
  }) {
    return _then(_$GroupEntityImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as MediaEntity?,
    ));
  }
}

/// @nodoc

class _$GroupEntityImpl extends _GroupEntity {
  const _$GroupEntityImpl(
      {required this.clientId,
      required this.name,
      this.description,
      required this.createdAt,
      this.id,
      this.userId,
      required this.updatedAt,
      this.icon})
      : super._();

  @override
  final String clientId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final int? id;
  @override
  final int? userId;
  @override
  final DateTime updatedAt;
  @override
  final MediaEntity? icon;

  @override
  String toString() {
    return 'GroupEntity(clientId: $clientId, name: $name, description: $description, createdAt: $createdAt, id: $id, userId: $userId, updatedAt: $updatedAt, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupEntityImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, clientId, name, description,
      createdAt, id, userId, updatedAt, icon);

  /// Create a copy of GroupEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupEntityImplCopyWith<_$GroupEntityImpl> get copyWith =>
      __$$GroupEntityImplCopyWithImpl<_$GroupEntityImpl>(this, _$identity);
}

abstract class _GroupEntity extends GroupEntity {
  const factory _GroupEntity(
      {required final String clientId,
      required final String name,
      final String? description,
      required final DateTime createdAt,
      final int? id,
      final int? userId,
      required final DateTime updatedAt,
      final MediaEntity? icon}) = _$GroupEntityImpl;
  const _GroupEntity._() : super._();

  @override
  String get clientId;
  @override
  String get name;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  int? get id;
  @override
  int? get userId;
  @override
  DateTime get updatedAt;
  @override
  MediaEntity? get icon;

  /// Create a copy of GroupEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupEntityImplCopyWith<_$GroupEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
