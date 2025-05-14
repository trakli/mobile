// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryEntity _$CategoryEntityFromJson(Map<String, dynamic> json) {
  return _CategoryEntity.fromJson(json);
}

/// @nodoc
mixin _$CategoryEntity {
  @JsonKey(name: 'client_generated_id')
  String? get clientGeneratedId => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at')
  String? get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_state')
  SyncStateDto? get syncState => throw _privateConstructorUsedError;

  /// Serializes this CategoryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryEntityCopyWith<CategoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryEntityCopyWith<$Res> {
  factory $CategoryEntityCopyWith(
          CategoryEntity value, $Res Function(CategoryEntity) then) =
      _$CategoryEntityCopyWithImpl<$Res, CategoryEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id') String? clientGeneratedId,
      TransactionType type,
      String name,
      String? description,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      int? id,
      String? slug,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'last_synced_at') String? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto? syncState});

  $SyncStateDtoCopyWith<$Res>? get syncState;
}

/// @nodoc
class _$CategoryEntityCopyWithImpl<$Res, $Val extends CategoryEntity>
    implements $CategoryEntityCopyWith<$Res> {
  _$CategoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientGeneratedId = freezed,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? id = freezed,
    Object? slug = freezed,
    Object? userId = freezed,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? syncState = freezed,
  }) {
    return _then(_value.copyWith(
      clientGeneratedId: freezed == clientGeneratedId
          ? _value.clientGeneratedId
          : clientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      syncState: freezed == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SyncStateDto?,
    ) as $Val);
  }

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SyncStateDtoCopyWith<$Res>? get syncState {
    if (_value.syncState == null) {
      return null;
    }

    return $SyncStateDtoCopyWith<$Res>(_value.syncState!, (value) {
      return _then(_value.copyWith(syncState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryEntityImplCopyWith<$Res>
    implements $CategoryEntityCopyWith<$Res> {
  factory _$$CategoryEntityImplCopyWith(_$CategoryEntityImpl value,
          $Res Function(_$CategoryEntityImpl) then) =
      __$$CategoryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id') String? clientGeneratedId,
      TransactionType type,
      String name,
      String? description,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      int? id,
      String? slug,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'last_synced_at') String? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto? syncState});

  @override
  $SyncStateDtoCopyWith<$Res>? get syncState;
}

/// @nodoc
class __$$CategoryEntityImplCopyWithImpl<$Res>
    extends _$CategoryEntityCopyWithImpl<$Res, _$CategoryEntityImpl>
    implements _$$CategoryEntityImplCopyWith<$Res> {
  __$$CategoryEntityImplCopyWithImpl(
      _$CategoryEntityImpl _value, $Res Function(_$CategoryEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientGeneratedId = freezed,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? id = freezed,
    Object? slug = freezed,
    Object? userId = freezed,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? syncState = freezed,
  }) {
    return _then(_$CategoryEntityImpl(
      clientGeneratedId: freezed == clientGeneratedId
          ? _value.clientGeneratedId
          : clientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      syncState: freezed == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SyncStateDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryEntityImpl implements _CategoryEntity {
  const _$CategoryEntityImpl(
      {@JsonKey(name: 'client_generated_id') this.clientGeneratedId,
      required this.type,
      required this.name,
      this.description,
      @JsonKey(name: 'created_at') this.createdAt,
      this.id,
      this.slug,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'last_synced_at') this.lastSyncedAt,
      @JsonKey(name: 'sync_state') this.syncState});

  factory _$CategoryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryEntityImplFromJson(json);

  @override
  @JsonKey(name: 'client_generated_id')
  final String? clientGeneratedId;
  @override
  final TransactionType type;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  final int? id;
  @override
  final String? slug;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'last_synced_at')
  final String? lastSyncedAt;
  @override
  @JsonKey(name: 'sync_state')
  final SyncStateDto? syncState;

  @override
  String toString() {
    return 'CategoryEntity(clientGeneratedId: $clientGeneratedId, type: $type, name: $name, description: $description, createdAt: $createdAt, id: $id, slug: $slug, userId: $userId, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, syncState: $syncState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryEntityImpl &&
            (identical(other.clientGeneratedId, clientGeneratedId) ||
                other.clientGeneratedId == clientGeneratedId) &&
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
      clientGeneratedId,
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

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryEntityImplCopyWith<_$CategoryEntityImpl> get copyWith =>
      __$$CategoryEntityImplCopyWithImpl<_$CategoryEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryEntityImplToJson(
      this,
    );
  }
}

abstract class _CategoryEntity implements CategoryEntity {
  const factory _CategoryEntity(
      {@JsonKey(name: 'client_generated_id') final String? clientGeneratedId,
      required final TransactionType type,
      required final String name,
      final String? description,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      final int? id,
      final String? slug,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'last_synced_at') final String? lastSyncedAt,
      @JsonKey(name: 'sync_state')
      final SyncStateDto? syncState}) = _$CategoryEntityImpl;

  factory _CategoryEntity.fromJson(Map<String, dynamic> json) =
      _$CategoryEntityImpl.fromJson;

  @override
  @JsonKey(name: 'client_generated_id')
  String? get clientGeneratedId;
  @override
  TransactionType get type;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  int? get id;
  @override
  String? get slug;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'last_synced_at')
  String? get lastSyncedAt;
  @override
  @JsonKey(name: 'sync_state')
  SyncStateDto? get syncState;

  /// Create a copy of CategoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryEntityImplCopyWith<_$CategoryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
