// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StreakState {
  List<StreakEntity> get streaks => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Why the last refresh failed. Not shown: the streak is a nicety, and the
  /// last good answer stays on screen.
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakStateCopyWith<StreakState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakStateCopyWith<$Res> {
  factory $StreakStateCopyWith(
          StreakState value, $Res Function(StreakState) then) =
      _$StreakStateCopyWithImpl<$Res, StreakState>;
  @useResult
  $Res call({List<StreakEntity> streaks, bool isLoading, Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$StreakStateCopyWithImpl<$Res, $Val extends StreakState>
    implements $StreakStateCopyWith<$Res> {
  _$StreakStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streaks = null,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      streaks: null == streaks
          ? _value.streaks
          : streaks // ignore: cast_nullable_to_non_nullable
              as List<StreakEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StreakStateImplCopyWith<$Res>
    implements $StreakStateCopyWith<$Res> {
  factory _$$StreakStateImplCopyWith(
          _$StreakStateImpl value, $Res Function(_$StreakStateImpl) then) =
      __$$StreakStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StreakEntity> streaks, bool isLoading, Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$StreakStateImplCopyWithImpl<$Res>
    extends _$StreakStateCopyWithImpl<$Res, _$StreakStateImpl>
    implements _$$StreakStateImplCopyWith<$Res> {
  __$$StreakStateImplCopyWithImpl(
      _$StreakStateImpl _value, $Res Function(_$StreakStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streaks = null,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_$StreakStateImpl(
      streaks: null == streaks
          ? _value._streaks
          : streaks // ignore: cast_nullable_to_non_nullable
              as List<StreakEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$StreakStateImpl extends _StreakState {
  const _$StreakStateImpl(
      {required final List<StreakEntity> streaks,
      required this.isLoading,
      required this.failure})
      : _streaks = streaks,
        super._();

  final List<StreakEntity> _streaks;
  @override
  List<StreakEntity> get streaks {
    if (_streaks is EqualUnmodifiableListView) return _streaks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_streaks);
  }

  @override
  final bool isLoading;

  /// Why the last refresh failed. Not shown: the streak is a nicety, and the
  /// last good answer stays on screen.
  @override
  final Failure failure;

  @override
  String toString() {
    return 'StreakState(streaks: $streaks, isLoading: $isLoading, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakStateImpl &&
            const DeepCollectionEquality().equals(other._streaks, _streaks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_streaks), isLoading, failure);

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakStateImplCopyWith<_$StreakStateImpl> get copyWith =>
      __$$StreakStateImplCopyWithImpl<_$StreakStateImpl>(this, _$identity);
}

abstract class _StreakState extends StreakState {
  const factory _StreakState(
      {required final List<StreakEntity> streaks,
      required final bool isLoading,
      required final Failure failure}) = _$StreakStateImpl;
  const _StreakState._() : super._();

  @override
  List<StreakEntity> get streaks;
  @override
  bool get isLoading;

  /// Why the last refresh failed. Not shown: the streak is a nicety, and the
  /// last good answer stays on screen.
  @override
  Failure get failure;

  /// Create a copy of StreakState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakStateImplCopyWith<_$StreakStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
