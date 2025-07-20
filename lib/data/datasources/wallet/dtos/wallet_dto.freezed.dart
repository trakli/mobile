// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletDto _$WalletDtoFromJson(Map<String, dynamic> json) {
  return _WalletDto.fromJson(json);
}

/// @nodoc
mixin _$WalletDto {
  @JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: WalletType.bank)
  WalletType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance')
  double get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_state')
  SyncStateDto get syncState => throw _privateConstructorUsedError;
  String? get rev => throw _privateConstructorUsedError;
  @JsonKey(name: 'stats')
  WalletStats? get stats => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  Media? get icon => throw _privateConstructorUsedError;

  /// Serializes this WalletDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletDtoCopyWith<WalletDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletDtoCopyWith<$Res> {
  factory $WalletDtoCopyWith(WalletDto value, $Res Function(WalletDto) then) =
      _$WalletDtoCopyWithImpl<$Res, WalletDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
      String clientId,
      @JsonKey(defaultValue: WalletType.bank) WalletType type,
      String name,
      String? description,
      @JsonKey(name: 'balance') double balance,
      String currency,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      int? id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto syncState,
      String? rev,
      @JsonKey(name: 'stats') WalletStats? stats,
      @JsonKey(name: 'icon') Media? icon});

  $SyncStateDtoCopyWith<$Res> get syncState;
}

/// @nodoc
class _$WalletDtoCopyWithImpl<$Res, $Val extends WalletDto>
    implements $WalletDtoCopyWith<$Res> {
  _$WalletDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? balance = null,
    Object? currency = null,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? syncState = null,
    Object? rev = freezed,
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
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
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
      rev: freezed == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WalletStats?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Media?,
    ) as $Val);
  }

  /// Create a copy of WalletDto
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
abstract class _$$WalletDtoImplCopyWith<$Res>
    implements $WalletDtoCopyWith<$Res> {
  factory _$$WalletDtoImplCopyWith(
          _$WalletDtoImpl value, $Res Function(_$WalletDtoImpl) then) =
      __$$WalletDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
      String clientId,
      @JsonKey(defaultValue: WalletType.bank) WalletType type,
      String name,
      String? description,
      @JsonKey(name: 'balance') double balance,
      String currency,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse) DateTime createdAt,
      int? id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse) DateTime updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'sync_state') SyncStateDto syncState,
      String? rev,
      @JsonKey(name: 'stats') WalletStats? stats,
      @JsonKey(name: 'icon') Media? icon});

  @override
  $SyncStateDtoCopyWith<$Res> get syncState;
}

/// @nodoc
class __$$WalletDtoImplCopyWithImpl<$Res>
    extends _$WalletDtoCopyWithImpl<$Res, _$WalletDtoImpl>
    implements _$$WalletDtoImplCopyWith<$Res> {
  __$$WalletDtoImplCopyWithImpl(
      _$WalletDtoImpl _value, $Res Function(_$WalletDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? type = null,
    Object? name = null,
    Object? description = freezed,
    Object? balance = null,
    Object? currency = null,
    Object? createdAt = null,
    Object? id = freezed,
    Object? userId = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? syncState = null,
    Object? rev = freezed,
    Object? stats = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$WalletDtoImpl(
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
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
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
      rev: freezed == rev
          ? _value.rev
          : rev // ignore: cast_nullable_to_non_nullable
              as String?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as WalletStats?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Media?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletDtoImpl extends _WalletDto {
  const _$WalletDtoImpl(
      {@JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
      required this.clientId,
      @JsonKey(defaultValue: WalletType.bank) required this.type,
      required this.name,
      this.description,
      @JsonKey(name: 'balance') required this.balance,
      required this.currency,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse)
      required this.createdAt,
      this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
      required this.updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      this.lastSyncedAt,
      @JsonKey(name: 'sync_state') required this.syncState,
      this.rev,
      @JsonKey(name: 'stats') this.stats,
      @JsonKey(name: 'icon') this.icon})
      : super._();

  factory _$WalletDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletDtoImplFromJson(json);

  @override
  @JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
  final String clientId;
  @override
  @JsonKey(defaultValue: WalletType.bank)
  final WalletType type;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'balance')
  final double balance;
  @override
  final String currency;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  final DateTime createdAt;
  @override
  final int? id;
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
  final String? rev;
  @override
  @JsonKey(name: 'stats')
  final WalletStats? stats;
  @override
  @JsonKey(name: 'icon')
  final Media? icon;

  @override
  String toString() {
    return 'WalletDto(clientId: $clientId, type: $type, name: $name, description: $description, balance: $balance, currency: $currency, createdAt: $createdAt, id: $id, userId: $userId, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, syncState: $syncState, rev: $rev, stats: $stats, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletDtoImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.syncState, syncState) ||
                other.syncState == syncState) &&
            (identical(other.rev, rev) || other.rev == rev) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      clientId,
      type,
      name,
      description,
      balance,
      currency,
      createdAt,
      id,
      userId,
      updatedAt,
      lastSyncedAt,
      syncState,
      rev,
      stats,
      icon);

  /// Create a copy of WalletDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletDtoImplCopyWith<_$WalletDtoImpl> get copyWith =>
      __$$WalletDtoImplCopyWithImpl<_$WalletDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletDtoImplToJson(
      this,
    );
  }
}

abstract class _WalletDto extends WalletDto {
  const factory _WalletDto(
      {@JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
      required final String clientId,
      @JsonKey(defaultValue: WalletType.bank) required final WalletType type,
      required final String name,
      final String? description,
      @JsonKey(name: 'balance') required final double balance,
      required final String currency,
      @JsonKey(name: 'created_at', fromJson: DateTime.parse)
      required final DateTime createdAt,
      final int? id,
      @JsonKey(name: 'user_id') required final int userId,
      @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
      required final DateTime updatedAt,
      @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
      final DateTime? lastSyncedAt,
      @JsonKey(name: 'sync_state') required final SyncStateDto syncState,
      final String? rev,
      @JsonKey(name: 'stats') final WalletStats? stats,
      @JsonKey(name: 'icon') final Media? icon}) = _$WalletDtoImpl;
  const _WalletDto._() : super._();

  factory _WalletDto.fromJson(Map<String, dynamic> json) =
      _$WalletDtoImpl.fromJson;

  @override
  @JsonKey(name: 'client_generated_id', defaultValue: clientConstant)
  String get clientId;
  @override
  @JsonKey(defaultValue: WalletType.bank)
  WalletType get type;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'balance')
  double get balance;
  @override
  String get currency;
  @override
  @JsonKey(name: 'created_at', fromJson: DateTime.parse)
  DateTime get createdAt;
  @override
  int? get id;
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
  @override
  String? get rev;
  @override
  @JsonKey(name: 'stats')
  WalletStats? get stats;
  @override
  @JsonKey(name: 'icon')
  Media? get icon;

  /// Create a copy of WalletDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletDtoImplCopyWith<_$WalletDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
