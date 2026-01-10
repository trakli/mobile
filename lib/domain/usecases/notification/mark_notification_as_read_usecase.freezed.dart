// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_notification_as_read_usecase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MarkNotificationAsReadParams {
  String get clientId => throw _privateConstructorUsedError;

  /// Create a copy of MarkNotificationAsReadParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarkNotificationAsReadParamsCopyWith<MarkNotificationAsReadParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkNotificationAsReadParamsCopyWith<$Res> {
  factory $MarkNotificationAsReadParamsCopyWith(
          MarkNotificationAsReadParams value,
          $Res Function(MarkNotificationAsReadParams) then) =
      _$MarkNotificationAsReadParamsCopyWithImpl<$Res,
          MarkNotificationAsReadParams>;
  @useResult
  $Res call({String clientId});
}

/// @nodoc
class _$MarkNotificationAsReadParamsCopyWithImpl<$Res,
        $Val extends MarkNotificationAsReadParams>
    implements $MarkNotificationAsReadParamsCopyWith<$Res> {
  _$MarkNotificationAsReadParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarkNotificationAsReadParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarkNotificationAsReadParamsImplCopyWith<$Res>
    implements $MarkNotificationAsReadParamsCopyWith<$Res> {
  factory _$$MarkNotificationAsReadParamsImplCopyWith(
          _$MarkNotificationAsReadParamsImpl value,
          $Res Function(_$MarkNotificationAsReadParamsImpl) then) =
      __$$MarkNotificationAsReadParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String clientId});
}

/// @nodoc
class __$$MarkNotificationAsReadParamsImplCopyWithImpl<$Res>
    extends _$MarkNotificationAsReadParamsCopyWithImpl<$Res,
        _$MarkNotificationAsReadParamsImpl>
    implements _$$MarkNotificationAsReadParamsImplCopyWith<$Res> {
  __$$MarkNotificationAsReadParamsImplCopyWithImpl(
      _$MarkNotificationAsReadParamsImpl _value,
      $Res Function(_$MarkNotificationAsReadParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MarkNotificationAsReadParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
  }) {
    return _then(_$MarkNotificationAsReadParamsImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MarkNotificationAsReadParamsImpl
    implements _MarkNotificationAsReadParams {
  const _$MarkNotificationAsReadParamsImpl({required this.clientId});

  @override
  final String clientId;

  @override
  String toString() {
    return 'MarkNotificationAsReadParams(clientId: $clientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkNotificationAsReadParamsImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, clientId);

  /// Create a copy of MarkNotificationAsReadParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkNotificationAsReadParamsImplCopyWith<
          _$MarkNotificationAsReadParamsImpl>
      get copyWith => __$$MarkNotificationAsReadParamsImplCopyWithImpl<
          _$MarkNotificationAsReadParamsImpl>(this, _$identity);
}

abstract class _MarkNotificationAsReadParams
    implements MarkNotificationAsReadParams {
  const factory _MarkNotificationAsReadParams(
      {required final String clientId}) = _$MarkNotificationAsReadParamsImpl;

  @override
  String get clientId;

  /// Create a copy of MarkNotificationAsReadParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkNotificationAsReadParamsImplCopyWith<
          _$MarkNotificationAsReadParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
