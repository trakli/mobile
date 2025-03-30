// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) {
  return _TransactionEntity.fromJson(json);
}

/// @nodoc
mixin _$TransactionEntity {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get createdAtLocal => throw _privateConstructorUsedError;
  DateTime get updatedAtLocal => throw _privateConstructorUsedError;
  DateTime? get updatedAtServer => throw _privateConstructorUsedError;
  DateTime? get deletedAtServer => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  String get rev => throw _privateConstructorUsedError;

  /// Serializes this TransactionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
          TransactionEntity value, $Res Function(TransactionEntity) then) =
      _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call(
      {String id,
      double amount,
      String description,
      String category,
      DateTime createdAtLocal,
      DateTime updatedAtLocal,
      DateTime? updatedAtServer,
      DateTime? deletedAtServer,
      DateTime? lastSyncedAt,
      String rev});
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? description = null,
    Object? category = null,
    Object? createdAtLocal = null,
    Object? updatedAtLocal = null,
    Object? updatedAtServer = freezed,
    Object? deletedAtServer = freezed,
    Object? lastSyncedAt = freezed,
    Object? rev = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtLocal: null == createdAtLocal
          ? _value.createdAtLocal
          : createdAtLocal // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAtLocal: null == updatedAtLocal
          ? _value.updatedAtLocal
          : updatedAtLocal // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAtServer: freezed == updatedAtServer
          ? _value.updatedAtServer
          : updatedAtServer // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAtServer: freezed == deletedAtServer
          ? _value.deletedAtServer
          : deletedAtServer // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rev: null == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionEntityImplCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$TransactionEntityImplCopyWith(_$TransactionEntityImpl value,
          $Res Function(_$TransactionEntityImpl) then) =
      __$$TransactionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      String description,
      String category,
      DateTime createdAtLocal,
      DateTime updatedAtLocal,
      DateTime? updatedAtServer,
      DateTime? deletedAtServer,
      DateTime? lastSyncedAt,
      String rev});
}

/// @nodoc
class __$$TransactionEntityImplCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$TransactionEntityImpl>
    implements _$$TransactionEntityImplCopyWith<$Res> {
  __$$TransactionEntityImplCopyWithImpl(_$TransactionEntityImpl _value,
      $Res Function(_$TransactionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? description = null,
    Object? category = null,
    Object? createdAtLocal = null,
    Object? updatedAtLocal = null,
    Object? updatedAtServer = freezed,
    Object? deletedAtServer = freezed,
    Object? lastSyncedAt = freezed,
    Object? rev = null,
  }) {
    return _then(_$TransactionEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtLocal: null == createdAtLocal
          ? _value.createdAtLocal
          : createdAtLocal // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAtLocal: null == updatedAtLocal
          ? _value.updatedAtLocal
          : updatedAtLocal // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAtServer: freezed == updatedAtServer
          ? _value.updatedAtServer
          : updatedAtServer // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAtServer: freezed == deletedAtServer
          ? _value.deletedAtServer
          : deletedAtServer // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rev: null == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionEntityImpl implements _TransactionEntity {
  const _$TransactionEntityImpl(
      {required this.id,
      required this.amount,
      required this.description,
      required this.category,
      required this.createdAtLocal,
      required this.updatedAtLocal,
      this.updatedAtServer,
      this.deletedAtServer,
      this.lastSyncedAt,
      this.rev = '1'});

  factory _$TransactionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionEntityImplFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  final String description;
  @override
  final String category;
  @override
  final DateTime createdAtLocal;
  @override
  final DateTime updatedAtLocal;
  @override
  final DateTime? updatedAtServer;
  @override
  final DateTime? deletedAtServer;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final String rev;

  @override
  String toString() {
    return 'TransactionEntity(id: $id, amount: $amount, description: $description, category: $category, createdAtLocal: $createdAtLocal, updatedAtLocal: $updatedAtLocal, updatedAtServer: $updatedAtServer, deletedAtServer: $deletedAtServer, lastSyncedAt: $lastSyncedAt, rev: $rev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAtLocal, createdAtLocal) ||
                other.createdAtLocal == createdAtLocal) &&
            (identical(other.updatedAtLocal, updatedAtLocal) ||
                other.updatedAtLocal == updatedAtLocal) &&
            (identical(other.updatedAtServer, updatedAtServer) ||
                other.updatedAtServer == updatedAtServer) &&
            (identical(other.deletedAtServer, deletedAtServer) ||
                other.deletedAtServer == deletedAtServer) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.rev, rev) || other.rev == rev));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      description,
      category,
      createdAtLocal,
      updatedAtLocal,
      updatedAtServer,
      deletedAtServer,
      lastSyncedAt,
      rev);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      __$$TransactionEntityImplCopyWithImpl<_$TransactionEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionEntityImplToJson(
      this,
    );
  }
}

abstract class _TransactionEntity implements TransactionEntity {
  const factory _TransactionEntity(
      {required final String id,
      required final double amount,
      required final String description,
      required final String category,
      required final DateTime createdAtLocal,
      required final DateTime updatedAtLocal,
      final DateTime? updatedAtServer,
      final DateTime? deletedAtServer,
      final DateTime? lastSyncedAt,
      final String rev}) = _$TransactionEntityImpl;

  factory _TransactionEntity.fromJson(Map<String, dynamic> json) =
      _$TransactionEntityImpl.fromJson;

  @override
  String get id;
  @override
  double get amount;
  @override
  String get description;
  @override
  String get category;
  @override
  DateTime get createdAtLocal;
  @override
  DateTime get updatedAtLocal;
  @override
  DateTime? get updatedAtServer;
  @override
  DateTime? get deletedAtServer;
  @override
  DateTime? get lastSyncedAt;
  @override
  String get rev;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
