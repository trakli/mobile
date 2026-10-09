// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedbackEntity {
  int get id => throw _privateConstructorUsedError;
  FeedbackType get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackEntityCopyWith<FeedbackEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackEntityCopyWith<$Res> {
  factory $FeedbackEntityCopyWith(
          FeedbackEntity value, $Res Function(FeedbackEntity) then) =
      _$FeedbackEntityCopyWithImpl<$Res, FeedbackEntity>;
  @useResult
  $Res call(
      {int id,
      FeedbackType type,
      String status,
      String? subject,
      String message,
      DateTime? createdAt});
}

/// @nodoc
class _$FeedbackEntityCopyWithImpl<$Res, $Val extends FeedbackEntity>
    implements $FeedbackEntityCopyWith<$Res> {
  _$FeedbackEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? subject = freezed,
    Object? message = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackEntityImplCopyWith<$Res>
    implements $FeedbackEntityCopyWith<$Res> {
  factory _$$FeedbackEntityImplCopyWith(_$FeedbackEntityImpl value,
          $Res Function(_$FeedbackEntityImpl) then) =
      __$$FeedbackEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      FeedbackType type,
      String status,
      String? subject,
      String message,
      DateTime? createdAt});
}

/// @nodoc
class __$$FeedbackEntityImplCopyWithImpl<$Res>
    extends _$FeedbackEntityCopyWithImpl<$Res, _$FeedbackEntityImpl>
    implements _$$FeedbackEntityImplCopyWith<$Res> {
  __$$FeedbackEntityImplCopyWithImpl(
      _$FeedbackEntityImpl _value, $Res Function(_$FeedbackEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? subject = freezed,
    Object? message = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$FeedbackEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$FeedbackEntityImpl implements _FeedbackEntity {
  const _$FeedbackEntityImpl(
      {required this.id,
      required this.type,
      required this.status,
      this.subject,
      required this.message,
      this.createdAt});

  @override
  final int id;
  @override
  final FeedbackType type;
  @override
  final String status;
  @override
  final String? subject;
  @override
  final String message;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FeedbackEntity(id: $id, type: $type, status: $status, subject: $subject, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, status, subject, message, createdAt);

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackEntityImplCopyWith<_$FeedbackEntityImpl> get copyWith =>
      __$$FeedbackEntityImplCopyWithImpl<_$FeedbackEntityImpl>(
          this, _$identity);
}

abstract class _FeedbackEntity implements FeedbackEntity {
  const factory _FeedbackEntity(
      {required final int id,
      required final FeedbackType type,
      required final String status,
      final String? subject,
      required final String message,
      final DateTime? createdAt}) = _$FeedbackEntityImpl;

  @override
  int get id;
  @override
  FeedbackType get type;
  @override
  String get status;
  @override
  String? get subject;
  @override
  String get message;
  @override
  DateTime? get createdAt;

  /// Create a copy of FeedbackEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackEntityImplCopyWith<_$FeedbackEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
