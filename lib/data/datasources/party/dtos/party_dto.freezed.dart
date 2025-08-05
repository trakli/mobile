// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartyDto _$PartyDtoFromJson(Map<String, dynamic> json) {
  return _PartyDto.fromJson(json);
}

/// @nodoc
mixin _$PartyDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey()
  PartyType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id')
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  Media? get media => throw _privateConstructorUsedError;

  /// Serializes this PartyDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyDtoCopyWith<PartyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyDtoCopyWith<$Res> {
  factory $PartyDtoCopyWith(PartyDto value, $Res Function(PartyDto) then) =
      _$PartyDtoCopyWithImpl<$Res, PartyDto>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey() PartyType type,
      @JsonKey(name: 'client_generated_id') String clientId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      int userId,
      Media? media});
}

/// @nodoc
class _$PartyDtoCopyWithImpl<$Res, $Val extends PartyDto>
    implements $PartyDtoCopyWith<$Res> {
  _$PartyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? clientId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? userId = null,
    Object? media = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PartyType,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as Media?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartyDtoImplCopyWith<$Res>
    implements $PartyDtoCopyWith<$Res> {
  factory _$$PartyDtoImplCopyWith(
          _$PartyDtoImpl value, $Res Function(_$PartyDtoImpl) then) =
      __$$PartyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey() PartyType type,
      @JsonKey(name: 'client_generated_id') String clientId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      int userId,
      Media? media});
}

/// @nodoc
class __$$PartyDtoImplCopyWithImpl<$Res>
    extends _$PartyDtoCopyWithImpl<$Res, _$PartyDtoImpl>
    implements _$$PartyDtoImplCopyWith<$Res> {
  __$$PartyDtoImplCopyWithImpl(
      _$PartyDtoImpl _value, $Res Function(_$PartyDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? clientId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? userId = null,
    Object? media = freezed,
  }) {
    return _then(_$PartyDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PartyType,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as Media?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyDtoImpl extends _PartyDto {
  const _$PartyDtoImpl(
      {required this.id,
      required this.name,
      this.description,
      @JsonKey() required this.type,
      @JsonKey(name: 'client_generated_id') required this.clientId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      required this.userId,
      this.media})
      : super._();

  factory _$PartyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final PartyType type;
  @override
  @JsonKey(name: 'client_generated_id')
  final String clientId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @override
  final int userId;
  @override
  final Media? media;

  @override
  String toString() {
    return 'PartyDto(id: $id, name: $name, description: $description, type: $type, clientId: $clientId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.media, media) || other.media == media));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, type,
      clientId, createdAt, updatedAt, deletedAt, userId, media);

  /// Create a copy of PartyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyDtoImplCopyWith<_$PartyDtoImpl> get copyWith =>
      __$$PartyDtoImplCopyWithImpl<_$PartyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyDtoImplToJson(
      this,
    );
  }
}

abstract class _PartyDto extends PartyDto {
  const factory _PartyDto(
      {required final int id,
      required final String name,
      final String? description,
      @JsonKey() required final PartyType type,
      @JsonKey(name: 'client_generated_id') required final String clientId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      required final int userId,
      final Media? media}) = _$PartyDtoImpl;
  const _PartyDto._() : super._();

  factory _PartyDto.fromJson(Map<String, dynamic> json) =
      _$PartyDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey()
  PartyType get type;
  @override
  @JsonKey(name: 'client_generated_id')
  String get clientId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  int get userId;
  @override
  Media? get media;

  /// Create a copy of PartyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyDtoImplCopyWith<_$PartyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
