// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) {
  return _CategoryDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryDto {
  @JsonKey(name: 'client_generated_id')
  String get clientId => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_state')
  SyncStateDto get syncState => throw _privateConstructorUsedError;

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDtoCopyWith<CategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDtoCopyWith<$Res> {
  factory $CategoryDtoCopyWith(
          CategoryDto value, $Res Function(CategoryDto) then) =
      _$CategoryDtoCopyWithImpl<$Res, CategoryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id') String clientId,
      TransactionType type,
      String name,
      String? description,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      int? id,
      String slug,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto syncState});

  $SyncStateDtoCopyWith<$Res> get syncState;
}

/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res, $Val extends CategoryDto>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? id = freezed,
    Object? slug = null,
    Object? userId = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? syncState = null,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SyncStateDto,
    ) as $Val);
  }

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SyncStateDtoCopyWith<$Res> get syncState {
    return $SyncStateDtoCopyWith<$Res>(_value.syncState, (value) {
      return _then(_value.copyWith(syncState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryDtoImplCopyWith<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  factory _$$CategoryDtoImplCopyWith(
          _$CategoryDtoImpl value, $Res Function(_$CategoryDtoImpl) then) =
      __$$CategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id') String clientId,
      TransactionType type,
      String name,
      String? description,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      int? id,
      String slug,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto syncState});

  @override
  $SyncStateDtoCopyWith<$Res> get syncState;
}

/// @nodoc
class __$$CategoryDtoImplCopyWithImpl<$Res>
    extends _$CategoryDtoCopyWithImpl<$Res, _$CategoryDtoImpl>
    implements _$$CategoryDtoImplCopyWith<$Res> {
  __$$CategoryDtoImplCopyWithImpl(
      _$CategoryDtoImpl _value, $Res Function(_$CategoryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? id = freezed,
    Object? slug = null,
    Object? userId = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? syncState = null,
  }) {
    return _then(_$CategoryDtoImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SyncStateDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDtoImpl implements _CategoryDto {
  const _$CategoryDtoImpl(
      {@JsonKey(name: 'client_generated_id') required this.clientId,
      required this.type,
      required this.name,
      this.description,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse)
      required this.createdAt,
      this.id,
      required this.slug,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
      required this.updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      this.lastSyncedAt,
      @JsonKey(name: 'sync_state') required this.syncState});

  factory _$CategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'client_generated_id')
  final String clientId;
  @override
  final TransactionType type;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  final DateTime createdAt;
  @override
  final int? id;
  @override
  final String slug;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey(name: 'sync_state')
  final SyncStateDto syncState;

  @override
  String toString() {
    return 'CategoryDto(clientId: $clientId, type: $type, name: $name, description: $description, createdAt: $createdAt, id: $id, slug: $slug, userId: $userId, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, syncState: $syncState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDtoImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.syncState, syncState) ||
                other.syncState == syncState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      clientId,
      type,
      name,
      description,
      createdAt,
      id,
      slug,
      userId,
      updatedAt,
      lastSyncedAt,
      syncState);

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDtoImplCopyWith<_$CategoryDtoImpl> get copyWith =>
      __$$CategoryDtoImplCopyWithImpl<_$CategoryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDtoImplToJson(
      this,
    );
  }
}

abstract class _CategoryDto implements CategoryDto {
  const factory _CategoryDto(
          {@JsonKey(name: 'client_generated_id') required final String clientId,
          required final TransactionType type,
          required final String name,
          final String? description,
          @JsonKey(name: 'created_at', fromJson: DateTime.parse)
          required final DateTime createdAt,
          final int? id,
          required final String slug,
          @JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
          required final DateTime updatedAt,
          @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
          final DateTime? lastSyncedAt,
          @JsonKey(name: 'sync_state') required final SyncStateDto syncState}) =
      _$CategoryDtoImpl;

  factory _CategoryDto.fromJson(Map<String, dynamic> json) =
      _$CategoryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'client_generated_id')
  String get clientId;
  @override
  TransactionType get type;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt;
  @override
  int? get id;
  @override
  String get slug;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
  DateTime? get lastSyncedAt;
  @override
  @JsonKey(name: 'sync_state')
  SyncStateDto get syncState;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDtoImplCopyWith<_$CategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
