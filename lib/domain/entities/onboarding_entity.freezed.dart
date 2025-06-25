// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingEntity _$OnboardingEntityFromJson(Map<String, dynamic> json) {
  return _OnboardingEntity.fromJson(json);
}

/// @nodoc
mixin _$OnboardingEntity {
  @CurrencyConverter()
  Currency? get selectedCurrency => throw _privateConstructorUsedError;
  String? get defaultGroup => throw _privateConstructorUsedError;

  /// Serializes this OnboardingEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingEntityCopyWith<OnboardingEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingEntityCopyWith<$Res> {
  factory $OnboardingEntityCopyWith(
          OnboardingEntity value, $Res Function(OnboardingEntity) then) =
      _$OnboardingEntityCopyWithImpl<$Res, OnboardingEntity>;
  @useResult
  $Res call(
      {@CurrencyConverter() Currency? selectedCurrency, String? defaultGroup});
}

/// @nodoc
class _$OnboardingEntityCopyWithImpl<$Res, $Val extends OnboardingEntity>
    implements $OnboardingEntityCopyWith<$Res> {
  _$OnboardingEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCurrency = freezed,
    Object? defaultGroup = freezed,
  }) {
    return _then(_value.copyWith(
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      defaultGroup: freezed == defaultGroup
          ? _value.defaultGroup
          : defaultGroup // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingEntityImplCopyWith<$Res>
    implements $OnboardingEntityCopyWith<$Res> {
  factory _$$OnboardingEntityImplCopyWith(_$OnboardingEntityImpl value,
          $Res Function(_$OnboardingEntityImpl) then) =
      __$$OnboardingEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@CurrencyConverter() Currency? selectedCurrency, String? defaultGroup});
}

/// @nodoc
class __$$OnboardingEntityImplCopyWithImpl<$Res>
    extends _$OnboardingEntityCopyWithImpl<$Res, _$OnboardingEntityImpl>
    implements _$$OnboardingEntityImplCopyWith<$Res> {
  __$$OnboardingEntityImplCopyWithImpl(_$OnboardingEntityImpl _value,
      $Res Function(_$OnboardingEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCurrency = freezed,
    Object? defaultGroup = freezed,
  }) {
    return _then(_$OnboardingEntityImpl(
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      defaultGroup: freezed == defaultGroup
          ? _value.defaultGroup
          : defaultGroup // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingEntityImpl extends _OnboardingEntity {
  const _$OnboardingEntityImpl(
      {@CurrencyConverter() this.selectedCurrency, this.defaultGroup})
      : super._();

  factory _$OnboardingEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingEntityImplFromJson(json);

  @override
  @CurrencyConverter()
  final Currency? selectedCurrency;
  @override
  final String? defaultGroup;

  @override
  String toString() {
    return 'OnboardingEntity(selectedCurrency: $selectedCurrency, defaultGroup: $defaultGroup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingEntityImpl &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            (identical(other.defaultGroup, defaultGroup) ||
                other.defaultGroup == defaultGroup));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedCurrency, defaultGroup);

  /// Create a copy of OnboardingEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingEntityImplCopyWith<_$OnboardingEntityImpl> get copyWith =>
      __$$OnboardingEntityImplCopyWithImpl<_$OnboardingEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingEntityImplToJson(
      this,
    );
  }
}

abstract class _OnboardingEntity extends OnboardingEntity {
  const factory _OnboardingEntity(
      {@CurrencyConverter() final Currency? selectedCurrency,
      final String? defaultGroup}) = _$OnboardingEntityImpl;
  const _OnboardingEntity._() : super._();

  factory _OnboardingEntity.fromJson(Map<String, dynamic> json) =
      _$OnboardingEntityImpl.fromJson;

  @override
  @CurrencyConverter()
  Currency? get selectedCurrency;
  @override
  String? get defaultGroup;

  /// Create a copy of OnboardingEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingEntityImplCopyWith<_$OnboardingEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
