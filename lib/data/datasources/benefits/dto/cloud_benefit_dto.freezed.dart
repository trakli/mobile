// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud_benefit_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CloudBenefitDto _$CloudBenefitDtoFromJson(Map<String, dynamic> json) {
  return _CloudBenefitDto.fromJson(json);
}

/// @nodoc
mixin _$CloudBenefitDto {
  OverviewDto get overview => throw _privateConstructorUsedError;
  List<BenefitDto> get benefits => throw _privateConstructorUsedError;
  @JsonKey(name: 'trial_days')
  int get trialDays => throw _privateConstructorUsedError;

  /// Serializes this CloudBenefitDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CloudBenefitDtoCopyWith<CloudBenefitDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CloudBenefitDtoCopyWith<$Res> {
  factory $CloudBenefitDtoCopyWith(
          CloudBenefitDto value, $Res Function(CloudBenefitDto) then) =
      _$CloudBenefitDtoCopyWithImpl<$Res, CloudBenefitDto>;
  @useResult
  $Res call(
      {OverviewDto overview,
      List<BenefitDto> benefits,
      @JsonKey(name: 'trial_days') int trialDays});

  $OverviewDtoCopyWith<$Res> get overview;
}

/// @nodoc
class _$CloudBenefitDtoCopyWithImpl<$Res, $Val extends CloudBenefitDto>
    implements $CloudBenefitDtoCopyWith<$Res> {
  _$CloudBenefitDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? benefits = null,
    Object? trialDays = null,
  }) {
    return _then(_value.copyWith(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as OverviewDto,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<BenefitDto>,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverviewDtoCopyWith<$Res> get overview {
    return $OverviewDtoCopyWith<$Res>(_value.overview, (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CloudBenefitDtoImplCopyWith<$Res>
    implements $CloudBenefitDtoCopyWith<$Res> {
  factory _$$CloudBenefitDtoImplCopyWith(_$CloudBenefitDtoImpl value,
          $Res Function(_$CloudBenefitDtoImpl) then) =
      __$$CloudBenefitDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OverviewDto overview,
      List<BenefitDto> benefits,
      @JsonKey(name: 'trial_days') int trialDays});

  @override
  $OverviewDtoCopyWith<$Res> get overview;
}

/// @nodoc
class __$$CloudBenefitDtoImplCopyWithImpl<$Res>
    extends _$CloudBenefitDtoCopyWithImpl<$Res, _$CloudBenefitDtoImpl>
    implements _$$CloudBenefitDtoImplCopyWith<$Res> {
  __$$CloudBenefitDtoImplCopyWithImpl(
      _$CloudBenefitDtoImpl _value, $Res Function(_$CloudBenefitDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? benefits = null,
    Object? trialDays = null,
  }) {
    return _then(_$CloudBenefitDtoImpl(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as OverviewDto,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<BenefitDto>,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CloudBenefitDtoImpl extends _CloudBenefitDto {
  const _$CloudBenefitDtoImpl(
      {required this.overview,
      required final List<BenefitDto> benefits,
      @JsonKey(name: 'trial_days') required this.trialDays})
      : _benefits = benefits,
        super._();

  factory _$CloudBenefitDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CloudBenefitDtoImplFromJson(json);

  @override
  final OverviewDto overview;
  final List<BenefitDto> _benefits;
  @override
  List<BenefitDto> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  @override
  @JsonKey(name: 'trial_days')
  final int trialDays;

  @override
  String toString() {
    return 'CloudBenefitDto(overview: $overview, benefits: $benefits, trialDays: $trialDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CloudBenefitDtoImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            (identical(other.trialDays, trialDays) ||
                other.trialDays == trialDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, overview,
      const DeepCollectionEquality().hash(_benefits), trialDays);

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CloudBenefitDtoImplCopyWith<_$CloudBenefitDtoImpl> get copyWith =>
      __$$CloudBenefitDtoImplCopyWithImpl<_$CloudBenefitDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CloudBenefitDtoImplToJson(
      this,
    );
  }
}

abstract class _CloudBenefitDto extends CloudBenefitDto {
  const factory _CloudBenefitDto(
          {required final OverviewDto overview,
          required final List<BenefitDto> benefits,
          @JsonKey(name: 'trial_days') required final int trialDays}) =
      _$CloudBenefitDtoImpl;
  const _CloudBenefitDto._() : super._();

  factory _CloudBenefitDto.fromJson(Map<String, dynamic> json) =
      _$CloudBenefitDtoImpl.fromJson;

  @override
  OverviewDto get overview;
  @override
  List<BenefitDto> get benefits;
  @override
  @JsonKey(name: 'trial_days')
  int get trialDays;

  /// Create a copy of CloudBenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CloudBenefitDtoImplCopyWith<_$CloudBenefitDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverviewDto _$OverviewDtoFromJson(Map<String, dynamic> json) {
  return _OverviewDto.fromJson(json);
}

/// @nodoc
mixin _$OverviewDto {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this OverviewDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewDtoCopyWith<OverviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewDtoCopyWith<$Res> {
  factory $OverviewDtoCopyWith(
          OverviewDto value, $Res Function(OverviewDto) then) =
      _$OverviewDtoCopyWithImpl<$Res, OverviewDto>;
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class _$OverviewDtoCopyWithImpl<$Res, $Val extends OverviewDto>
    implements $OverviewDtoCopyWith<$Res> {
  _$OverviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverviewDtoImplCopyWith<$Res>
    implements $OverviewDtoCopyWith<$Res> {
  factory _$$OverviewDtoImplCopyWith(
          _$OverviewDtoImpl value, $Res Function(_$OverviewDtoImpl) then) =
      __$$OverviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class __$$OverviewDtoImplCopyWithImpl<$Res>
    extends _$OverviewDtoCopyWithImpl<$Res, _$OverviewDtoImpl>
    implements _$$OverviewDtoImplCopyWith<$Res> {
  __$$OverviewDtoImplCopyWithImpl(
      _$OverviewDtoImpl _value, $Res Function(_$OverviewDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_$OverviewDtoImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewDtoImpl extends _OverviewDto {
  const _$OverviewDtoImpl({required this.title, required this.description})
      : super._();

  factory _$OverviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewDtoImplFromJson(json);

  @override
  final String title;
  @override
  final String description;

  @override
  String toString() {
    return 'OverviewDto(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewDtoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  /// Create a copy of OverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewDtoImplCopyWith<_$OverviewDtoImpl> get copyWith =>
      __$$OverviewDtoImplCopyWithImpl<_$OverviewDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewDtoImplToJson(
      this,
    );
  }
}

abstract class _OverviewDto extends OverviewDto {
  const factory _OverviewDto(
      {required final String title,
      required final String description}) = _$OverviewDtoImpl;
  const _OverviewDto._() : super._();

  factory _OverviewDto.fromJson(Map<String, dynamic> json) =
      _$OverviewDtoImpl.fromJson;

  @override
  String get title;
  @override
  String get description;

  /// Create a copy of OverviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewDtoImplCopyWith<_$OverviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BenefitDto _$BenefitDtoFromJson(Map<String, dynamic> json) {
  return _BenefitDto.fromJson(json);
}

/// @nodoc
mixin _$BenefitDto {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this BenefitDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BenefitDtoCopyWith<BenefitDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BenefitDtoCopyWith<$Res> {
  factory $BenefitDtoCopyWith(
          BenefitDto value, $Res Function(BenefitDto) then) =
      _$BenefitDtoCopyWithImpl<$Res, BenefitDto>;
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class _$BenefitDtoCopyWithImpl<$Res, $Val extends BenefitDto>
    implements $BenefitDtoCopyWith<$Res> {
  _$BenefitDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BenefitDtoImplCopyWith<$Res>
    implements $BenefitDtoCopyWith<$Res> {
  factory _$$BenefitDtoImplCopyWith(
          _$BenefitDtoImpl value, $Res Function(_$BenefitDtoImpl) then) =
      __$$BenefitDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class __$$BenefitDtoImplCopyWithImpl<$Res>
    extends _$BenefitDtoCopyWithImpl<$Res, _$BenefitDtoImpl>
    implements _$$BenefitDtoImplCopyWith<$Res> {
  __$$BenefitDtoImplCopyWithImpl(
      _$BenefitDtoImpl _value, $Res Function(_$BenefitDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_$BenefitDtoImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BenefitDtoImpl extends _BenefitDto {
  const _$BenefitDtoImpl({required this.title, required this.description})
      : super._();

  factory _$BenefitDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BenefitDtoImplFromJson(json);

  @override
  final String title;
  @override
  final String description;

  @override
  String toString() {
    return 'BenefitDto(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenefitDtoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  /// Create a copy of BenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BenefitDtoImplCopyWith<_$BenefitDtoImpl> get copyWith =>
      __$$BenefitDtoImplCopyWithImpl<_$BenefitDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BenefitDtoImplToJson(
      this,
    );
  }
}

abstract class _BenefitDto extends BenefitDto {
  const factory _BenefitDto(
      {required final String title,
      required final String description}) = _$BenefitDtoImpl;
  const _BenefitDto._() : super._();

  factory _BenefitDto.fromJson(Map<String, dynamic> json) =
      _$BenefitDtoImpl.fromJson;

  @override
  String get title;
  @override
  String get description;

  /// Create a copy of BenefitDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BenefitDtoImplCopyWith<_$BenefitDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
