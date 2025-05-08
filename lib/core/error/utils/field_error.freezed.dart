// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) {
  return _FieldError.fromJson(json);
}

/// @nodoc
mixin _$FieldError {
  String get field => throw _privateConstructorUsedError;
  List<String> get messages => throw _privateConstructorUsedError;

  /// Serializes this FieldError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldErrorCopyWith<FieldError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldErrorCopyWith<$Res> {
  factory $FieldErrorCopyWith(
          FieldError value, $Res Function(FieldError) then) =
      _$FieldErrorCopyWithImpl<$Res, FieldError>;
  @useResult
  $Res call({String field, List<String> messages});
}

/// @nodoc
class _$FieldErrorCopyWithImpl<$Res, $Val extends FieldError>
    implements $FieldErrorCopyWith<$Res> {
  _$FieldErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldErrorImplCopyWith<$Res>
    implements $FieldErrorCopyWith<$Res> {
  factory _$$FieldErrorImplCopyWith(
          _$FieldErrorImpl value, $Res Function(_$FieldErrorImpl) then) =
      __$$FieldErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, List<String> messages});
}

/// @nodoc
class __$$FieldErrorImplCopyWithImpl<$Res>
    extends _$FieldErrorCopyWithImpl<$Res, _$FieldErrorImpl>
    implements _$$FieldErrorImplCopyWith<$Res> {
  __$$FieldErrorImplCopyWithImpl(
      _$FieldErrorImpl _value, $Res Function(_$FieldErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? messages = null,
  }) {
    return _then(_$FieldErrorImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldErrorImpl extends _FieldError {
  const _$FieldErrorImpl(
      {required this.field, required final List<String> messages})
      : _messages = messages,
        super._();

  factory _$FieldErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldErrorImplFromJson(json);

  @override
  final String field;
  final List<String> _messages;
  @override
  List<String> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'FieldError(field: $field, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldErrorImpl &&
            (identical(other.field, field) || other.field == field) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, field, const DeepCollectionEquality().hash(_messages));

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldErrorImplCopyWith<_$FieldErrorImpl> get copyWith =>
      __$$FieldErrorImplCopyWithImpl<_$FieldErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldErrorImplToJson(
      this,
    );
  }
}

abstract class _FieldError extends FieldError {
  const factory _FieldError(
      {required final String field,
      required final List<String> messages}) = _$FieldErrorImpl;
  const _FieldError._() : super._();

  factory _FieldError.fromJson(Map<String, dynamic> json) =
      _$FieldErrorImpl.fromJson;

  @override
  String get field;
  @override
  List<String> get messages;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldErrorImplCopyWith<_$FieldErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
