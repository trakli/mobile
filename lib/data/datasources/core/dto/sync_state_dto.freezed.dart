// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncStateDto _$SyncStateDtoFromJson(Map<String, dynamic> json) {
  return _SyncStateDto.fromJson(json);
}

/// @nodoc
mixin _$SyncStateDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'syncable_type')
  String get syncableType => throw _privateConstructorUsedError;
  @JsonKey(name: 'syncable_id')
  int get syncableId => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id')
  String get clientGeneratedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at')
  String get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SyncStateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStateDtoCopyWith<SyncStateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateDtoCopyWith<$Res> {
  factory $SyncStateDtoCopyWith(
          SyncStateDto value, $Res Function(SyncStateDto) then) =
      _$SyncStateDtoCopyWithImpl<$Res, SyncStateDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'syncable_type') String syncableType,
      @JsonKey(name: 'syncable_id') int syncableId,
      String? source,
      @JsonKey(name: 'client_generated_id') String clientGeneratedId,
      @JsonKey(name: 'last_synced_at') String lastSyncedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$SyncStateDtoCopyWithImpl<$Res, $Val extends SyncStateDto>
    implements $SyncStateDtoCopyWith<$Res> {
  _$SyncStateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? syncableType = null,
    Object? syncableId = null,
    Object? source = freezed,
    Object? clientGeneratedId = null,
    Object? lastSyncedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      syncableType: null == syncableType
          ? _value.syncableType
          : syncableType // ignore: cast_nullable_to_non_nullable
              as String,
      syncableId: null == syncableId
          ? _value.syncableId
          : syncableId // ignore: cast_nullable_to_non_nullable
              as int,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      clientGeneratedId: null == clientGeneratedId
          ? _value.clientGeneratedId
          : clientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStateDtoImplCopyWith<$Res>
    implements $SyncStateDtoCopyWith<$Res> {
  factory _$$SyncStateDtoImplCopyWith(
          _$SyncStateDtoImpl value, $Res Function(_$SyncStateDtoImpl) then) =
      __$$SyncStateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'syncable_type') String syncableType,
      @JsonKey(name: 'syncable_id') int syncableId,
      String? source,
      @JsonKey(name: 'client_generated_id') String clientGeneratedId,
      @JsonKey(name: 'last_synced_at') String lastSyncedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$SyncStateDtoImplCopyWithImpl<$Res>
    extends _$SyncStateDtoCopyWithImpl<$Res, _$SyncStateDtoImpl>
    implements _$$SyncStateDtoImplCopyWith<$Res> {
  __$$SyncStateDtoImplCopyWithImpl(
      _$SyncStateDtoImpl _value, $Res Function(_$SyncStateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? syncableType = null,
    Object? syncableId = null,
    Object? source = freezed,
    Object? clientGeneratedId = null,
    Object? lastSyncedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SyncStateDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      syncableType: null == syncableType
          ? _value.syncableType
          : syncableType // ignore: cast_nullable_to_non_nullable
              as String,
      syncableId: null == syncableId
          ? _value.syncableId
          : syncableId // ignore: cast_nullable_to_non_nullable
              as int,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      clientGeneratedId: null == clientGeneratedId
          ? _value.clientGeneratedId
          : clientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncStateDtoImpl implements _SyncStateDto {
  const _$SyncStateDtoImpl(
      {required this.id,
      @JsonKey(name: 'syncable_type') required this.syncableType,
      @JsonKey(name: 'syncable_id') required this.syncableId,
      this.source,
      @JsonKey(name: 'client_generated_id') required this.clientGeneratedId,
      @JsonKey(name: 'last_synced_at') required this.lastSyncedAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$SyncStateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStateDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'syncable_type')
  final String syncableType;
  @override
  @JsonKey(name: 'syncable_id')
  final int syncableId;
  @override
  final String? source;
  @override
  @JsonKey(name: 'client_generated_id')
  final String clientGeneratedId;
  @override
  @JsonKey(name: 'last_synced_at')
  final String lastSyncedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SyncStateDto(id: $id, syncableType: $syncableType, syncableId: $syncableId, source: $source, clientGeneratedId: $clientGeneratedId, lastSyncedAt: $lastSyncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.syncableType, syncableType) ||
                other.syncableType == syncableType) &&
            (identical(other.syncableId, syncableId) ||
                other.syncableId == syncableId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.clientGeneratedId, clientGeneratedId) ||
                other.clientGeneratedId == clientGeneratedId) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, syncableType, syncableId,
      source, clientGeneratedId, lastSyncedAt, createdAt, updatedAt);

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateDtoImplCopyWith<_$SyncStateDtoImpl> get copyWith =>
      __$$SyncStateDtoImplCopyWithImpl<_$SyncStateDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStateDtoImplToJson(
      this,
    );
  }
}

abstract class _SyncStateDto implements SyncStateDto {
  const factory _SyncStateDto(
          {required final int id,
          @JsonKey(name: 'syncable_type') required final String syncableType,
          @JsonKey(name: 'syncable_id') required final int syncableId,
          final String? source,
          @JsonKey(name: 'client_generated_id')
          required final String clientGeneratedId,
          @JsonKey(name: 'last_synced_at') required final String lastSyncedAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$SyncStateDtoImpl;

  factory _SyncStateDto.fromJson(Map<String, dynamic> json) =
      _$SyncStateDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'syncable_type')
  String get syncableType;
  @override
  @JsonKey(name: 'syncable_id')
  int get syncableId;
  @override
  String? get source;
  @override
  @JsonKey(name: 'client_generated_id')
  String get clientGeneratedId;
  @override
  @JsonKey(name: 'last_synced_at')
  String get lastSyncedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateDtoImplCopyWith<_$SyncStateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
