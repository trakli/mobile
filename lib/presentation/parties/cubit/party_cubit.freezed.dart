// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PartyState {
  List<PartyEntity> get parties => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of PartyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyStateCopyWith<PartyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyStateCopyWith<$Res> {
  factory $PartyStateCopyWith(
          PartyState value, $Res Function(PartyState) then) =
      _$PartyStateCopyWithImpl<$Res, PartyState>;
  @useResult
  $Res call(
      {List<PartyEntity> parties,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$PartyStateCopyWithImpl<$Res, $Val extends PartyState>
    implements $PartyStateCopyWith<$Res> {
  _$PartyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parties = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      parties: null == parties
          ? _value.parties
          : parties // ignore: cast_nullable_to_non_nullable
              as List<PartyEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of PartyState
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
abstract class _$$PartyStateImplCopyWith<$Res>
    implements $PartyStateCopyWith<$Res> {
  factory _$$PartyStateImplCopyWith(
          _$PartyStateImpl value, $Res Function(_$PartyStateImpl) then) =
      __$$PartyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PartyEntity> parties,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$PartyStateImplCopyWithImpl<$Res>
    extends _$PartyStateCopyWithImpl<$Res, _$PartyStateImpl>
    implements _$$PartyStateImplCopyWith<$Res> {
  __$$PartyStateImplCopyWithImpl(
      _$PartyStateImpl _value, $Res Function(_$PartyStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parties = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
  }) {
    return _then(_$PartyStateImpl(
      parties: null == parties
          ? _value._parties
          : parties // ignore: cast_nullable_to_non_nullable
              as List<PartyEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$PartyStateImpl implements _PartyState {
  const _$PartyStateImpl(
      {required final List<PartyEntity> parties,
      required this.isLoading,
      required this.isSaving,
      required this.isDeleting,
      required this.failure})
      : _parties = parties;

  final List<PartyEntity> _parties;
  @override
  List<PartyEntity> get parties {
    if (_parties is EqualUnmodifiableListView) return _parties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parties);
  }

  @override
  final bool isLoading;
  @override
  final bool isSaving;
  @override
  final bool isDeleting;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'PartyState(parties: $parties, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyStateImpl &&
            const DeepCollectionEquality().equals(other._parties, _parties) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_parties),
      isLoading,
      isSaving,
      isDeleting,
      failure);

  /// Create a copy of PartyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyStateImplCopyWith<_$PartyStateImpl> get copyWith =>
      __$$PartyStateImplCopyWithImpl<_$PartyStateImpl>(this, _$identity);
}

abstract class _PartyState implements PartyState {
  const factory _PartyState(
      {required final List<PartyEntity> parties,
      required final bool isLoading,
      required final bool isSaving,
      required final bool isDeleting,
      required final Failure failure}) = _$PartyStateImpl;

  @override
  List<PartyEntity> get parties;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isDeleting;
  @override
  Failure get failure;

  /// Create a copy of PartyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyStateImplCopyWith<_$PartyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
