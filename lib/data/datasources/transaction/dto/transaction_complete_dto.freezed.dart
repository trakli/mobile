// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_complete_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionCompleteDto {
  @TransactionConverter()
  Transaction get transaction => throw _privateConstructorUsedError;
  @CategoryConverter()
  List<Category> get categories => throw _privateConstructorUsedError;
  @WalletConverter()
  Wallet get wallet => throw _privateConstructorUsedError;

  /// Create a copy of TransactionCompleteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCompleteDtoCopyWith<TransactionCompleteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCompleteDtoCopyWith<$Res> {
  factory $TransactionCompleteDtoCopyWith(TransactionCompleteDto value,
          $Res Function(TransactionCompleteDto) then) =
      _$TransactionCompleteDtoCopyWithImpl<$Res, TransactionCompleteDto>;
  @useResult
  $Res call(
      {@TransactionConverter() Transaction transaction,
      @CategoryConverter() List<Category> categories,
      @WalletConverter() Wallet wallet});
}

/// @nodoc
class _$TransactionCompleteDtoCopyWithImpl<$Res,
        $Val extends TransactionCompleteDto>
    implements $TransactionCompleteDtoCopyWith<$Res> {
  _$TransactionCompleteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionCompleteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transaction = freezed,
    Object? categories = null,
    Object? wallet = freezed,
  }) {
    return _then(_value.copyWith(
      transaction: freezed == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as Transaction,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      wallet: freezed == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as Wallet,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionCompleteDtoImplCopyWith<$Res>
    implements $TransactionCompleteDtoCopyWith<$Res> {
  factory _$$TransactionCompleteDtoImplCopyWith(
          _$TransactionCompleteDtoImpl value,
          $Res Function(_$TransactionCompleteDtoImpl) then) =
      __$$TransactionCompleteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@TransactionConverter() Transaction transaction,
      @CategoryConverter() List<Category> categories,
      @WalletConverter() Wallet wallet});
}

/// @nodoc
class __$$TransactionCompleteDtoImplCopyWithImpl<$Res>
    extends _$TransactionCompleteDtoCopyWithImpl<$Res,
        _$TransactionCompleteDtoImpl>
    implements _$$TransactionCompleteDtoImplCopyWith<$Res> {
  __$$TransactionCompleteDtoImplCopyWithImpl(
      _$TransactionCompleteDtoImpl _value,
      $Res Function(_$TransactionCompleteDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionCompleteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transaction = freezed,
    Object? categories = null,
    Object? wallet = freezed,
  }) {
    return _then(_$TransactionCompleteDtoImpl(
      transaction: freezed == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as Transaction,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      wallet: freezed == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as Wallet,
    ));
  }
}

/// @nodoc

class _$TransactionCompleteDtoImpl extends _TransactionCompleteDto {
  const _$TransactionCompleteDtoImpl(
      {@TransactionConverter() required this.transaction,
      @CategoryConverter() final List<Category> categories = const [],
      @WalletConverter() required this.wallet})
      : _categories = categories,
        super._();

  @override
  @TransactionConverter()
  final Transaction transaction;
  final List<Category> _categories;
  @override
  @JsonKey()
  @CategoryConverter()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @WalletConverter()
  final Wallet wallet;

  @override
  String toString() {
    return 'TransactionCompleteDto(transaction: $transaction, categories: $categories, wallet: $wallet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionCompleteDtoImpl &&
            const DeepCollectionEquality()
                .equals(other.transaction, transaction) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other.wallet, wallet));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(transaction),
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(wallet));

  /// Create a copy of TransactionCompleteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionCompleteDtoImplCopyWith<_$TransactionCompleteDtoImpl>
      get copyWith => __$$TransactionCompleteDtoImplCopyWithImpl<
          _$TransactionCompleteDtoImpl>(this, _$identity);
}

abstract class _TransactionCompleteDto extends TransactionCompleteDto {
  const factory _TransactionCompleteDto(
          {@TransactionConverter() required final Transaction transaction,
          @CategoryConverter() final List<Category> categories,
          @WalletConverter() required final Wallet wallet}) =
      _$TransactionCompleteDtoImpl;
  const _TransactionCompleteDto._() : super._();

  @override
  @TransactionConverter()
  Transaction get transaction;
  @override
  @CategoryConverter()
  List<Category> get categories;
  @override
  @WalletConverter()
  Wallet get wallet;

  /// Create a copy of TransactionCompleteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionCompleteDtoImplCopyWith<_$TransactionCompleteDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
