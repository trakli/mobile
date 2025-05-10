// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) {
  return _AuthResponseDto.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseDto {
  @JsonKey(name: 'token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String? get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in')
  int? get expireTn => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String? get tokenType => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  Map<String, dynamic> get user => throw _privateConstructorUsedError;

  /// Serializes this AuthResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseDtoCopyWith<AuthResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseDtoCopyWith<$Res> {
  factory $AuthResponseDtoCopyWith(
          AuthResponseDto value, $Res Function(AuthResponseDto) then) =
      _$AuthResponseDtoCopyWithImpl<$Res, AuthResponseDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'token') String accessToken,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'expires_in') int? expireTn,
      @JsonKey(name: 'token_type') String? tokenType,
      @JsonKey(name: 'user') Map<String, dynamic> user});
}

/// @nodoc
class _$AuthResponseDtoCopyWithImpl<$Res, $Val extends AuthResponseDto>
    implements $AuthResponseDtoCopyWith<$Res> {
  _$AuthResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expireTn = freezed,
    Object? tokenType = freezed,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expireTn: freezed == expireTn
          ? _value.expireTn
          : expireTn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokenType: freezed == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthResponseDtoImplCopyWith<$Res>
    implements $AuthResponseDtoCopyWith<$Res> {
  factory _$$AuthResponseDtoImplCopyWith(_$AuthResponseDtoImpl value,
          $Res Function(_$AuthResponseDtoImpl) then) =
      __$$AuthResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'token') String accessToken,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'expires_in') int? expireTn,
      @JsonKey(name: 'token_type') String? tokenType,
      @JsonKey(name: 'user') Map<String, dynamic> user});
}

/// @nodoc
class __$$AuthResponseDtoImplCopyWithImpl<$Res>
    extends _$AuthResponseDtoCopyWithImpl<$Res, _$AuthResponseDtoImpl>
    implements _$$AuthResponseDtoImplCopyWith<$Res> {
  __$$AuthResponseDtoImplCopyWithImpl(
      _$AuthResponseDtoImpl _value, $Res Function(_$AuthResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expireTn = freezed,
    Object? tokenType = freezed,
    Object? user = null,
  }) {
    return _then(_$AuthResponseDtoImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expireTn: freezed == expireTn
          ? _value.expireTn
          : expireTn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokenType: freezed == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseDtoImpl implements _AuthResponseDto {
  const _$AuthResponseDtoImpl(
      {@JsonKey(name: 'token') required this.accessToken,
      @JsonKey(name: 'refresh_token') this.refreshToken,
      @JsonKey(name: 'expires_in') this.expireTn,
      @JsonKey(name: 'token_type') this.tokenType,
      @JsonKey(name: 'user') required final Map<String, dynamic> user})
      : _user = user;

  factory _$AuthResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  final int? expireTn;
  @override
  @JsonKey(name: 'token_type')
  final String? tokenType;
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
    return 'AuthResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expireTn: $expireTn, tokenType: $tokenType, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseDtoImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expireTn, expireTn) ||
                other.expireTn == expireTn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            const DeepCollectionEquality().equals(other._user, _user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      expireTn, tokenType, const DeepCollectionEquality().hash(_user));

  /// Create a copy of AuthResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseDtoImplCopyWith<_$AuthResponseDtoImpl> get copyWith =>
      __$$AuthResponseDtoImplCopyWithImpl<_$AuthResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _AuthResponseDto implements AuthResponseDto {
  const factory _AuthResponseDto(
          {@JsonKey(name: 'token') required final String accessToken,
          @JsonKey(name: 'refresh_token') final String? refreshToken,
          @JsonKey(name: 'expires_in') final int? expireTn,
          @JsonKey(name: 'token_type') final String? tokenType,
          @JsonKey(name: 'user') required final Map<String, dynamic> user}) =
      _$AuthResponseDtoImpl;

  factory _AuthResponseDto.fromJson(Map<String, dynamic> json) =
      _$AuthResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String? get refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  int? get expireTn;
  @override
  @JsonKey(name: 'token_type')
  String? get tokenType;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic> get user;

  /// Create a copy of AuthResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseDtoImplCopyWith<_$AuthResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
