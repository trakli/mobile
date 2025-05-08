// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncStateDto _$SyncStateDtoFromJson(Map<String, dynamic> json) {
  return _SyncStateDto.fromJson(json);
}

/// @nodoc
mixin _$SyncStateDto {
  String get state => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this SyncStateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStateDtoCopyWith<SyncStateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateDtoCopyWith<$Res> {
  factory $SyncStateDtoCopyWith(
          SyncStateDto value, $Res Function(SyncStateDto) then) =
      _$SyncStateDtoCopyWithImpl<$Res, SyncStateDto>;
  @useResult
  $Res call({String state, String? error});
}

/// @nodoc
class _$SyncStateDtoCopyWithImpl<$Res, $Val extends SyncStateDto>
    implements $SyncStateDtoCopyWith<$Res> {
  _$SyncStateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStateDtoImplCopyWith<$Res>
    implements $SyncStateDtoCopyWith<$Res> {
  factory _$$SyncStateDtoImplCopyWith(
          _$SyncStateDtoImpl value, $Res Function(_$SyncStateDtoImpl) then) =
      __$$SyncStateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String state, String? error});
}

/// @nodoc
class __$$SyncStateDtoImplCopyWithImpl<$Res>
    extends _$SyncStateDtoCopyWithImpl<$Res, _$SyncStateDtoImpl>
    implements _$$SyncStateDtoImplCopyWith<$Res> {
  __$$SyncStateDtoImplCopyWithImpl(
      _$SyncStateDtoImpl _value, $Res Function(_$SyncStateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? error = freezed,
  }) {
    return _then(_$SyncStateDtoImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncStateDtoImpl implements _SyncStateDto {
  const _$SyncStateDtoImpl({required this.state, this.error});

  factory _$SyncStateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStateDtoImplFromJson(json);

  @override
  final String state;
  @override
  final String? error;

  @override
  String toString() {
    return 'SyncStateDto(state: $state, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateDtoImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state, error);

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateDtoImplCopyWith<_$SyncStateDtoImpl> get copyWith =>
      __$$SyncStateDtoImplCopyWithImpl<_$SyncStateDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStateDtoImplToJson(
      this,
    );
  }
}

abstract class _SyncStateDto implements SyncStateDto {
  const factory _SyncStateDto(
      {required final String state, final String? error}) = _$SyncStateDtoImpl;

  factory _SyncStateDto.fromJson(Map<String, dynamic> json) =
      _$SyncStateDtoImpl.fromJson;

  @override
  String get state;
  @override
  String? get error;

  /// Create a copy of SyncStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateDtoImplCopyWith<_$SyncStateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
