// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalletEntity {
  String get clientId => throw _privateConstructorUsedError;
  WalletType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  WalletStatsEntity? get stats => throw _privateConstructorUsedError;
  MediaEntity? get icon => throw _privateConstructorUsedError;

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletEntityCopyWith<WalletEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletEntityCopyWith<$Res> {
  factory $WalletEntityCopyWith(
          WalletEntity value, $Res Function(WalletEntity) then) =
      _$WalletEntityCopyWithImpl<$Res, WalletEntity>;
  @useResult
  $Res call(
      {String clientId,
      WalletType type,
      String name,
      String? description,
      double balance,
      String currencyCode,
      DateTime createdAt,
      int? id,
      int? userId,
      DateTime updatedAt,
      WalletStatsEntity? stats,
      MediaEntity? icon});

  $WalletStatsEntityCopyWith<$Res>? get stats;
}

/// @nodoc
class _$WalletEntityCopyWithImpl<$Res, $Val extends WalletEntity>
    implements $WalletEntityCopyWith<$Res> {
  _$WalletEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? balance = null,
    Object? currencyCode = null,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? icon = freezed,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WalletType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
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
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WalletStatsEntity?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as MediaEntity?,
    ) as $Val);
  }

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletStatsEntityCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $WalletStatsEntityCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletEntityImplCopyWith<$Res>
    implements $WalletEntityCopyWith<$Res> {
  factory _$$WalletEntityImplCopyWith(
          _$WalletEntityImpl value, $Res Function(_$WalletEntityImpl) then) =
      __$$WalletEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      WalletType type,
      String name,
      String? description,
      double balance,
      String currencyCode,
      DateTime createdAt,
      int? id,
      int? userId,
      DateTime updatedAt,
      WalletStatsEntity? stats,
      MediaEntity? icon});

  @override
  $WalletStatsEntityCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$WalletEntityImplCopyWithImpl<$Res>
    extends _$WalletEntityCopyWithImpl<$Res, _$WalletEntityImpl>
    implements _$$WalletEntityImplCopyWith<$Res> {
  __$$WalletEntityImplCopyWithImpl(
      _$WalletEntityImpl _value, $Res Function(_$WalletEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? balance = null,
    Object? currencyCode = null,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = freezed,
    Object? updatedAt = null,
    Object? stats = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$WalletEntityImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WalletType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
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
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WalletStatsEntity?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as MediaEntity?,
    ));
  }
}

/// @nodoc

class _$WalletEntityImpl extends _WalletEntity {
  const _$WalletEntityImpl(
      {required this.clientId,
      required this.type,
      required this.name,
      this.description,
      required this.balance,
      required this.currencyCode,
      required this.createdAt,
      this.id,
      this.userId,
      required this.updatedAt,
      this.stats,
      this.icon})
      : super._();

  @override
  final String clientId;
  @override
  final WalletType type;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double balance;
  @override
  final String currencyCode;
  @override
  final DateTime createdAt;
  @override
  final int? id;
  @override
  final int? userId;
  @override
  final DateTime updatedAt;
  @override
  final WalletStatsEntity? stats;
  @override
  final MediaEntity? icon;

  @override
  String toString() {
    return 'WalletEntity(clientId: $clientId, type: $type, name: $name, description: $description, balance: $balance, currencyCode: $currencyCode, createdAt: $createdAt, id: $id, userId: $userId, updatedAt: $updatedAt, stats: $stats, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletEntityImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      clientId,
      type,
      name,
      description,
      balance,
      currencyCode,
      createdAt,
      id,
      userId,
      updatedAt,
      stats,
      icon);

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletEntityImplCopyWith<_$WalletEntityImpl> get copyWith =>
      __$$WalletEntityImplCopyWithImpl<_$WalletEntityImpl>(this, _$identity);
}

abstract class _WalletEntity extends WalletEntity {
  const factory _WalletEntity(
      {required final String clientId,
      required final WalletType type,
      required final String name,
      final String? description,
      required final double balance,
      required final String currencyCode,
      required final DateTime createdAt,
      final int? id,
      final int? userId,
      required final DateTime updatedAt,
      final WalletStatsEntity? stats,
      final MediaEntity? icon}) = _$WalletEntityImpl;
  const _WalletEntity._() : super._();

  @override
  String get clientId;
  @override
  WalletType get type;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get balance;
  @override
  String get currencyCode;
  @override
  DateTime get createdAt;
  @override
  int? get id;
  @override
  int? get userId;
  @override
  DateTime get updatedAt;
  @override
  WalletStatsEntity? get stats;
  @override
  MediaEntity? get icon;

  /// Create a copy of WalletEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletEntityImplCopyWith<_$WalletEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
