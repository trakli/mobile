// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateUserResponseDto _$CreateUserResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateUserResponseDto.fromJson(json);
}

/// @nodoc
mixin _$CreateUserResponseDto {
  @JsonKey(name: 'token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  Map<String, dynamic> get user => throw _privateConstructorUsedError;

  /// Serializes this CreateUserResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserResponseDtoCopyWith<CreateUserResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserResponseDtoCopyWith<$Res> {
  factory $CreateUserResponseDtoCopyWith(CreateUserResponseDto value,
          $Res Function(CreateUserResponseDto) then) =
      _$CreateUserResponseDtoCopyWithImpl<$Res, CreateUserResponseDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'token') String accessToken,
      @JsonKey(name: 'user') Map<String, dynamic> user});
}

/// @nodoc
class _$CreateUserResponseDtoCopyWithImpl<$Res,
        $Val extends CreateUserResponseDto>
    implements $CreateUserResponseDtoCopyWith<$Res> {
  _$CreateUserResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateUserResponseDtoImplCopyWith<$Res>
    implements $CreateUserResponseDtoCopyWith<$Res> {
  factory _$$CreateUserResponseDtoImplCopyWith(
          _$CreateUserResponseDtoImpl value,
          $Res Function(_$CreateUserResponseDtoImpl) then) =
      __$$CreateUserResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'token') String accessToken,
      @JsonKey(name: 'user') Map<String, dynamic> user});
}

/// @nodoc
class __$$CreateUserResponseDtoImplCopyWithImpl<$Res>
    extends _$CreateUserResponseDtoCopyWithImpl<$Res,
        _$CreateUserResponseDtoImpl>
    implements _$$CreateUserResponseDtoImplCopyWith<$Res> {
  __$$CreateUserResponseDtoImplCopyWithImpl(_$CreateUserResponseDtoImpl _value,
      $Res Function(_$CreateUserResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUserResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? user = null,
  }) {
    return _then(_$CreateUserResponseDtoImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateUserResponseDtoImpl implements _CreateUserResponseDto {
  const _$CreateUserResponseDtoImpl(
      {@JsonKey(name: 'token') required this.accessToken,
      @JsonKey(name: 'user') required final Map<String, dynamic> user})
      : _user = user;

  factory _$CreateUserResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateUserResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'token')
  final String accessToken;
  final Map<String, dynamic> _user;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic> get user {
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_user);
  }

  @override
  String toString() {
    return 'CreateUserResponseDto(accessToken: $accessToken, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserResponseDtoImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            const DeepCollectionEquality().equals(other._user, _user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, const DeepCollectionEquality().hash(_user));

  /// Create a copy of CreateUserResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserResponseDtoImplCopyWith<_$CreateUserResponseDtoImpl>
      get copyWith => __$$CreateUserResponseDtoImplCopyWithImpl<
          _$CreateUserResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateUserResponseDto implements CreateUserResponseDto {
  const factory _CreateUserResponseDto(
          {@JsonKey(name: 'token') required final String accessToken,
          @JsonKey(name: 'user') required final Map<String, dynamic> user}) =
      _$CreateUserResponseDtoImpl;

  factory _CreateUserResponseDto.fromJson(Map<String, dynamic> json) =
      _$CreateUserResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'token')
  String get accessToken;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic> get user;

  /// Create a copy of CreateUserResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserResponseDtoImplCopyWith<_$CreateUserResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
