import 'package:trakli/domain/entities/space/space_entity.dart';

double _num(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

int _int(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

DateTime? _date(dynamic v) {
  if (v is! String || v.isEmpty) return null;
  return DateTime.tryParse(v);
}

List<int> _ints(dynamic v) =>
    v is List ? v.map(_int).toList() : const <int>[];

List<Map<String, dynamic>> _maps(dynamic v) => v is List
    ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : const [];

class SpaceDto {
  final Map<String, dynamic> json;
  const SpaceDto(this.json);

  factory SpaceDto.fromJson(Map<String, dynamic> json) => SpaceDto(json);

  SpaceEntity toEntity() {
    final role = switch (json['role']) {
      'owner' => SpaceRole.owner,
      'admin' => SpaceRole.admin,
      _ => SpaceRole.member,
    };
    return SpaceEntity(
      id: _int(json['id']),
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description'] as String?,
      role: role,
      readOnly: json['read_only'] == true,
      canManage: json['can_manage'] == true,
      memberCount: _int(json['member_count']),
    );
  }
}

class SpaceListDto {
  final List<SpaceDto> spaces;
  final bool canCreate;

  const SpaceListDto({required this.spaces, required this.canCreate});

  factory SpaceListDto.fromJson(Map<String, dynamic> json) => SpaceListDto(
        spaces: _maps(json['data']).map(SpaceDto.fromJson).toList(),
        canCreate: json['can_create'] == true,
      );

  SpaceListEntity toEntity() => SpaceListEntity(
        spaces: spaces.map((s) => s.toEntity()).toList(),
        canCreate: canCreate,
      );
}

class SpaceBudgetDto {
  final Map<String, dynamic> json;
  const SpaceBudgetDto(this.json);

  SpaceBudgetEntity toEntity() {
    final p = json['progress'];
    SpaceBudgetProgressEntity? progress;
    if (p is Map) {
      final m = Map<String, dynamic>.from(p);
      final start = _date(m['period_start']);
      final end = _date(m['period_end']);
      if (start != null && end != null) {
        progress = SpaceBudgetProgressEntity(
          periodStart: start,
          periodEnd: end,
          limit: _num(m['limit']),
          netSpent: _num(m['net_spent']),
          effectiveLimit: _num(m['effective_limit']),
          remaining: _num(m['remaining']),
          percentUsed: _num(m['percent_used']),
          projectedSpend: _num(m['projected_spend']),
          status: m['status']?.toString() ?? '',
        );
      }
    }
    return SpaceBudgetEntity(
      id: _int(json['id']),
      name: json['name']?.toString() ?? '',
      amount: _num(json['amount']),
      currency: json['currency']?.toString() ?? '',
      periodType: json['period_type']?.toString() ?? 'monthly',
      rolloverEnabled: json['rollover_enabled'] == true,
      isActive: json['is_active'] != false,
      categoryIds: _maps(json['targets'])
          .where((t) => t['type'] == 'category')
          .map((t) => _int(t['id']))
          .toList(),
      progress: progress,
    );
  }
}

class SpaceOverviewDto {
  final Map<String, dynamic> json;
  const SpaceOverviewDto(this.json);

  factory SpaceOverviewDto.fromJson(Map<String, dynamic> json) =>
      SpaceOverviewDto(json);

  SpaceOverviewEntity toEntity() {
    SpaceLabelEntity label(Map<String, dynamic> m) => SpaceLabelEntity(
          id: _int(m['id']),
          name: m['name']?.toString() ?? '',
          type: m['type'] as String?,
        );
    return SpaceOverviewEntity(
      wallets: _maps(json['wallets'])
          .map((m) => SpaceWalletEntity(
                id: _int(m['id']),
                name: m['name']?.toString() ?? '',
                type: m['type']?.toString() ?? '',
                currency: m['currency']?.toString() ?? '',
                balance: _num(m['balance']),
                isShared: m['source'] == 'shared_wallet',
              ))
          .toList(),
      budgets: _maps(json['budgets'])
          .map((m) => SpaceBudgetDto(m).toEntity())
          .toList(),
      categories: _maps(json['categories']).map(label).toList(),
      groups: _maps(json['groups']).map(label).toList(),
      totals: _maps(json['totals'])
          .map((m) => SpaceTotalEntity(
                currency: m['currency']?.toString() ?? '',
                income: _num(m['income']),
                expenses: _num(m['expenses']),
              ))
          .toList(),
    );
  }
}

class SpaceTransactionDto {
  final Map<String, dynamic> json;
  const SpaceTransactionDto(this.json);

  factory SpaceTransactionDto.fromJson(Map<String, dynamic> json) =>
      SpaceTransactionDto(json);

  SpaceTransactionEntity toEntity() {
    final source = switch (json['source']) {
      'shared_wallet' => SpaceTransactionSource.sharedWallet,
      'shared_transaction' => SpaceTransactionSource.sharedTransaction,
      _ => SpaceTransactionSource.workspace,
    };
    return SpaceTransactionEntity(
      id: _int(json['id']),
      amount: _num(json['amount']),
      isIncome: json['type'] == 'income',
      datetime: (_date(json['datetime']) ?? DateTime.now()).toLocal(),
      description: json['description'] as String?,
      currency: json['currency']?.toString() ?? '',
      walletName: json['wallet_name'] as String?,
      contributor: json['contributor']?.toString().trim() ?? '',
      source: source,
      canEdit: json['can_edit'] == true,
      canUnshare: json['can_unshare'] == true,
      isRefund: json['is_refund'] == true,
      categoryIds: _ints(json['category_ids']),
      groupIds: _ints(json['group_ids']),
    );
  }
}

class SpacePageDto {
  static SpacePage<SpaceTransactionEntity> transactions(
    Map<String, dynamic> json,
  ) {
    return SpacePage(
      items: _maps(json['data'])
          .map((m) => SpaceTransactionDto(m).toEntity())
          .toList(),
      currentPage: _int(json['current_page']),
      lastPage: _int(json['last_page']),
      total: _int(json['total']),
    );
  }
}

class SpaceMemberDto {
  static SpaceMemberEntity fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString().trim();
    return SpaceMemberEntity(
      userId: _int(json['user_id']),
      name: name == null || name.isEmpty ? null : name,
      role: json['role']?.toString() ?? 'member',
    );
  }
}

class SpaceInvitationDto {
  static SpaceInvitationEntity fromJson(Map<String, dynamic> json) {
    final ws = json['workspace'] is Map
        ? Map<String, dynamic>.from(json['workspace'] as Map)
        : const <String, dynamic>{};
    final status = switch (json['status']) {
      'pending' => SpaceInvitationStatus.pending,
      'accepted' => SpaceInvitationStatus.accepted,
      'declined' => SpaceInvitationStatus.declined,
      'expired' => SpaceInvitationStatus.expired,
      _ => SpaceInvitationStatus.unknown,
    };
    return SpaceInvitationEntity(
      workspaceName: ws['name']?.toString() ?? '',
      workspaceSlug: ws['slug']?.toString() ?? '',
      role: json['role']?.toString() ?? 'member',
      invitedBy: json['invited_by']?.toString(),
      status: status,
      expiresAt: _date(json['expires_at']),
    );
  }

  static SpaceInvitationResult acceptedFromJson(Map<String, dynamic> json) {
    final ws = json['workspace'] is Map
        ? Map<String, dynamic>.from(json['workspace'] as Map)
        : const <String, dynamic>{};
    return SpaceInvitationResult(
      workspaceSlug: ws['slug']?.toString() ?? '',
      workspaceName: ws['name']?.toString() ?? '',
    );
  }
}
