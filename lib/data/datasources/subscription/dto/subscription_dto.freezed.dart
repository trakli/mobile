// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionDto _$SubscriptionDtoFromJson(Map<String, dynamic> json) {
  return _SubscriptionDto.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionDto {
  String get region => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'trial_days')
  int get trialDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'free_plan_enabled')
  bool get freePlanEnabled => throw _privateConstructorUsedError;
  List<PlanDto> get plans => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionDtoCopyWith<SubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionDtoCopyWith<$Res> {
  factory $SubscriptionDtoCopyWith(
          SubscriptionDto value, $Res Function(SubscriptionDto) then) =
      _$SubscriptionDtoCopyWithImpl<$Res, SubscriptionDto>;
  @useResult
  $Res call(
      {String region,
      String currency,
      @JsonKey(name: 'trial_days') int trialDays,
      @JsonKey(name: 'free_plan_enabled') bool freePlanEnabled,
      List<PlanDto> plans});
}

/// @nodoc
class _$SubscriptionDtoCopyWithImpl<$Res, $Val extends SubscriptionDto>
    implements $SubscriptionDtoCopyWith<$Res> {
  _$SubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = null,
    Object? currency = null,
    Object? trialDays = null,
    Object? freePlanEnabled = null,
    Object? plans = null,
  }) {
    return _then(_value.copyWith(
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
      freePlanEnabled: null == freePlanEnabled
          ? _value.freePlanEnabled
          : freePlanEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<PlanDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionDtoImplCopyWith<$Res>
    implements $SubscriptionDtoCopyWith<$Res> {
  factory _$$SubscriptionDtoImplCopyWith(_$SubscriptionDtoImpl value,
          $Res Function(_$SubscriptionDtoImpl) then) =
      __$$SubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String region,
      String currency,
      @JsonKey(name: 'trial_days') int trialDays,
      @JsonKey(name: 'free_plan_enabled') bool freePlanEnabled,
      List<PlanDto> plans});
}

/// @nodoc
class __$$SubscriptionDtoImplCopyWithImpl<$Res>
    extends _$SubscriptionDtoCopyWithImpl<$Res, _$SubscriptionDtoImpl>
    implements _$$SubscriptionDtoImplCopyWith<$Res> {
  __$$SubscriptionDtoImplCopyWithImpl(
      _$SubscriptionDtoImpl _value, $Res Function(_$SubscriptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? region = null,
    Object? currency = null,
    Object? trialDays = null,
    Object? freePlanEnabled = null,
    Object? plans = null,
  }) {
    return _then(_$SubscriptionDtoImpl(
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
      freePlanEnabled: null == freePlanEnabled
          ? _value.freePlanEnabled
          : freePlanEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      plans: null == plans
          ? _value._plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<PlanDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionDtoImpl extends _SubscriptionDto {
  const _$SubscriptionDtoImpl(
      {required this.region,
      required this.currency,
      @JsonKey(name: 'trial_days') required this.trialDays,
      @JsonKey(name: 'free_plan_enabled') required this.freePlanEnabled,
      required final List<PlanDto> plans})
      : _plans = plans,
        super._();

  factory _$SubscriptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionDtoImplFromJson(json);

  @override
  final String region;
  @override
  final String currency;
  @override
  @JsonKey(name: 'trial_days')
  final int trialDays;
  @override
  @JsonKey(name: 'free_plan_enabled')
  final bool freePlanEnabled;
  final List<PlanDto> _plans;
  @override
  List<PlanDto> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  String toString() {
    return 'SubscriptionDto(region: $region, currency: $currency, trialDays: $trialDays, freePlanEnabled: $freePlanEnabled, plans: $plans)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionDtoImpl &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.trialDays, trialDays) ||
                other.trialDays == trialDays) &&
            (identical(other.freePlanEnabled, freePlanEnabled) ||
                other.freePlanEnabled == freePlanEnabled) &&
            const DeepCollectionEquality().equals(other._plans, _plans));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, region, currency, trialDays,
      freePlanEnabled, const DeepCollectionEquality().hash(_plans));

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionDtoImplCopyWith<_$SubscriptionDtoImpl> get copyWith =>
      __$$SubscriptionDtoImplCopyWithImpl<_$SubscriptionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionDtoImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionDto extends SubscriptionDto {
  const factory _SubscriptionDto(
      {required final String region,
      required final String currency,
      @JsonKey(name: 'trial_days') required final int trialDays,
      @JsonKey(name: 'free_plan_enabled') required final bool freePlanEnabled,
      required final List<PlanDto> plans}) = _$SubscriptionDtoImpl;
  const _SubscriptionDto._() : super._();

  factory _SubscriptionDto.fromJson(Map<String, dynamic> json) =
      _$SubscriptionDtoImpl.fromJson;

  @override
  String get region;
  @override
  String get currency;
  @override
  @JsonKey(name: 'trial_days')
  int get trialDays;
  @override
  @JsonKey(name: 'free_plan_enabled')
  bool get freePlanEnabled;
  @override
  List<PlanDto> get plans;

  /// Create a copy of SubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionDtoImplCopyWith<_$SubscriptionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanDto _$PlanDtoFromJson(Map<String, dynamic> json) {
  return _PlanDto.fromJson(json);
}

/// @nodoc
mixin _$PlanDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get interval => throw _privateConstructorUsedError;
  List<String> get features => throw _privateConstructorUsedError;
  CtaDto get cta => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_cents')
  int get priceCents => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'trial_days')
  int get trialDays => throw _privateConstructorUsedError;

  /// Serializes this PlanDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanDtoCopyWith<PlanDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanDtoCopyWith<$Res> {
  factory $PlanDtoCopyWith(PlanDto value, $Res Function(PlanDto) then) =
      _$PlanDtoCopyWithImpl<$Res, PlanDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String interval,
      List<String> features,
      CtaDto cta,
      @JsonKey(name: 'price_cents') int priceCents,
      String currency,
      @JsonKey(name: 'trial_days') int trialDays});

  $CtaDtoCopyWith<$Res> get cta;
}

/// @nodoc
class _$PlanDtoCopyWithImpl<$Res, $Val extends PlanDto>
    implements $PlanDtoCopyWith<$Res> {
  _$PlanDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? interval = null,
    Object? features = null,
    Object? cta = null,
    Object? priceCents = null,
    Object? currency = null,
    Object? trialDays = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cta: null == cta
          ? _value.cta
          : cta // ignore: cast_nullable_to_non_nullable
              as CtaDto,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CtaDtoCopyWith<$Res> get cta {
    return $CtaDtoCopyWith<$Res>(_value.cta, (value) {
      return _then(_value.copyWith(cta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanDtoImplCopyWith<$Res> implements $PlanDtoCopyWith<$Res> {
  factory _$$PlanDtoImplCopyWith(
          _$PlanDtoImpl value, $Res Function(_$PlanDtoImpl) then) =
      __$$PlanDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String interval,
      List<String> features,
      CtaDto cta,
      @JsonKey(name: 'price_cents') int priceCents,
      String currency,
      @JsonKey(name: 'trial_days') int trialDays});

  @override
  $CtaDtoCopyWith<$Res> get cta;
}

/// @nodoc
class __$$PlanDtoImplCopyWithImpl<$Res>
    extends _$PlanDtoCopyWithImpl<$Res, _$PlanDtoImpl>
    implements _$$PlanDtoImplCopyWith<$Res> {
  __$$PlanDtoImplCopyWithImpl(
      _$PlanDtoImpl _value, $Res Function(_$PlanDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? interval = null,
    Object? features = null,
    Object? cta = null,
    Object? priceCents = null,
    Object? currency = null,
    Object? trialDays = null,
  }) {
    return _then(_$PlanDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cta: null == cta
          ? _value.cta
          : cta // ignore: cast_nullable_to_non_nullable
              as CtaDto,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      trialDays: null == trialDays
          ? _value.trialDays
          : trialDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanDtoImpl extends _PlanDto {
  const _$PlanDtoImpl(
      {required this.id,
      required this.name,
      required this.interval,
      required final List<String> features,
      required this.cta,
      @JsonKey(name: 'price_cents') required this.priceCents,
      required this.currency,
      @JsonKey(name: 'trial_days') required this.trialDays})
      : _features = features,
        super._();

  factory _$PlanDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String interval;
  final List<String> _features;
  @override
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  final CtaDto cta;
  @override
  @JsonKey(name: 'price_cents')
  final int priceCents;
  @override
  final String currency;
  @override
  @JsonKey(name: 'trial_days')
  final int trialDays;

  @override
  String toString() {
    return 'PlanDto(id: $id, name: $name, interval: $interval, features: $features, cta: $cta, priceCents: $priceCents, currency: $currency, trialDays: $trialDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.cta, cta) || other.cta == cta) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.trialDays, trialDays) ||
                other.trialDays == trialDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      interval,
      const DeepCollectionEquality().hash(_features),
      cta,
      priceCents,
      currency,
      trialDays);

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanDtoImplCopyWith<_$PlanDtoImpl> get copyWith =>
      __$$PlanDtoImplCopyWithImpl<_$PlanDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanDtoImplToJson(
      this,
    );
  }
}

abstract class _PlanDto extends PlanDto {
  const factory _PlanDto(
          {required final String id,
          required final String name,
          required final String interval,
          required final List<String> features,
          required final CtaDto cta,
          @JsonKey(name: 'price_cents') required final int priceCents,
          required final String currency,
          @JsonKey(name: 'trial_days') required final int trialDays}) =
      _$PlanDtoImpl;
  const _PlanDto._() : super._();

  factory _PlanDto.fromJson(Map<String, dynamic> json) = _$PlanDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get interval;
  @override
  List<String> get features;
  @override
  CtaDto get cta;
  @override
  @JsonKey(name: 'price_cents')
  int get priceCents;
  @override
  String get currency;
  @override
  @JsonKey(name: 'trial_days')
  int get trialDays;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanDtoImplCopyWith<_$PlanDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CtaDto _$CtaDtoFromJson(Map<String, dynamic> json) {
  return _CtaDto.fromJson(json);
}

/// @nodoc
mixin _$CtaDto {
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'button_text')
  String get buttonText => throw _privateConstructorUsedError;

  /// Serializes this CtaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CtaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CtaDtoCopyWith<CtaDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CtaDtoCopyWith<$Res> {
  factory $CtaDtoCopyWith(CtaDto value, $Res Function(CtaDto) then) =
      _$CtaDtoCopyWithImpl<$Res, CtaDto>;
  @useResult
  $Res call({String text, @JsonKey(name: 'button_text') String buttonText});
}

/// @nodoc
class _$CtaDtoCopyWithImpl<$Res, $Val extends CtaDto>
    implements $CtaDtoCopyWith<$Res> {
  _$CtaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CtaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? buttonText = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CtaDtoImplCopyWith<$Res> implements $CtaDtoCopyWith<$Res> {
  factory _$$CtaDtoImplCopyWith(
          _$CtaDtoImpl value, $Res Function(_$CtaDtoImpl) then) =
      __$$CtaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, @JsonKey(name: 'button_text') String buttonText});
}

/// @nodoc
class __$$CtaDtoImplCopyWithImpl<$Res>
    extends _$CtaDtoCopyWithImpl<$Res, _$CtaDtoImpl>
    implements _$$CtaDtoImplCopyWith<$Res> {
  __$$CtaDtoImplCopyWithImpl(
      _$CtaDtoImpl _value, $Res Function(_$CtaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CtaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? buttonText = null,
  }) {
    return _then(_$CtaDtoImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CtaDtoImpl extends _CtaDto {
  const _$CtaDtoImpl(
      {required this.text,
      @JsonKey(name: 'button_text') required this.buttonText})
      : super._();

  factory _$CtaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CtaDtoImplFromJson(json);

  @override
  final String text;
  @override
  @JsonKey(name: 'button_text')
  final String buttonText;

  @override
  String toString() {
    return 'CtaDto(text: $text, buttonText: $buttonText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CtaDtoImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.buttonText, buttonText) ||
                other.buttonText == buttonText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, buttonText);

  /// Create a copy of CtaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CtaDtoImplCopyWith<_$CtaDtoImpl> get copyWith =>
      __$$CtaDtoImplCopyWithImpl<_$CtaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CtaDtoImplToJson(
      this,
    );
  }
}

abstract class _CtaDto extends CtaDto {
  const factory _CtaDto(
          {required final String text,
          @JsonKey(name: 'button_text') required final String buttonText}) =
      _$CtaDtoImpl;
  const _CtaDto._() : super._();

  factory _CtaDto.fromJson(Map<String, dynamic> json) = _$CtaDtoImpl.fromJson;

  @override
  String get text;
  @override
  @JsonKey(name: 'button_text')
  String get buttonText;

  /// Create a copy of CtaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CtaDtoImplCopyWith<_$CtaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
