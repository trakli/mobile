// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedbackState {
  List<FeedbackEntity> get items => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;

  /// Why the history could not be loaded; shown in place of the list.
  Failure get loadFailure => throw _privateConstructorUsedError;

  /// Why the last submission failed; surfaced as a snackbar.
  Failure get failure => throw _privateConstructorUsedError;

  /// Bumped on every successful submission so listeners can react to each
  /// one, even when two sends carry the same text.
  int get submittedCount => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackStateCopyWith<FeedbackState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackStateCopyWith<$Res> {
  factory $FeedbackStateCopyWith(
          FeedbackState value, $Res Function(FeedbackState) then) =
      _$FeedbackStateCopyWithImpl<$Res, FeedbackState>;
  @useResult
  $Res call(
      {List<FeedbackEntity> items,
      bool isLoading,
      bool isSubmitting,
      Failure loadFailure,
      Failure failure,
      int submittedCount});

  $FailureCopyWith<$Res> get loadFailure;
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$FeedbackStateCopyWithImpl<$Res, $Val extends FeedbackState>
    implements $FeedbackStateCopyWith<$Res> {
  _$FeedbackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? loadFailure = null,
    Object? failure = null,
    Object? submittedCount = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FeedbackEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      loadFailure: null == loadFailure
          ? _value.loadFailure
          : loadFailure // ignore: cast_nullable_to_non_nullable
              as Failure,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
      submittedCount: null == submittedCount
          ? _value.submittedCount
          : submittedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get loadFailure {
    return $FailureCopyWith<$Res>(_value.loadFailure, (value) {
      return _then(_value.copyWith(loadFailure: value) as $Val);
    });
  }

  /// Create a copy of FeedbackState
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
abstract class _$$FeedbackStateImplCopyWith<$Res>
    implements $FeedbackStateCopyWith<$Res> {
  factory _$$FeedbackStateImplCopyWith(
          _$FeedbackStateImpl value, $Res Function(_$FeedbackStateImpl) then) =
      __$$FeedbackStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FeedbackEntity> items,
      bool isLoading,
      bool isSubmitting,
      Failure loadFailure,
      Failure failure,
      int submittedCount});

  @override
  $FailureCopyWith<$Res> get loadFailure;
  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$FeedbackStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackStateImpl>
    implements _$$FeedbackStateImplCopyWith<$Res> {
  __$$FeedbackStateImplCopyWithImpl(
      _$FeedbackStateImpl _value, $Res Function(_$FeedbackStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? loadFailure = null,
    Object? failure = null,
    Object? submittedCount = null,
  }) {
    return _then(_$FeedbackStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FeedbackEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      loadFailure: null == loadFailure
          ? _value.loadFailure
          : loadFailure // ignore: cast_nullable_to_non_nullable
              as Failure,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
      submittedCount: null == submittedCount
          ? _value.submittedCount
          : submittedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$FeedbackStateImpl implements _FeedbackState {
  const _$FeedbackStateImpl(
      {required final List<FeedbackEntity> items,
      required this.isLoading,
      required this.isSubmitting,
      required this.loadFailure,
      required this.failure,
      required this.submittedCount})
      : _items = items;

  final List<FeedbackEntity> _items;
  @override
  List<FeedbackEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final bool isLoading;
  @override
  final bool isSubmitting;

  /// Why the history could not be loaded; shown in place of the list.
  @override
  final Failure loadFailure;

  /// Why the last submission failed; surfaced as a snackbar.
  @override
  final Failure failure;

  /// Bumped on every successful submission so listeners can react to each
  /// one, even when two sends carry the same text.
  @override
  final int submittedCount;

  @override
  String toString() {
    return 'FeedbackState(items: $items, isLoading: $isLoading, isSubmitting: $isSubmitting, loadFailure: $loadFailure, failure: $failure, submittedCount: $submittedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.loadFailure, loadFailure) ||
                other.loadFailure == loadFailure) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.submittedCount, submittedCount) ||
                other.submittedCount == submittedCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      isLoading,
      isSubmitting,
      loadFailure,
      failure,
      submittedCount);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackStateImplCopyWith<_$FeedbackStateImpl> get copyWith =>
      __$$FeedbackStateImplCopyWithImpl<_$FeedbackStateImpl>(this, _$identity);
}

abstract class _FeedbackState implements FeedbackState {
  const factory _FeedbackState(
      {required final List<FeedbackEntity> items,
      required final bool isLoading,
      required final bool isSubmitting,
      required final Failure loadFailure,
      required final Failure failure,
      required final int submittedCount}) = _$FeedbackStateImpl;

  @override
  List<FeedbackEntity> get items;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;

  /// Why the history could not be loaded; shown in place of the list.
  @override
  Failure get loadFailure;

  /// Why the last submission failed; surfaced as a snackbar.
  @override
  Failure get failure;

  /// Bumped on every successful submission so listeners can react to each
  /// one, even when two sends carry the same text.
  @override
  int get submittedCount;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackStateImplCopyWith<_$FeedbackStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
