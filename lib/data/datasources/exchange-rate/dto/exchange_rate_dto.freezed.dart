// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExchangeRateDto _$ExchangeRateDtoFromJson(Map<String, dynamic> json) {
  return _ExchangeRateDto.fromJson(json);
}

/// @nodoc
mixin _$ExchangeRateDto {
  @JsonKey(name: 'provider')
  String get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_code')
  String get baseCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'rates')
  Map<String, double> get rates => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'time_last_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  DateTime get timeLastUpdated => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'time_next_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  DateTime get timeNextUpdated => throw _privateConstructorUsedError;

  /// Serializes this ExchangeRateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeRateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeRateDtoCopyWith<ExchangeRateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateDtoCopyWith<$Res> {
  factory $ExchangeRateDtoCopyWith(
          ExchangeRateDto value, $Res Function(ExchangeRateDto) then) =
      _$ExchangeRateDtoCopyWithImpl<$Res, ExchangeRateDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'provider') String provider,
      @JsonKey(name: 'base_code') String baseCode,
      @JsonKey(name: 'rates') Map<String, double> rates,
      @JsonKey(
          name: 'time_last_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      DateTime timeLastUpdated,
      @JsonKey(
          name: 'time_next_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      DateTime timeNextUpdated});
}

/// @nodoc
class _$ExchangeRateDtoCopyWithImpl<$Res, $Val extends ExchangeRateDto>
    implements $ExchangeRateDtoCopyWith<$Res> {
  _$ExchangeRateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeRateDto
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
abstract class _$$ExchangeRateDtoImplCopyWith<$Res>
    implements $ExchangeRateDtoCopyWith<$Res> {
  factory _$$ExchangeRateDtoImplCopyWith(_$ExchangeRateDtoImpl value,
          $Res Function(_$ExchangeRateDtoImpl) then) =
      __$$ExchangeRateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'provider') String provider,
      @JsonKey(name: 'base_code') String baseCode,
      @JsonKey(name: 'rates') Map<String, double> rates,
      @JsonKey(
          name: 'time_last_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      DateTime timeLastUpdated,
      @JsonKey(
          name: 'time_next_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      DateTime timeNextUpdated});
}

/// @nodoc
class __$$ExchangeRateDtoImplCopyWithImpl<$Res>
    extends _$ExchangeRateDtoCopyWithImpl<$Res, _$ExchangeRateDtoImpl>
    implements _$$ExchangeRateDtoImplCopyWith<$Res> {
  __$$ExchangeRateDtoImplCopyWithImpl(
      _$ExchangeRateDtoImpl _value, $Res Function(_$ExchangeRateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExchangeRateDto
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
    return _then(_$ExchangeRateDtoImpl(
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
@JsonSerializable()
class _$ExchangeRateDtoImpl implements _ExchangeRateDto {
  const _$ExchangeRateDtoImpl(
      {@JsonKey(name: 'provider') required this.provider,
      @JsonKey(name: 'base_code') required this.baseCode,
      @JsonKey(name: 'rates') required final Map<String, double> rates,
      @JsonKey(
          name: 'time_last_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      required this.timeLastUpdated,
      @JsonKey(
          name: 'time_next_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      required this.timeNextUpdated})
      : _rates = rates;

  factory _$ExchangeRateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateDtoImplFromJson(json);

  @override
  @JsonKey(name: 'provider')
  final String provider;
  @override
  @JsonKey(name: 'base_code')
  final String baseCode;
  final Map<String, double> _rates;
  @override
  @JsonKey(name: 'rates')
  Map<String, double> get rates {
    if (_rates is EqualUnmodifiableMapView) return _rates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rates);
  }

  @override
  @JsonKey(
      name: 'time_last_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  final DateTime timeLastUpdated;
  @override
  @JsonKey(
      name: 'time_next_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  final DateTime timeNextUpdated;

  @override
  String toString() {
    return 'ExchangeRateDto(provider: $provider, baseCode: $baseCode, rates: $rates, timeLastUpdated: $timeLastUpdated, timeNextUpdated: $timeNextUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateDtoImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      provider,
      baseCode,
      const DeepCollectionEquality().hash(_rates),
      timeLastUpdated,
      timeNextUpdated);

  /// Create a copy of ExchangeRateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateDtoImplCopyWith<_$ExchangeRateDtoImpl> get copyWith =>
      __$$ExchangeRateDtoImplCopyWithImpl<_$ExchangeRateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeRateDtoImplToJson(
      this,
    );
  }
}

abstract class _ExchangeRateDto implements ExchangeRateDto {
  const factory _ExchangeRateDto(
      {@JsonKey(name: 'provider') required final String provider,
      @JsonKey(name: 'base_code') required final String baseCode,
      @JsonKey(name: 'rates') required final Map<String, double> rates,
      @JsonKey(
          name: 'time_last_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      required final DateTime timeLastUpdated,
      @JsonKey(
          name: 'time_next_update_unix',
          fromJson: dateTimeFromUnixSeconds,
          toJson: dateTimeToUnixSeconds)
      required final DateTime timeNextUpdated}) = _$ExchangeRateDtoImpl;

  factory _ExchangeRateDto.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateDtoImpl.fromJson;

  @override
  @JsonKey(name: 'provider')
  String get provider;
  @override
  @JsonKey(name: 'base_code')
  String get baseCode;
  @override
  @JsonKey(name: 'rates')
  Map<String, double> get rates;
  @override
  @JsonKey(
      name: 'time_last_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  DateTime get timeLastUpdated;
  @override
  @JsonKey(
      name: 'time_next_update_unix',
      fromJson: dateTimeFromUnixSeconds,
      toJson: dateTimeToUnixSeconds)
  DateTime get timeNextUpdated;

  /// Create a copy of ExchangeRateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeRateDtoImplCopyWith<_$ExchangeRateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
