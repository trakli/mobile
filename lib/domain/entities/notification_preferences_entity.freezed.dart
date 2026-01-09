// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationPreferencesEntity {
  NotificationChannelsEntity get channels => throw _privateConstructorUsedError;
  NotificationTypesEntity get types => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesEntityCopyWith<NotificationPreferencesEntity>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesEntityCopyWith<$Res> {
  factory $NotificationPreferencesEntityCopyWith(
          NotificationPreferencesEntity value,
          $Res Function(NotificationPreferencesEntity) then) =
      _$NotificationPreferencesEntityCopyWithImpl<$Res,
          NotificationPreferencesEntity>;
  @useResult
  $Res call(
      {NotificationChannelsEntity channels, NotificationTypesEntity types});

  $NotificationChannelsEntityCopyWith<$Res> get channels;
  $NotificationTypesEntityCopyWith<$Res> get types;
}

/// @nodoc
class _$NotificationPreferencesEntityCopyWithImpl<$Res,
        $Val extends NotificationPreferencesEntity>
    implements $NotificationPreferencesEntityCopyWith<$Res> {
  _$NotificationPreferencesEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? types = null,
  }) {
    return _then(_value.copyWith(
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as NotificationChannelsEntity,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as NotificationTypesEntity,
    ) as $Val);
  }

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationChannelsEntityCopyWith<$Res> get channels {
    return $NotificationChannelsEntityCopyWith<$Res>(_value.channels, (value) {
      return _then(_value.copyWith(channels: value) as $Val);
    });
  }

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationTypesEntityCopyWith<$Res> get types {
    return $NotificationTypesEntityCopyWith<$Res>(_value.types, (value) {
      return _then(_value.copyWith(types: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesEntityImplCopyWith<$Res>
    implements $NotificationPreferencesEntityCopyWith<$Res> {
  factory _$$NotificationPreferencesEntityImplCopyWith(
          _$NotificationPreferencesEntityImpl value,
          $Res Function(_$NotificationPreferencesEntityImpl) then) =
      __$$NotificationPreferencesEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NotificationChannelsEntity channels, NotificationTypesEntity types});

  @override
  $NotificationChannelsEntityCopyWith<$Res> get channels;
  @override
  $NotificationTypesEntityCopyWith<$Res> get types;
}

/// @nodoc
class __$$NotificationPreferencesEntityImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesEntityCopyWithImpl<$Res,
        _$NotificationPreferencesEntityImpl>
    implements _$$NotificationPreferencesEntityImplCopyWith<$Res> {
  __$$NotificationPreferencesEntityImplCopyWithImpl(
      _$NotificationPreferencesEntityImpl _value,
      $Res Function(_$NotificationPreferencesEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? types = null,
  }) {
    return _then(_$NotificationPreferencesEntityImpl(
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as NotificationChannelsEntity,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as NotificationTypesEntity,
    ));
  }
}

/// @nodoc

class _$NotificationPreferencesEntityImpl
    implements _NotificationPreferencesEntity {
  const _$NotificationPreferencesEntityImpl(
      {required this.channels, required this.types});

  @override
  final NotificationChannelsEntity channels;
  @override
  final NotificationTypesEntity types;

  @override
  String toString() {
    return 'NotificationPreferencesEntity(channels: $channels, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesEntityImpl &&
            (identical(other.channels, channels) ||
                other.channels == channels) &&
            (identical(other.types, types) || other.types == types));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channels, types);

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesEntityImplCopyWith<
          _$NotificationPreferencesEntityImpl>
      get copyWith => __$$NotificationPreferencesEntityImplCopyWithImpl<
          _$NotificationPreferencesEntityImpl>(this, _$identity);
}

abstract class _NotificationPreferencesEntity
    implements NotificationPreferencesEntity {
  const factory _NotificationPreferencesEntity(
          {required final NotificationChannelsEntity channels,
          required final NotificationTypesEntity types}) =
      _$NotificationPreferencesEntityImpl;

  @override
  NotificationChannelsEntity get channels;
  @override
  NotificationTypesEntity get types;

  /// Create a copy of NotificationPreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesEntityImplCopyWith<
          _$NotificationPreferencesEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationChannelsEntity {
  bool get email => throw _privateConstructorUsedError;
  bool get push => throw _privateConstructorUsedError;
  bool get inapp => throw _privateConstructorUsedError;

  /// Create a copy of NotificationChannelsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationChannelsEntityCopyWith<NotificationChannelsEntity>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationChannelsEntityCopyWith<$Res> {
  factory $NotificationChannelsEntityCopyWith(NotificationChannelsEntity value,
          $Res Function(NotificationChannelsEntity) then) =
      _$NotificationChannelsEntityCopyWithImpl<$Res,
          NotificationChannelsEntity>;
  @useResult
  $Res call({bool email, bool push, bool inapp});
}

/// @nodoc
class _$NotificationChannelsEntityCopyWithImpl<$Res,
        $Val extends NotificationChannelsEntity>
    implements $NotificationChannelsEntityCopyWith<$Res> {
  _$NotificationChannelsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationChannelsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? push = null,
    Object? inapp = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      inapp: null == inapp
          ? _value.inapp
          : inapp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationChannelsEntityImplCopyWith<$Res>
    implements $NotificationChannelsEntityCopyWith<$Res> {
  factory _$$NotificationChannelsEntityImplCopyWith(
          _$NotificationChannelsEntityImpl value,
          $Res Function(_$NotificationChannelsEntityImpl) then) =
      __$$NotificationChannelsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool email, bool push, bool inapp});
}

/// @nodoc
class __$$NotificationChannelsEntityImplCopyWithImpl<$Res>
    extends _$NotificationChannelsEntityCopyWithImpl<$Res,
        _$NotificationChannelsEntityImpl>
    implements _$$NotificationChannelsEntityImplCopyWith<$Res> {
  __$$NotificationChannelsEntityImplCopyWithImpl(
      _$NotificationChannelsEntityImpl _value,
      $Res Function(_$NotificationChannelsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationChannelsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? push = null,
    Object? inapp = null,
  }) {
    return _then(_$NotificationChannelsEntityImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as bool,
      push: null == push
          ? _value.push
          : push // ignore: cast_nullable_to_non_nullable
              as bool,
      inapp: null == inapp
          ? _value.inapp
          : inapp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationChannelsEntityImpl implements _NotificationChannelsEntity {
  const _$NotificationChannelsEntityImpl(
      {this.email = true, this.push = true, this.inapp = true});

  @override
  @JsonKey()
  final bool email;
  @override
  @JsonKey()
  final bool push;
  @override
  @JsonKey()
  final bool inapp;

  @override
  String toString() {
    return 'NotificationChannelsEntity(email: $email, push: $push, inapp: $inapp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationChannelsEntityImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.push, push) || other.push == push) &&
            (identical(other.inapp, inapp) || other.inapp == inapp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, push, inapp);

  /// Create a copy of NotificationChannelsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationChannelsEntityImplCopyWith<_$NotificationChannelsEntityImpl>
      get copyWith => __$$NotificationChannelsEntityImplCopyWithImpl<
          _$NotificationChannelsEntityImpl>(this, _$identity);
}

abstract class _NotificationChannelsEntity
    implements NotificationChannelsEntity {
  const factory _NotificationChannelsEntity(
      {final bool email,
      final bool push,
      final bool inapp}) = _$NotificationChannelsEntityImpl;

  @override
  bool get email;
  @override
  bool get push;
  @override
  bool get inapp;

  /// Create a copy of NotificationChannelsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationChannelsEntityImplCopyWith<_$NotificationChannelsEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationTypesEntity {
  bool get reminders => throw _privateConstructorUsedError;
  bool get insights => throw _privateConstructorUsedError;
  bool get inactivity => throw _privateConstructorUsedError;

  /// Create a copy of NotificationTypesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationTypesEntityCopyWith<NotificationTypesEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTypesEntityCopyWith<$Res> {
  factory $NotificationTypesEntityCopyWith(NotificationTypesEntity value,
          $Res Function(NotificationTypesEntity) then) =
      _$NotificationTypesEntityCopyWithImpl<$Res, NotificationTypesEntity>;
  @useResult
  $Res call({bool reminders, bool insights, bool inactivity});
}

/// @nodoc
class _$NotificationTypesEntityCopyWithImpl<$Res,
        $Val extends NotificationTypesEntity>
    implements $NotificationTypesEntityCopyWith<$Res> {
  _$NotificationTypesEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationTypesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reminders = null,
    Object? insights = null,
    Object? inactivity = null,
  }) {
    return _then(_value.copyWith(
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as bool,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as bool,
      inactivity: null == inactivity
          ? _value.inactivity
          : inactivity // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationTypesEntityImplCopyWith<$Res>
    implements $NotificationTypesEntityCopyWith<$Res> {
  factory _$$NotificationTypesEntityImplCopyWith(
          _$NotificationTypesEntityImpl value,
          $Res Function(_$NotificationTypesEntityImpl) then) =
      __$$NotificationTypesEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool reminders, bool insights, bool inactivity});
}

/// @nodoc
class __$$NotificationTypesEntityImplCopyWithImpl<$Res>
    extends _$NotificationTypesEntityCopyWithImpl<$Res,
        _$NotificationTypesEntityImpl>
    implements _$$NotificationTypesEntityImplCopyWith<$Res> {
  __$$NotificationTypesEntityImplCopyWithImpl(
      _$NotificationTypesEntityImpl _value,
      $Res Function(_$NotificationTypesEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationTypesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reminders = null,
    Object? insights = null,
    Object? inactivity = null,
  }) {
    return _then(_$NotificationTypesEntityImpl(
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as bool,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as bool,
      inactivity: null == inactivity
          ? _value.inactivity
          : inactivity // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationTypesEntityImpl implements _NotificationTypesEntity {
  const _$NotificationTypesEntityImpl(
      {this.reminders = true, this.insights = true, this.inactivity = true});

  @override
  @JsonKey()
  final bool reminders;
  @override
  @JsonKey()
  final bool insights;
  @override
  @JsonKey()
  final bool inactivity;

  @override
  String toString() {
    return 'NotificationTypesEntity(reminders: $reminders, insights: $insights, inactivity: $inactivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationTypesEntityImpl &&
            (identical(other.reminders, reminders) ||
                other.reminders == reminders) &&
            (identical(other.insights, insights) ||
                other.insights == insights) &&
            (identical(other.inactivity, inactivity) ||
                other.inactivity == inactivity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reminders, insights, inactivity);

  /// Create a copy of NotificationTypesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationTypesEntityImplCopyWith<_$NotificationTypesEntityImpl>
      get copyWith => __$$NotificationTypesEntityImplCopyWithImpl<
          _$NotificationTypesEntityImpl>(this, _$identity);
}

abstract class _NotificationTypesEntity implements NotificationTypesEntity {
  const factory _NotificationTypesEntity(
      {final bool reminders,
      final bool insights,
      final bool inactivity}) = _$NotificationTypesEntityImpl;

  @override
  bool get reminders;
  @override
  bool get insights;
  @override
  bool get inactivity;

  /// Create a copy of NotificationTypesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationTypesEntityImplCopyWith<_$NotificationTypesEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
