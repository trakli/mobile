// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_complete_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionCompleteEntity {
  TransactionEntity get transaction => throw _privateConstructorUsedError;
  List<CategoryEntity> get categories => throw _privateConstructorUsedError;
  WalletEntity get wallet => throw _privateConstructorUsedError;

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCompleteEntityCopyWith<TransactionCompleteEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCompleteEntityCopyWith<$Res> {
  factory $TransactionCompleteEntityCopyWith(TransactionCompleteEntity value,
          $Res Function(TransactionCompleteEntity) then) =
      _$TransactionCompleteEntityCopyWithImpl<$Res, TransactionCompleteEntity>;
  @useResult
  $Res call(
      {TransactionEntity transaction,
      List<CategoryEntity> categories,
      WalletEntity wallet});

  $TransactionEntityCopyWith<$Res> get transaction;
  $WalletEntityCopyWith<$Res> get wallet;
}

/// @nodoc
class _$TransactionCompleteEntityCopyWithImpl<$Res,
        $Val extends TransactionCompleteEntity>
    implements $TransactionCompleteEntityCopyWith<$Res> {
  _$TransactionCompleteEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transaction = null,
    Object? categories = null,
    Object? wallet = null,
  }) {
    return _then(_value.copyWith(
      transaction: null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as TransactionEntity,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryEntity>,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletEntity,
    ) as $Val);
  }

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionEntityCopyWith<$Res> get transaction {
    return $TransactionEntityCopyWith<$Res>(_value.transaction, (value) {
      return _then(_value.copyWith(transaction: value) as $Val);
    });
  }

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletEntityCopyWith<$Res> get wallet {
    return $WalletEntityCopyWith<$Res>(_value.wallet, (value) {
      return _then(_value.copyWith(wallet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionCompleteEntityImplCopyWith<$Res>
    implements $TransactionCompleteEntityCopyWith<$Res> {
  factory _$$TransactionCompleteEntityImplCopyWith(
          _$TransactionCompleteEntityImpl value,
          $Res Function(_$TransactionCompleteEntityImpl) then) =
      __$$TransactionCompleteEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TransactionEntity transaction,
      List<CategoryEntity> categories,
      WalletEntity wallet});

  @override
  $TransactionEntityCopyWith<$Res> get transaction;
  @override
  $WalletEntityCopyWith<$Res> get wallet;
}

/// @nodoc
class __$$TransactionCompleteEntityImplCopyWithImpl<$Res>
    extends _$TransactionCompleteEntityCopyWithImpl<$Res,
        _$TransactionCompleteEntityImpl>
    implements _$$TransactionCompleteEntityImplCopyWith<$Res> {
  __$$TransactionCompleteEntityImplCopyWithImpl(
      _$TransactionCompleteEntityImpl _value,
      $Res Function(_$TransactionCompleteEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transaction = null,
    Object? categories = null,
    Object? wallet = null,
  }) {
    return _then(_$TransactionCompleteEntityImpl(
      transaction: null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as TransactionEntity,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryEntity>,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletEntity,
    ));
  }
}

/// @nodoc

class _$TransactionCompleteEntityImpl implements _TransactionCompleteEntity {
  _$TransactionCompleteEntityImpl(
      {required this.transaction,
      required final List<CategoryEntity> categories,
      required this.wallet})
      : _categories = categories;

  @override
  final TransactionEntity transaction;
  final List<CategoryEntity> _categories;
  @override
  List<CategoryEntity> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final WalletEntity wallet;

  @override
  String toString() {
    return 'TransactionCompleteEntity(transaction: $transaction, categories: $categories, wallet: $wallet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionCompleteEntityImpl &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.wallet, wallet) || other.wallet == wallet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, transaction,
      const DeepCollectionEquality().hash(_categories), wallet);

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionCompleteEntityImplCopyWith<_$TransactionCompleteEntityImpl>
      get copyWith => __$$TransactionCompleteEntityImplCopyWithImpl<
          _$TransactionCompleteEntityImpl>(this, _$identity);
}

abstract class _TransactionCompleteEntity implements TransactionCompleteEntity {
  factory _TransactionCompleteEntity(
      {required final TransactionEntity transaction,
      required final List<CategoryEntity> categories,
      required final WalletEntity wallet}) = _$TransactionCompleteEntityImpl;

  @override
  TransactionEntity get transaction;
  @override
  List<CategoryEntity> get categories;
  @override
  WalletEntity get wallet;

  /// Create a copy of TransactionCompleteEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionCompleteEntityImplCopyWith<_$TransactionCompleteEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
