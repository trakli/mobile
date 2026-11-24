// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpaceState {
  List<SpaceEntity> get spaces => throw _privateConstructorUsedError;
  bool get canCreate => throw _privateConstructorUsedError;
  bool get hasLoadedSpaces => throw _privateConstructorUsedError;
  String? get activeSlug => throw _privateConstructorUsedError;
  SpaceOverviewEntity? get overview => throw _privateConstructorUsedError;
  List<SpaceTransactionEntity> get monthTransactions =>
      throw _privateConstructorUsedError;
  List<SpaceTransactionEntity> get latest => throw _privateConstructorUsedError;
  List<SpaceMemberEntity> get members => throw _privateConstructorUsedError;
  Map<int, List<SpaceTransactionEntity>> get budgetTransactions =>
      throw _privateConstructorUsedError;
  Map<String, SpaceOverviewEntity> get overviewsBySlug =>
      throw _privateConstructorUsedError;
  SpaceInvitationEntity? get invitation => throw _privateConstructorUsedError;
  String? get acceptedSlug => throw _privateConstructorUsedError;
  bool get invitationDeclined => throw _privateConstructorUsedError;
  bool get isLoadingSpaces => throw _privateConstructorUsedError;
  bool get isLoadingSpace => throw _privateConstructorUsedError;
  bool get isLoadingBudget => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isSharing => throw _privateConstructorUsedError;
  bool get isClosingPeriod => throw _privateConstructorUsedError;
  bool get isLoadingInvitation => throw _privateConstructorUsedError;
  bool get isRespondingInvitation => throw _privateConstructorUsedError;
  int get shareSuccessCount => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of SpaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpaceStateCopyWith<SpaceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceStateCopyWith<$Res> {
  factory $SpaceStateCopyWith(
          SpaceState value, $Res Function(SpaceState) then) =
      _$SpaceStateCopyWithImpl<$Res, SpaceState>;
  @useResult
  $Res call(
      {List<SpaceEntity> spaces,
      bool canCreate,
      bool hasLoadedSpaces,
      String? activeSlug,
      SpaceOverviewEntity? overview,
      List<SpaceTransactionEntity> monthTransactions,
      List<SpaceTransactionEntity> latest,
      List<SpaceMemberEntity> members,
      Map<int, List<SpaceTransactionEntity>> budgetTransactions,
      Map<String, SpaceOverviewEntity> overviewsBySlug,
      SpaceInvitationEntity? invitation,
      String? acceptedSlug,
      bool invitationDeclined,
      bool isLoadingSpaces,
      bool isLoadingSpace,
      bool isLoadingBudget,
      bool isCreating,
      bool isSharing,
      bool isClosingPeriod,
      bool isLoadingInvitation,
      bool isRespondingInvitation,
      int shareSuccessCount,
      Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$SpaceStateCopyWithImpl<$Res, $Val extends SpaceState>
    implements $SpaceStateCopyWith<$Res> {
  _$SpaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spaces = null,
    Object? canCreate = null,
    Object? hasLoadedSpaces = null,
    Object? activeSlug = freezed,
    Object? overview = freezed,
    Object? monthTransactions = null,
    Object? latest = null,
    Object? members = null,
    Object? budgetTransactions = null,
    Object? overviewsBySlug = null,
    Object? invitation = freezed,
    Object? acceptedSlug = freezed,
    Object? invitationDeclined = null,
    Object? isLoadingSpaces = null,
    Object? isLoadingSpace = null,
    Object? isLoadingBudget = null,
    Object? isCreating = null,
    Object? isSharing = null,
    Object? isClosingPeriod = null,
    Object? isLoadingInvitation = null,
    Object? isRespondingInvitation = null,
    Object? shareSuccessCount = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      spaces: null == spaces
          ? _value.spaces
          : spaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceEntity>,
      canCreate: null == canCreate
          ? _value.canCreate
          : canCreate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLoadedSpaces: null == hasLoadedSpaces
          ? _value.hasLoadedSpaces
          : hasLoadedSpaces // ignore: cast_nullable_to_non_nullable
              as bool,
      activeSlug: freezed == activeSlug
          ? _value.activeSlug
          : activeSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as SpaceOverviewEntity?,
      monthTransactions: null == monthTransactions
          ? _value.monthTransactions
          : monthTransactions // ignore: cast_nullable_to_non_nullable
              as List<SpaceTransactionEntity>,
      latest: null == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as List<SpaceTransactionEntity>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<SpaceMemberEntity>,
      budgetTransactions: null == budgetTransactions
          ? _value.budgetTransactions
          : budgetTransactions // ignore: cast_nullable_to_non_nullable
              as Map<int, List<SpaceTransactionEntity>>,
      overviewsBySlug: null == overviewsBySlug
          ? _value.overviewsBySlug
          : overviewsBySlug // ignore: cast_nullable_to_non_nullable
              as Map<String, SpaceOverviewEntity>,
      invitation: freezed == invitation
          ? _value.invitation
          : invitation // ignore: cast_nullable_to_non_nullable
              as SpaceInvitationEntity?,
      acceptedSlug: freezed == acceptedSlug
          ? _value.acceptedSlug
          : acceptedSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      invitationDeclined: null == invitationDeclined
          ? _value.invitationDeclined
          : invitationDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSpaces: null == isLoadingSpaces
          ? _value.isLoadingSpaces
          : isLoadingSpaces // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSpace: null == isLoadingSpace
          ? _value.isLoadingSpace
          : isLoadingSpace // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingBudget: null == isLoadingBudget
          ? _value.isLoadingBudget
          : isLoadingBudget // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharing: null == isSharing
          ? _value.isSharing
          : isSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosingPeriod: null == isClosingPeriod
          ? _value.isClosingPeriod
          : isClosingPeriod // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingInvitation: null == isLoadingInvitation
          ? _value.isLoadingInvitation
          : isLoadingInvitation // ignore: cast_nullable_to_non_nullable
              as bool,
      isRespondingInvitation: null == isRespondingInvitation
          ? _value.isRespondingInvitation
          : isRespondingInvitation // ignore: cast_nullable_to_non_nullable
              as bool,
      shareSuccessCount: null == shareSuccessCount
          ? _value.shareSuccessCount
          : shareSuccessCount // ignore: cast_nullable_to_non_nullable
              as int,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of SpaceState
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
abstract class _$$SpaceStateImplCopyWith<$Res>
    implements $SpaceStateCopyWith<$Res> {
  factory _$$SpaceStateImplCopyWith(
          _$SpaceStateImpl value, $Res Function(_$SpaceStateImpl) then) =
      __$$SpaceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SpaceEntity> spaces,
      bool canCreate,
      bool hasLoadedSpaces,
      String? activeSlug,
      SpaceOverviewEntity? overview,
      List<SpaceTransactionEntity> monthTransactions,
      List<SpaceTransactionEntity> latest,
      List<SpaceMemberEntity> members,
      Map<int, List<SpaceTransactionEntity>> budgetTransactions,
      Map<String, SpaceOverviewEntity> overviewsBySlug,
      SpaceInvitationEntity? invitation,
      String? acceptedSlug,
      bool invitationDeclined,
      bool isLoadingSpaces,
      bool isLoadingSpace,
      bool isLoadingBudget,
      bool isCreating,
      bool isSharing,
      bool isClosingPeriod,
      bool isLoadingInvitation,
      bool isRespondingInvitation,
      int shareSuccessCount,
      Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$SpaceStateImplCopyWithImpl<$Res>
    extends _$SpaceStateCopyWithImpl<$Res, _$SpaceStateImpl>
    implements _$$SpaceStateImplCopyWith<$Res> {
  __$$SpaceStateImplCopyWithImpl(
      _$SpaceStateImpl _value, $Res Function(_$SpaceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spaces = null,
    Object? canCreate = null,
    Object? hasLoadedSpaces = null,
    Object? activeSlug = freezed,
    Object? overview = freezed,
    Object? monthTransactions = null,
    Object? latest = null,
    Object? members = null,
    Object? budgetTransactions = null,
    Object? overviewsBySlug = null,
    Object? invitation = freezed,
    Object? acceptedSlug = freezed,
    Object? invitationDeclined = null,
    Object? isLoadingSpaces = null,
    Object? isLoadingSpace = null,
    Object? isLoadingBudget = null,
    Object? isCreating = null,
    Object? isSharing = null,
    Object? isClosingPeriod = null,
    Object? isLoadingInvitation = null,
    Object? isRespondingInvitation = null,
    Object? shareSuccessCount = null,
    Object? failure = null,
  }) {
    return _then(_$SpaceStateImpl(
      spaces: null == spaces
          ? _value._spaces
          : spaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceEntity>,
      canCreate: null == canCreate
          ? _value.canCreate
          : canCreate // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLoadedSpaces: null == hasLoadedSpaces
          ? _value.hasLoadedSpaces
          : hasLoadedSpaces // ignore: cast_nullable_to_non_nullable
              as bool,
      activeSlug: freezed == activeSlug
          ? _value.activeSlug
          : activeSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as SpaceOverviewEntity?,
      monthTransactions: null == monthTransactions
          ? _value._monthTransactions
          : monthTransactions // ignore: cast_nullable_to_non_nullable
              as List<SpaceTransactionEntity>,
      latest: null == latest
          ? _value._latest
          : latest // ignore: cast_nullable_to_non_nullable
              as List<SpaceTransactionEntity>,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<SpaceMemberEntity>,
      budgetTransactions: null == budgetTransactions
          ? _value._budgetTransactions
          : budgetTransactions // ignore: cast_nullable_to_non_nullable
              as Map<int, List<SpaceTransactionEntity>>,
      overviewsBySlug: null == overviewsBySlug
          ? _value._overviewsBySlug
          : overviewsBySlug // ignore: cast_nullable_to_non_nullable
              as Map<String, SpaceOverviewEntity>,
      invitation: freezed == invitation
          ? _value.invitation
          : invitation // ignore: cast_nullable_to_non_nullable
              as SpaceInvitationEntity?,
      acceptedSlug: freezed == acceptedSlug
          ? _value.acceptedSlug
          : acceptedSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      invitationDeclined: null == invitationDeclined
          ? _value.invitationDeclined
          : invitationDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSpaces: null == isLoadingSpaces
          ? _value.isLoadingSpaces
          : isLoadingSpaces // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSpace: null == isLoadingSpace
          ? _value.isLoadingSpace
          : isLoadingSpace // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingBudget: null == isLoadingBudget
          ? _value.isLoadingBudget
          : isLoadingBudget // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharing: null == isSharing
          ? _value.isSharing
          : isSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosingPeriod: null == isClosingPeriod
          ? _value.isClosingPeriod
          : isClosingPeriod // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingInvitation: null == isLoadingInvitation
          ? _value.isLoadingInvitation
          : isLoadingInvitation // ignore: cast_nullable_to_non_nullable
              as bool,
      isRespondingInvitation: null == isRespondingInvitation
          ? _value.isRespondingInvitation
          : isRespondingInvitation // ignore: cast_nullable_to_non_nullable
              as bool,
      shareSuccessCount: null == shareSuccessCount
          ? _value.shareSuccessCount
          : shareSuccessCount // ignore: cast_nullable_to_non_nullable
              as int,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$SpaceStateImpl extends _SpaceState {
  const _$SpaceStateImpl(
      {final List<SpaceEntity> spaces = const [],
      this.canCreate = false,
      this.hasLoadedSpaces = false,
      this.activeSlug,
      this.overview,
      final List<SpaceTransactionEntity> monthTransactions = const [],
      final List<SpaceTransactionEntity> latest = const [],
      final List<SpaceMemberEntity> members = const [],
      final Map<int, List<SpaceTransactionEntity>> budgetTransactions =
          const {},
      final Map<String, SpaceOverviewEntity> overviewsBySlug = const {},
      this.invitation,
      this.acceptedSlug,
      this.invitationDeclined = false,
      this.isLoadingSpaces = false,
      this.isLoadingSpace = false,
      this.isLoadingBudget = false,
      this.isCreating = false,
      this.isSharing = false,
      this.isClosingPeriod = false,
      this.isLoadingInvitation = false,
      this.isRespondingInvitation = false,
      this.shareSuccessCount = 0,
      this.failure = const Failure.none()})
      : _spaces = spaces,
        _monthTransactions = monthTransactions,
        _latest = latest,
        _members = members,
        _budgetTransactions = budgetTransactions,
        _overviewsBySlug = overviewsBySlug,
        super._();

  final List<SpaceEntity> _spaces;
  @override
  @JsonKey()
  List<SpaceEntity> get spaces {
    if (_spaces is EqualUnmodifiableListView) return _spaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spaces);
  }

  @override
  @JsonKey()
  final bool canCreate;
  @override
  @JsonKey()
  final bool hasLoadedSpaces;
  @override
  final String? activeSlug;
  @override
  final SpaceOverviewEntity? overview;
  final List<SpaceTransactionEntity> _monthTransactions;
  @override
  @JsonKey()
  List<SpaceTransactionEntity> get monthTransactions {
    if (_monthTransactions is EqualUnmodifiableListView)
      return _monthTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthTransactions);
  }

  final List<SpaceTransactionEntity> _latest;
  @override
  @JsonKey()
  List<SpaceTransactionEntity> get latest {
    if (_latest is EqualUnmodifiableListView) return _latest;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_latest);
  }

  final List<SpaceMemberEntity> _members;
  @override
  @JsonKey()
  List<SpaceMemberEntity> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final Map<int, List<SpaceTransactionEntity>> _budgetTransactions;
  @override
  @JsonKey()
  Map<int, List<SpaceTransactionEntity>> get budgetTransactions {
    if (_budgetTransactions is EqualUnmodifiableMapView)
      return _budgetTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_budgetTransactions);
  }

  final Map<String, SpaceOverviewEntity> _overviewsBySlug;
  @override
  @JsonKey()
  Map<String, SpaceOverviewEntity> get overviewsBySlug {
    if (_overviewsBySlug is EqualUnmodifiableMapView) return _overviewsBySlug;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_overviewsBySlug);
  }

  @override
  final SpaceInvitationEntity? invitation;
  @override
  final String? acceptedSlug;
  @override
  @JsonKey()
  final bool invitationDeclined;
  @override
  @JsonKey()
  final bool isLoadingSpaces;
  @override
  @JsonKey()
  final bool isLoadingSpace;
  @override
  @JsonKey()
  final bool isLoadingBudget;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isSharing;
  @override
  @JsonKey()
  final bool isClosingPeriod;
  @override
  @JsonKey()
  final bool isLoadingInvitation;
  @override
  @JsonKey()
  final bool isRespondingInvitation;
  @override
  @JsonKey()
  final int shareSuccessCount;
  @override
  @JsonKey()
  final Failure failure;

  @override
  String toString() {
    return 'SpaceState(spaces: $spaces, canCreate: $canCreate, hasLoadedSpaces: $hasLoadedSpaces, activeSlug: $activeSlug, overview: $overview, monthTransactions: $monthTransactions, latest: $latest, members: $members, budgetTransactions: $budgetTransactions, overviewsBySlug: $overviewsBySlug, invitation: $invitation, acceptedSlug: $acceptedSlug, invitationDeclined: $invitationDeclined, isLoadingSpaces: $isLoadingSpaces, isLoadingSpace: $isLoadingSpace, isLoadingBudget: $isLoadingBudget, isCreating: $isCreating, isSharing: $isSharing, isClosingPeriod: $isClosingPeriod, isLoadingInvitation: $isLoadingInvitation, isRespondingInvitation: $isRespondingInvitation, shareSuccessCount: $shareSuccessCount, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceStateImpl &&
            const DeepCollectionEquality().equals(other._spaces, _spaces) &&
            (identical(other.canCreate, canCreate) ||
                other.canCreate == canCreate) &&
            (identical(other.hasLoadedSpaces, hasLoadedSpaces) ||
                other.hasLoadedSpaces == hasLoadedSpaces) &&
            (identical(other.activeSlug, activeSlug) ||
                other.activeSlug == activeSlug) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            const DeepCollectionEquality()
                .equals(other._monthTransactions, _monthTransactions) &&
            const DeepCollectionEquality().equals(other._latest, _latest) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._budgetTransactions, _budgetTransactions) &&
            const DeepCollectionEquality()
                .equals(other._overviewsBySlug, _overviewsBySlug) &&
            (identical(other.invitation, invitation) ||
                other.invitation == invitation) &&
            (identical(other.acceptedSlug, acceptedSlug) ||
                other.acceptedSlug == acceptedSlug) &&
            (identical(other.invitationDeclined, invitationDeclined) ||
                other.invitationDeclined == invitationDeclined) &&
            (identical(other.isLoadingSpaces, isLoadingSpaces) ||
                other.isLoadingSpaces == isLoadingSpaces) &&
            (identical(other.isLoadingSpace, isLoadingSpace) ||
                other.isLoadingSpace == isLoadingSpace) &&
            (identical(other.isLoadingBudget, isLoadingBudget) ||
                other.isLoadingBudget == isLoadingBudget) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isSharing, isSharing) ||
                other.isSharing == isSharing) &&
            (identical(other.isClosingPeriod, isClosingPeriod) ||
                other.isClosingPeriod == isClosingPeriod) &&
            (identical(other.isLoadingInvitation, isLoadingInvitation) ||
                other.isLoadingInvitation == isLoadingInvitation) &&
            (identical(other.isRespondingInvitation, isRespondingInvitation) ||
                other.isRespondingInvitation == isRespondingInvitation) &&
            (identical(other.shareSuccessCount, shareSuccessCount) ||
                other.shareSuccessCount == shareSuccessCount) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_spaces),
        canCreate,
        hasLoadedSpaces,
        activeSlug,
        overview,
        const DeepCollectionEquality().hash(_monthTransactions),
        const DeepCollectionEquality().hash(_latest),
        const DeepCollectionEquality().hash(_members),
        const DeepCollectionEquality().hash(_budgetTransactions),
        const DeepCollectionEquality().hash(_overviewsBySlug),
        invitation,
        acceptedSlug,
        invitationDeclined,
        isLoadingSpaces,
        isLoadingSpace,
        isLoadingBudget,
        isCreating,
        isSharing,
        isClosingPeriod,
        isLoadingInvitation,
        isRespondingInvitation,
        shareSuccessCount,
        failure
      ]);

  /// Create a copy of SpaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceStateImplCopyWith<_$SpaceStateImpl> get copyWith =>
      __$$SpaceStateImplCopyWithImpl<_$SpaceStateImpl>(this, _$identity);
}

abstract class _SpaceState extends SpaceState {
  const factory _SpaceState(
      {final List<SpaceEntity> spaces,
      final bool canCreate,
      final bool hasLoadedSpaces,
      final String? activeSlug,
      final SpaceOverviewEntity? overview,
      final List<SpaceTransactionEntity> monthTransactions,
      final List<SpaceTransactionEntity> latest,
      final List<SpaceMemberEntity> members,
      final Map<int, List<SpaceTransactionEntity>> budgetTransactions,
      final Map<String, SpaceOverviewEntity> overviewsBySlug,
      final SpaceInvitationEntity? invitation,
      final String? acceptedSlug,
      final bool invitationDeclined,
      final bool isLoadingSpaces,
      final bool isLoadingSpace,
      final bool isLoadingBudget,
      final bool isCreating,
      final bool isSharing,
      final bool isClosingPeriod,
      final bool isLoadingInvitation,
      final bool isRespondingInvitation,
      final int shareSuccessCount,
      final Failure failure}) = _$SpaceStateImpl;
  const _SpaceState._() : super._();

  @override
  List<SpaceEntity> get spaces;
  @override
  bool get canCreate;
  @override
  bool get hasLoadedSpaces;
  @override
  String? get activeSlug;
  @override
  SpaceOverviewEntity? get overview;
  @override
  List<SpaceTransactionEntity> get monthTransactions;
  @override
  List<SpaceTransactionEntity> get latest;
  @override
  List<SpaceMemberEntity> get members;
  @override
  Map<int, List<SpaceTransactionEntity>> get budgetTransactions;
  @override
  Map<String, SpaceOverviewEntity> get overviewsBySlug;
  @override
  SpaceInvitationEntity? get invitation;
  @override
  String? get acceptedSlug;
  @override
  bool get invitationDeclined;
  @override
  bool get isLoadingSpaces;
  @override
  bool get isLoadingSpace;
  @override
  bool get isLoadingBudget;
  @override
  bool get isCreating;
  @override
  bool get isSharing;
  @override
  bool get isClosingPeriod;
  @override
  bool get isLoadingInvitation;
  @override
  bool get isRespondingInvitation;
  @override
  int get shareSuccessCount;
  @override
  Failure get failure;

  /// Create a copy of SpaceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpaceStateImplCopyWith<_$SpaceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
