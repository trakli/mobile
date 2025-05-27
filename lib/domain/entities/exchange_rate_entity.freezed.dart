// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExchangeRateEntity {
  String get provider => throw _privateConstructorUsedError;
  String get baseCode => throw _privateConstructorUsedError;
  Map<String, double> get rates => throw _privateConstructorUsedError;
  DateTime get timeLastUpdated => throw _privateConstructorUsedError;
  DateTime get timeNextUpdated => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeRateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeRateEntityCopyWith<ExchangeRateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateEntityCopyWith<$Res> {
  factory $ExchangeRateEntityCopyWith(
          ExchangeRateEntity value, $Res Function(ExchangeRateEntity) then) =
      _$ExchangeRateEntityCopyWithImpl<$Res, ExchangeRateEntity>;
  @useResult
  $Res call(
      {String provider,
      String baseCode,
      Map<String, double> rates,
      DateTime timeLastUpdated,
      DateTime timeNextUpdated});
}

/// @nodoc
class _$ExchangeRateEntityCopyWithImpl<$Res, $Val extends ExchangeRateEntity>
    implements $ExchangeRateEntityCopyWith<$Res> {
  _$ExchangeRateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeRateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? baseCode = null,
    Object? rates = null,
    Object? timeLastUpdated = null,
    Object? timeNextUpdated = null,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      baseCode: null == baseCode
          ? _value.baseCode
          : baseCode // ignore: cast_nullable_to_non_nullable
              as String,
      rates: null == rates
          ? _value.rates
          : rates // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      timeLastUpdated: null == timeLastUpdated
          ? _value.timeLastUpdated
          : timeLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeNextUpdated: null == timeNextUpdated
          ? _value.timeNextUpdated
          : timeNextUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeRateEntityImplCopyWith<$Res>
    implements $ExchangeRateEntityCopyWith<$Res> {
  factory _$$ExchangeRateEntityImplCopyWith(_$ExchangeRateEntityImpl value,
          $Res Function(_$ExchangeRateEntityImpl) then) =
      __$$ExchangeRateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String provider,
      String baseCode,
      Map<String, double> rates,
      DateTime timeLastUpdated,
      DateTime timeNextUpdated});
}

/// @nodoc
class __$$ExchangeRateEntityImplCopyWithImpl<$Res>
    extends _$ExchangeRateEntityCopyWithImpl<$Res, _$ExchangeRateEntityImpl>
    implements _$$ExchangeRateEntityImplCopyWith<$Res> {
  __$$ExchangeRateEntityImplCopyWithImpl(_$ExchangeRateEntityImpl _value,
      $Res Function(_$ExchangeRateEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExchangeRateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? baseCode = null,
    Object? rates = null,
    Object? timeLastUpdated = null,
    Object? timeNextUpdated = null,
  }) {
    return _then(_$ExchangeRateEntityImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      baseCode: null == baseCode
          ? _value.baseCode
          : baseCode // ignore: cast_nullable_to_non_nullable
              as String,
      rates: null == rates
          ? _value._rates
          : rates // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      timeLastUpdated: null == timeLastUpdated
          ? _value.timeLastUpdated
          : timeLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeNextUpdated: null == timeNextUpdated
          ? _value.timeNextUpdated
          : timeNextUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ExchangeRateEntityImpl implements _ExchangeRateEntity {
  const _$ExchangeRateEntityImpl(
      {required this.provider,
      required this.baseCode,
      required final Map<String, double> rates,
      required this.timeLastUpdated,
      required this.timeNextUpdated})
      : _rates = rates;

  @override
  final String provider;
  @override
  final String baseCode;
  final Map<String, double> _rates;
  @override
  Map<String, double> get rates {
    if (_rates is EqualUnmodifiableMapView) return _rates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rates);
  }

  @override
  final DateTime timeLastUpdated;
  @override
  final DateTime timeNextUpdated;

  @override
  String toString() {
    return 'ExchangeRateEntity(provider: $provider, baseCode: $baseCode, rates: $rates, timeLastUpdated: $timeLastUpdated, timeNextUpdated: $timeNextUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateEntityImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.baseCode, baseCode) ||
                other.baseCode == baseCode) &&
            const DeepCollectionEquality().equals(other._rates, _rates) &&
            (identical(other.timeLastUpdated, timeLastUpdated) ||
                other.timeLastUpdated == timeLastUpdated) &&
            (identical(other.timeNextUpdated, timeNextUpdated) ||
                other.timeNextUpdated == timeNextUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      provider,
      baseCode,
      const DeepCollectionEquality().hash(_rates),
      timeLastUpdated,
      timeNextUpdated);

  /// Create a copy of ExchangeRateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateEntityImplCopyWith<_$ExchangeRateEntityImpl> get copyWith =>
      __$$ExchangeRateEntityImplCopyWithImpl<_$ExchangeRateEntityImpl>(
          this, _$identity);
}

abstract class _ExchangeRateEntity implements ExchangeRateEntity {
  const factory _ExchangeRateEntity(
      {required final String provider,
      required final String baseCode,
      required final Map<String, double> rates,
      required final DateTime timeLastUpdated,
      required final DateTime timeNextUpdated}) = _$ExchangeRateEntityImpl;

  @override
  String get provider;
  @override
  String get baseCode;
  @override
  Map<String, double> get rates;
  @override
  DateTime get timeLastUpdated;
  @override
  DateTime get timeNextUpdated;

  /// Create a copy of ExchangeRateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeRateEntityImplCopyWith<_$ExchangeRateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
