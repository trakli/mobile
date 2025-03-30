// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
          _$ServerFailureImpl value, $Res Function(_$ServerFailureImpl) then) =
      __$$ServerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
      _$ServerFailureImpl _value, $Res Function(_$ServerFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ServerFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.serverError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure(final String message) = _$ServerFailureImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(_$NetworkFailureImpl value,
          $Res Function(_$NetworkFailureImpl) then) =
      __$$NetworkFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
      _$NetworkFailureImpl _value, $Res Function(_$NetworkFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl();

  @override
  String toString() {
    return 'Failure.networkError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure() = _$NetworkFailureImpl;
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
          _$CacheFailureImpl value, $Res Function(_$CacheFailureImpl) then) =
      __$$CacheFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
      _$CacheFailureImpl _value, $Res Function(_$CacheFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CacheFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CacheFailureImpl implements CacheFailure {
  const _$CacheFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.cacheError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return cacheError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return cacheError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (cacheError != null) {
      return cacheError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return cacheError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return cacheError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (cacheError != null) {
      return cacheError(this);
    }
    return orElse();
  }
}

abstract class CacheFailure implements Failure {
  const factory CacheFailure(final String message) = _$CacheFailureImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncFailureImplCopyWith<$Res> {
  factory _$$SyncFailureImplCopyWith(
          _$SyncFailureImpl value, $Res Function(_$SyncFailureImpl) then) =
      __$$SyncFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SyncFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$SyncFailureImpl>
    implements _$$SyncFailureImplCopyWith<$Res> {
  __$$SyncFailureImplCopyWithImpl(
      _$SyncFailureImpl _value, $Res Function(_$SyncFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SyncFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncFailureImpl implements SyncFailure {
  const _$SyncFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.syncError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncFailureImplCopyWith<_$SyncFailureImpl> get copyWith =>
      __$$SyncFailureImplCopyWithImpl<_$SyncFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return syncError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return syncError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (syncError != null) {
      return syncError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return syncError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return syncError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (syncError != null) {
      return syncError(this);
    }
    return orElse();
  }
}

abstract class SyncFailure implements Failure {
  const factory SyncFailure(final String message) = _$SyncFailureImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncFailureImplCopyWith<_$SyncFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(_$ValidationFailureImpl value,
          $Res Function(_$ValidationFailureImpl) then) =
      __$$ValidationFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(_$ValidationFailureImpl _value,
      $Res Function(_$ValidationFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ValidationFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.validationError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return validationError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return validationError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return validationError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return validationError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure(final String message) =
      _$ValidationFailureImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedFailureImplCopyWith<$Res> {
  factory _$$UnauthorizedFailureImplCopyWith(_$UnauthorizedFailureImpl value,
          $Res Function(_$UnauthorizedFailureImpl) then) =
      __$$UnauthorizedFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthorizedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnauthorizedFailureImpl>
    implements _$$UnauthorizedFailureImplCopyWith<$Res> {
  __$$UnauthorizedFailureImplCopyWithImpl(_$UnauthorizedFailureImpl _value,
      $Res Function(_$UnauthorizedFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthorizedFailureImpl implements UnauthorizedFailure {
  const _$UnauthorizedFailureImpl();

  @override
  String toString() {
    return 'Failure.unauthorizedError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return unauthorizedError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return unauthorizedError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (unauthorizedError != null) {
      return unauthorizedError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return unauthorizedError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return unauthorizedError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (unauthorizedError != null) {
      return unauthorizedError(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedFailure implements Failure {
  const factory UnauthorizedFailure() = _$UnauthorizedFailureImpl;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnknownFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unknownError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message) validationError,
    required TResult Function() unauthorizedError,
    required TResult Function(String message) unknownError,
  }) {
    return unknownError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function(String message)? unknownError,
  }) {
    return unknownError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function(String message)? unknownError,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
  }) {
    return unknownError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
  }) {
    return unknownError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure(final String message) = _$UnknownFailureImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
