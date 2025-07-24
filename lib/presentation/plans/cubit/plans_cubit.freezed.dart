// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plans_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlansState {
  SubscriptionEntity? get subscription => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlansStateCopyWith<PlansState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlansStateCopyWith<$Res> {
  factory $PlansStateCopyWith(
          PlansState value, $Res Function(PlansState) then) =
      _$PlansStateCopyWithImpl<$Res, PlansState>;
  @useResult
  $Res call(
      {SubscriptionEntity? subscription, bool isLoading, Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$PlansStateCopyWithImpl<$Res, $Val extends PlansState>
    implements $PlansStateCopyWith<$Res> {
  _$PlansStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscription = freezed,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionEntity?,
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

  /// Create a copy of PlansState
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
abstract class _$$PlansStateImplCopyWith<$Res>
    implements $PlansStateCopyWith<$Res> {
  factory _$$PlansStateImplCopyWith(
          _$PlansStateImpl value, $Res Function(_$PlansStateImpl) then) =
      __$$PlansStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SubscriptionEntity? subscription, bool isLoading, Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$PlansStateImplCopyWithImpl<$Res>
    extends _$PlansStateCopyWithImpl<$Res, _$PlansStateImpl>
    implements _$$PlansStateImplCopyWith<$Res> {
  __$$PlansStateImplCopyWithImpl(
      _$PlansStateImpl _value, $Res Function(_$PlansStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscription = freezed,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_$PlansStateImpl(
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionEntity?,
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

class _$PlansStateImpl implements _PlansState {
  const _$PlansStateImpl(
      {required this.subscription,
      required this.isLoading,
      required this.failure});

  @override
  final SubscriptionEntity? subscription;
  @override
  final bool isLoading;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'PlansState(subscription: $subscription, isLoading: $isLoading, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlansStateImpl &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, subscription, isLoading, failure);

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlansStateImplCopyWith<_$PlansStateImpl> get copyWith =>
      __$$PlansStateImplCopyWithImpl<_$PlansStateImpl>(this, _$identity);
}

abstract class _PlansState implements PlansState {
  const factory _PlansState(
      {required final SubscriptionEntity? subscription,
      required final bool isLoading,
      required final Failure failure}) = _$PlansStateImpl;

  @override
  SubscriptionEntity? get subscription;
  @override
  bool get isLoading;
  @override
  Failure get failure;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlansStateImplCopyWith<_$PlansStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
