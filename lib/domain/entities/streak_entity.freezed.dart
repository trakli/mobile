// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StreakEntity {
  StreakType get type => throw _privateConstructorUsedError;
  StreakPeriod get period => throw _privateConstructorUsedError;
  int get currentLength => throw _privateConstructorUsedError;
  int get longestLength => throw _privateConstructorUsedError;

  /// Long enough to celebrate (the server's threshold, three by default).
  bool get isRunning => throw _privateConstructorUsedError;
  DateTime? get startedOn => throw _privateConstructorUsedError;
  DateTime? get lastTrackedOn => throw _privateConstructorUsedError;

  /// Create a copy of StreakEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakEntityCopyWith<StreakEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakEntityCopyWith<$Res> {
  factory $StreakEntityCopyWith(
          StreakEntity value, $Res Function(StreakEntity) then) =
      _$StreakEntityCopyWithImpl<$Res, StreakEntity>;
  @useResult
  $Res call(
      {StreakType type,
      StreakPeriod period,
      int currentLength,
      int longestLength,
      bool isRunning,
      DateTime? startedOn,
      DateTime? lastTrackedOn});
}

/// @nodoc
class _$StreakEntityCopyWithImpl<$Res, $Val extends StreakEntity>
    implements $StreakEntityCopyWith<$Res> {
  _$StreakEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreakEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? period = null,
    Object? currentLength = null,
    Object? longestLength = null,
    Object? isRunning = null,
    Object? startedOn = freezed,
    Object? lastTrackedOn = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakType,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as StreakPeriod,
      currentLength: null == currentLength
          ? _value.currentLength
          : currentLength // ignore: cast_nullable_to_non_nullable
              as int,
      longestLength: null == longestLength
          ? _value.longestLength
          : longestLength // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      startedOn: freezed == startedOn
          ? _value.startedOn
          : startedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTrackedOn: freezed == lastTrackedOn
          ? _value.lastTrackedOn
          : lastTrackedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakEntityImplCopyWith<$Res>
    implements $StreakEntityCopyWith<$Res> {
  factory _$$StreakEntityImplCopyWith(
          _$StreakEntityImpl value, $Res Function(_$StreakEntityImpl) then) =
      __$$StreakEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StreakType type,
      StreakPeriod period,
      int currentLength,
      int longestLength,
      bool isRunning,
      DateTime? startedOn,
      DateTime? lastTrackedOn});
}

/// @nodoc
class __$$StreakEntityImplCopyWithImpl<$Res>
    extends _$StreakEntityCopyWithImpl<$Res, _$StreakEntityImpl>
    implements _$$StreakEntityImplCopyWith<$Res> {
  __$$StreakEntityImplCopyWithImpl(
      _$StreakEntityImpl _value, $Res Function(_$StreakEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of StreakEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? period = null,
    Object? currentLength = null,
    Object? longestLength = null,
    Object? isRunning = null,
    Object? startedOn = freezed,
    Object? lastTrackedOn = freezed,
  }) {
    return _then(_$StreakEntityImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakType,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as StreakPeriod,
      currentLength: null == currentLength
          ? _value.currentLength
          : currentLength // ignore: cast_nullable_to_non_nullable
              as int,
      longestLength: null == longestLength
          ? _value.longestLength
          : longestLength // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      startedOn: freezed == startedOn
          ? _value.startedOn
          : startedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTrackedOn: freezed == lastTrackedOn
          ? _value.lastTrackedOn
          : lastTrackedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$StreakEntityImpl implements _StreakEntity {
  const _$StreakEntityImpl(
      {required this.type,
      required this.period,
      required this.currentLength,
      required this.longestLength,
      required this.isRunning,
      this.startedOn,
      this.lastTrackedOn});

  @override
  final StreakType type;
  @override
  final StreakPeriod period;
  @override
  final int currentLength;
  @override
  final int longestLength;

  /// Long enough to celebrate (the server's threshold, three by default).
  @override
  final bool isRunning;
  @override
  final DateTime? startedOn;
  @override
  final DateTime? lastTrackedOn;

  @override
  String toString() {
    return 'StreakEntity(type: $type, period: $period, currentLength: $currentLength, longestLength: $longestLength, isRunning: $isRunning, startedOn: $startedOn, lastTrackedOn: $lastTrackedOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakEntityImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.currentLength, currentLength) ||
                other.currentLength == currentLength) &&
            (identical(other.longestLength, longestLength) ||
                other.longestLength == longestLength) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.startedOn, startedOn) ||
                other.startedOn == startedOn) &&
            (identical(other.lastTrackedOn, lastTrackedOn) ||
                other.lastTrackedOn == lastTrackedOn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, period, currentLength,
      longestLength, isRunning, startedOn, lastTrackedOn);

  /// Create a copy of StreakEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakEntityImplCopyWith<_$StreakEntityImpl> get copyWith =>
      __$$StreakEntityImplCopyWithImpl<_$StreakEntityImpl>(this, _$identity);
}

abstract class _StreakEntity implements StreakEntity {
  const factory _StreakEntity(
      {required final StreakType type,
      required final StreakPeriod period,
      required final int currentLength,
      required final int longestLength,
      required final bool isRunning,
      final DateTime? startedOn,
      final DateTime? lastTrackedOn}) = _$StreakEntityImpl;

  @override
  StreakType get type;
  @override
  StreakPeriod get period;
  @override
  int get currentLength;
  @override
  int get longestLength;

  /// Long enough to celebrate (the server's threshold, three by default).
  @override
  bool get isRunning;
  @override
  DateTime? get startedOn;
  @override
  DateTime? get lastTrackedOn;

  /// Create a copy of StreakEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakEntityImplCopyWith<_$StreakEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
