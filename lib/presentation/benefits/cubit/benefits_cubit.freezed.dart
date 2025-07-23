// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benefits_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BenefitsState {
  CloudBenefitEntity? get cloudBenefits => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of BenefitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BenefitsStateCopyWith<BenefitsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BenefitsStateCopyWith<$Res> {
  factory $BenefitsStateCopyWith(
          BenefitsState value, $Res Function(BenefitsState) then) =
      _$BenefitsStateCopyWithImpl<$Res, BenefitsState>;
  @useResult
  $Res call(
      {CloudBenefitEntity? cloudBenefits, bool isLoading, Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$BenefitsStateCopyWithImpl<$Res, $Val extends BenefitsState>
    implements $BenefitsStateCopyWith<$Res> {
  _$BenefitsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BenefitsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cloudBenefits = freezed,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      cloudBenefits: freezed == cloudBenefits
          ? _value.cloudBenefits
          : cloudBenefits // ignore: cast_nullable_to_non_nullable
              as CloudBenefitEntity?,
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

  /// Create a copy of BenefitsState
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
abstract class _$$BenefitsStateImplCopyWith<$Res>
    implements $BenefitsStateCopyWith<$Res> {
  factory _$$BenefitsStateImplCopyWith(
          _$BenefitsStateImpl value, $Res Function(_$BenefitsStateImpl) then) =
      __$$BenefitsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CloudBenefitEntity? cloudBenefits, bool isLoading, Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$BenefitsStateImplCopyWithImpl<$Res>
    extends _$BenefitsStateCopyWithImpl<$Res, _$BenefitsStateImpl>
    implements _$$BenefitsStateImplCopyWith<$Res> {
  __$$BenefitsStateImplCopyWithImpl(
      _$BenefitsStateImpl _value, $Res Function(_$BenefitsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cloudBenefits = freezed,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_$BenefitsStateImpl(
      cloudBenefits: freezed == cloudBenefits
          ? _value.cloudBenefits
          : cloudBenefits // ignore: cast_nullable_to_non_nullable
              as CloudBenefitEntity?,
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

class _$BenefitsStateImpl implements _BenefitsState {
  const _$BenefitsStateImpl(
      {required this.cloudBenefits,
      required this.isLoading,
      required this.failure});

  @override
  final CloudBenefitEntity? cloudBenefits;
  @override
  final bool isLoading;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'BenefitsState(cloudBenefits: $cloudBenefits, isLoading: $isLoading, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenefitsStateImpl &&
            (identical(other.cloudBenefits, cloudBenefits) ||
                other.cloudBenefits == cloudBenefits) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, cloudBenefits, isLoading, failure);

  /// Create a copy of BenefitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BenefitsStateImplCopyWith<_$BenefitsStateImpl> get copyWith =>
      __$$BenefitsStateImplCopyWithImpl<_$BenefitsStateImpl>(this, _$identity);
}

abstract class _BenefitsState implements BenefitsState {
  const factory _BenefitsState(
      {required final CloudBenefitEntity? cloudBenefits,
      required final bool isLoading,
      required final Failure failure}) = _$BenefitsStateImpl;

  @override
  CloudBenefitEntity? get cloudBenefits;
  @override
  bool get isLoading;
  @override
  Failure get failure;

  /// Create a copy of BenefitsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BenefitsStateImplCopyWith<_$BenefitsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
