import 'package:equatable/equatable.dart';

enum SpaceRole { owner, admin, member }

class SpaceEntity extends Equatable {
  final int id;
  final String slug;
  final String name;
  final String? description;
  final SpaceRole role;

  /// True when the space's plan no longer allows changes. Reads still work.
  final bool readOnly;
  final bool canManage;
  final int memberCount;

  const SpaceEntity({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    required this.role,
    required this.readOnly,
    required this.canManage,
    required this.memberCount,
  });

  bool get canWrite => !readOnly;

  @override
  List<Object?> get props =>
      [id, slug, name, description, role, readOnly, canManage, memberCount];
}

class SpaceListEntity extends Equatable {
  final List<SpaceEntity> spaces;
  final bool canCreate;

  const SpaceListEntity({required this.spaces, required this.canCreate});

  @override
  List<Object?> get props => [spaces, canCreate];
}

class SpaceWalletEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String currency;
  final double balance;
  final bool isShared;

  const SpaceWalletEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.balance,
    required this.isShared,
  });

  @override
  List<Object?> get props => [id, name, type, currency, balance, isShared];
}

class SpaceBudgetProgressEntity extends Equatable {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double limit;
  final double netSpent;
  final double effectiveLimit;
  final double remaining;
  final double percentUsed;
  final double projectedSpend;
  final String status;

  const SpaceBudgetProgressEntity({
    required this.periodStart,
    required this.periodEnd,
    required this.limit,
    required this.netSpent,
    required this.effectiveLimit,
    required this.remaining,
    required this.percentUsed,
    required this.projectedSpend,
    required this.status,
  });

  @override
  List<Object?> get props => [
        periodStart,
        periodEnd,
        limit,
        netSpent,
        effectiveLimit,
        remaining,
        percentUsed,
        projectedSpend,
        status,
      ];
}

class SpaceBudgetEntity extends Equatable {
  final int id;
  final String name;
  final double amount;
  final String currency;
  final String periodType;
  final bool rolloverEnabled;
  final bool isActive;
  final List<int> categoryIds;
  final SpaceBudgetProgressEntity? progress;

  const SpaceBudgetEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.periodType,
    required this.rolloverEnabled,
    required this.isActive,
    this.categoryIds = const [],
    this.progress,
  });

  double get spent => progress?.netSpent ?? 0;
  double get limit => progress?.effectiveLimit ?? amount;
  double get remaining => progress?.remaining ?? (amount - spent);

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        currency,
        periodType,
        rolloverEnabled,
        isActive,
        categoryIds,
        progress,
      ];
}

class SpaceLabelEntity extends Equatable {
  final int id;
  final String name;
  final String? type;

  const SpaceLabelEntity({required this.id, required this.name, this.type});

  @override
  List<Object?> get props => [id, name, type];
}

class SpaceTotalEntity extends Equatable {
  final String currency;
  final double income;
  final double expenses;

  const SpaceTotalEntity({
    required this.currency,
    required this.income,
    required this.expenses,
  });

  @override
  List<Object?> get props => [currency, income, expenses];
}

class SpaceOverviewEntity extends Equatable {
  final List<SpaceWalletEntity> wallets;
  final List<SpaceBudgetEntity> budgets;
  final List<SpaceLabelEntity> categories;
  final List<SpaceLabelEntity> groups;
  final List<SpaceTotalEntity> totals;

  const SpaceOverviewEntity({
    this.wallets = const [],
    this.budgets = const [],
    this.categories = const [],
    this.groups = const [],
    this.totals = const [],
  });

  SpaceLabelEntity? categoryById(int id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  List<Object?> get props => [wallets, budgets, categories, groups, totals];
}

enum SpaceTransactionSource { workspace, sharedWallet, sharedTransaction }

class SpaceTransactionEntity extends Equatable {
  final int id;
  final double amount;
  final bool isIncome;
  final DateTime datetime;
  final String? description;
  final String currency;
  final String? walletName;

  /// Display name of the member who recorded it. Empty when the member has
  /// not set a name.
  final String contributor;
  final SpaceTransactionSource source;
  final bool canEdit;
  final bool canUnshare;
  final bool isRefund;
  final List<int> categoryIds;
  final List<int> groupIds;

  const SpaceTransactionEntity({
    required this.id,
    required this.amount,
    required this.isIncome,
    required this.datetime,
    this.description,
    required this.currency,
    this.walletName,
    required this.contributor,
    required this.source,
    required this.canEdit,
    required this.canUnshare,
    required this.isRefund,
    this.categoryIds = const [],
    this.groupIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        isIncome,
        datetime,
        description,
        currency,
        walletName,
        contributor,
        source,
        canEdit,
        canUnshare,
        isRefund,
        categoryIds,
        groupIds,
      ];
}

class SpacePage<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const SpacePage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}

class SpaceMemberEntity extends Equatable {
  final int userId;
  final String? name;
  final String role;

  const SpaceMemberEntity({
    required this.userId,
    this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, name, role];
}

enum SpaceInvitationStatus { pending, accepted, declined, expired, unknown }

class SpaceInvitationEntity extends Equatable {
  final String workspaceName;
  final String workspaceSlug;
  final String role;
  final String? invitedBy;
  final SpaceInvitationStatus status;
  final DateTime? expiresAt;

  const SpaceInvitationEntity({
    required this.workspaceName,
    required this.workspaceSlug,
    required this.role,
    this.invitedBy,
    required this.status,
    this.expiresAt,
  });

  @override
  List<Object?> get props =>
      [workspaceName, workspaceSlug, role, invitedBy, status, expiresAt];
}

class SpaceInvitationResult extends Equatable {
  final String workspaceSlug;
  final String workspaceName;

  const SpaceInvitationResult({
    required this.workspaceSlug,
    required this.workspaceName,
  });

  @override
  List<Object?> get props => [workspaceSlug, workspaceName];
}
