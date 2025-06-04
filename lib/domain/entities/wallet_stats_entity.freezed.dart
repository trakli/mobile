// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalletStatsEntity {
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;

  /// Create a copy of WalletStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletStatsEntityCopyWith<WalletStatsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletStatsEntityCopyWith<$Res> {
  factory $WalletStatsEntityCopyWith(
          WalletStatsEntity value, $Res Function(WalletStatsEntity) then) =
      _$WalletStatsEntityCopyWithImpl<$Res, WalletStatsEntity>;
  @useResult
  $Res call({double totalIncome, double totalExpense});
}

/// @nodoc
class _$WalletStatsEntityCopyWithImpl<$Res, $Val extends WalletStatsEntity>
    implements $WalletStatsEntityCopyWith<$Res> {
  _$WalletStatsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletStatsEntityImplCopyWith<$Res>
    implements $WalletStatsEntityCopyWith<$Res> {
  factory _$$WalletStatsEntityImplCopyWith(_$WalletStatsEntityImpl value,
          $Res Function(_$WalletStatsEntityImpl) then) =
      __$$WalletStatsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double totalIncome, double totalExpense});
}

/// @nodoc
class __$$WalletStatsEntityImplCopyWithImpl<$Res>
    extends _$WalletStatsEntityCopyWithImpl<$Res, _$WalletStatsEntityImpl>
    implements _$$WalletStatsEntityImplCopyWith<$Res> {
  __$$WalletStatsEntityImplCopyWithImpl(_$WalletStatsEntityImpl _value,
      $Res Function(_$WalletStatsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_$WalletStatsEntityImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WalletStatsEntityImpl implements _WalletStatsEntity {
  const _$WalletStatsEntityImpl(
      {required this.totalIncome, required this.totalExpense});

  @override
  final double totalIncome;
  @override
  final double totalExpense;

  @override
  String toString() {
    return 'WalletStatsEntity(totalIncome: $totalIncome, totalExpense: $totalExpense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletStatsEntityImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpense);

  /// Create a copy of WalletStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletStatsEntityImplCopyWith<_$WalletStatsEntityImpl> get copyWith =>
      __$$WalletStatsEntityImplCopyWithImpl<_$WalletStatsEntityImpl>(
          this, _$identity);
}

abstract class _WalletStatsEntity implements WalletStatsEntity {
  const factory _WalletStatsEntity(
      {required final double totalIncome,
      required final double totalExpense}) = _$WalletStatsEntityImpl;

  @override
  double get totalIncome;
  @override
  double get totalExpense;

  /// Create a copy of WalletStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletStatsEntityImplCopyWith<_$WalletStatsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
