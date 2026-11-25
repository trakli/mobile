// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DictationState {
  DictationStatus get status => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  String get recognizedWords => throw _privateConstructorUsedError;
  DictationError get error => throw _privateConstructorUsedError;

  /// Create a copy of DictationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DictationStateCopyWith<DictationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DictationStateCopyWith<$Res> {
  factory $DictationStateCopyWith(
          DictationState value, $Res Function(DictationState) then) =
      _$DictationStateCopyWithImpl<$Res, DictationState>;
  @useResult
  $Res call(
      {DictationStatus status,
      bool isAvailable,
      String recognizedWords,
      DictationError error});
}

/// @nodoc
class _$DictationStateCopyWithImpl<$Res, $Val extends DictationState>
    implements $DictationStateCopyWith<$Res> {
  _$DictationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DictationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isAvailable = null,
    Object? recognizedWords = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DictationStatus,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      recognizedWords: null == recognizedWords
          ? _value.recognizedWords
          : recognizedWords // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as DictationError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DictationStateImplCopyWith<$Res>
    implements $DictationStateCopyWith<$Res> {
  factory _$$DictationStateImplCopyWith(_$DictationStateImpl value,
          $Res Function(_$DictationStateImpl) then) =
      __$$DictationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DictationStatus status,
      bool isAvailable,
      String recognizedWords,
      DictationError error});
}

/// @nodoc
class __$$DictationStateImplCopyWithImpl<$Res>
    extends _$DictationStateCopyWithImpl<$Res, _$DictationStateImpl>
    implements _$$DictationStateImplCopyWith<$Res> {
  __$$DictationStateImplCopyWithImpl(
      _$DictationStateImpl _value, $Res Function(_$DictationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DictationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isAvailable = null,
    Object? recognizedWords = null,
    Object? error = null,
  }) {
    return _then(_$DictationStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DictationStatus,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      recognizedWords: null == recognizedWords
          ? _value.recognizedWords
          : recognizedWords // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as DictationError,
    ));
  }
}

/// @nodoc

class _$DictationStateImpl extends _DictationState {
  const _$DictationStateImpl(
      {this.status = DictationStatus.idle,
      this.isAvailable = true,
      this.recognizedWords = '',
      this.error = DictationError.none})
      : super._();

  @override
  @JsonKey()
  final DictationStatus status;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final String recognizedWords;
  @override
  @JsonKey()
  final DictationError error;

  @override
  String toString() {
    return 'DictationState(status: $status, isAvailable: $isAvailable, recognizedWords: $recognizedWords, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DictationStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.recognizedWords, recognizedWords) ||
                other.recognizedWords == recognizedWords) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, isAvailable, recognizedWords, error);

  /// Create a copy of DictationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DictationStateImplCopyWith<_$DictationStateImpl> get copyWith =>
      __$$DictationStateImplCopyWithImpl<_$DictationStateImpl>(
          this, _$identity);
}

abstract class _DictationState extends DictationState {
  const factory _DictationState(
      {final DictationStatus status,
      final bool isAvailable,
      final String recognizedWords,
      final DictationError error}) = _$DictationStateImpl;
  const _DictationState._() : super._();

  @override
  DictationStatus get status;
  @override
  bool get isAvailable;
  @override
  String get recognizedWords;
  @override
  DictationError get error;

  /// Create a copy of DictationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DictationStateImplCopyWith<_$DictationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
