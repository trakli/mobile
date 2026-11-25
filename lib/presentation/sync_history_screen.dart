import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/data/datasources/core/name_matching.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class SyncHistoryScreen extends StatefulWidget {
  const SyncHistoryScreen({super.key});

  @override
  State<SyncHistoryScreen> createState() => _SyncHistoryScreenState();
}

class _SyncHistoryScreenState extends State<SyncHistoryScreen> {
  final AppDatabase _db = getIt<AppDatabase>();
  final SynchAppDatabase _syncDb = getIt<SynchAppDatabase>();

  List<LocalSyncMetadata> _syncMetadata = [];
  List<LocalChange> _pendingChanges = [];
  List<LocalChange> _failedChanges = [];
  List<LocalChange> _quarantinedChanges = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _syncDb.syncStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isSyncing = state.isSynchronizing;
        });
        if (!state.isSynchronizing) {
          _loadData();
        }
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final savedMetadata = await _db.getLocalSyncMetadataList();
      final metadataByType = {
        for (final item in savedMetadata) item.entityType: item,
      };
      final metadata = _syncDb.typeHandlers
          .where((handler) => !handler.skipDownSync)
          .map((handler) =>
              metadataByType[handler.entityType] ??
              LocalSyncMetadata(entityType: handler.entityType))
          .toList()
        ..sort((a, b) => a.entityType.compareTo(b.entityType));
      final allChanges = await _db.select(_db.localChanges).get();

      // Quarantined changes are permanently failed and never retry
      // automatically; keep them out of the transient "failed" bucket.
      final pending = allChanges
          .where((c) => c.error == null && c.quarantinedAt == null)
          .toList();
      final failed = allChanges
          .where((c) => c.error != null && c.quarantinedAt == null)
          .toList();
      final quarantined =
          allChanges.where((c) => c.quarantinedAt != null).toList();

      if (mounted) {
        setState(() {
          _syncMetadata = metadata;
          _pendingChanges = pending;
          _failedChanges = failed;
          _quarantinedChanges = quarantined;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Error loading sync data: $e\n$st');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _triggerSync() async {
    setState(() => _isSyncing = true);
    try {
      await _syncDb.sync();
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
        _loadData();
      }
    }
  }

  Future<void> _retryFailedChange(LocalChange change) async {
    await (_db.update(_db.localChanges)
          ..where((lc) =>
              lc.entityType.equals(change.entityType) &
              lc.entityId.equals(change.entityId)))
        .write(const LocalChangesCompanion(error: Value(null)));
    _loadData();
    _triggerSync();
  }

  /// Un-quarantine: clear the error, lift quarantine, and reset the attempt
  /// counter so the change re-enters the normal retry path immediately.
  Future<void> _retryQuarantinedChange(LocalChange change) async {
    await (_db.update(_db.localChanges)
          ..where((lc) =>
              lc.entityType.equals(change.entityType) &
              lc.entityId.equals(change.entityId)))
        .write(const LocalChangesCompanion(
      error: Value(null),
      quarantinedAt: Value(null),
      attemptCount: Value(0),
    ));
    _loadData();
    _triggerSync();
  }

  /// A category the API rejected as a duplicate can never sync, and it holds
  /// up every transaction tagged with it. Fold it into the copy the server did
  /// accept — matched on name the way the API compares them, ignoring case and
  /// surrounding spaces.
  Future<void> _mergeDuplicateCategory(LocalChange change) async {
    final duplicate = await (_db.select(_db.categories)
          ..where((c) => c.clientId.equals(change.entityId)))
        .getSingleOrNull();
    if (duplicate == null) {
      _showMessage('That category is no longer on this device.');
      return;
    }

    final synced = await (_db.select(_db.categories)
          ..where((c) =>
              c.clientId.isNotValue(duplicate.clientId) & c.id.isNotNull()))
        .get();
    final winner = firstMatchingName(
      synced,
      duplicate.name,
      nameOf: (row) => row.name,
      clientIdOf: (row) => row.clientId,
    );
    if (winner == null) {
      _showMessage(
        'No synced category named "${duplicate.name.trim()}" to merge into. '
        'Sync once more, then try again.',
      );
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Merge duplicate category'),
        content: Text(
          '"${duplicate.name}" was rejected by the server as a duplicate of '
          '"${winner.name}".\n\n'
          'Everything tagged with it will be re-tagged to "${winner.name}", '
          'and the duplicate will be removed from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Merge'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final retagged = await _db.mergeDuplicateCategory(
        loserClientId: duplicate.clientId,
        winnerClientId: winner.clientId,
      );
      _showMessage(retagged == 0
          ? 'Merged into "${winner.name}".'
          : 'Merged into "${winner.name}" — $retagged re-tagged.');
      await _loadData();
      await _triggerSync();
    } catch (e) {
      _showMessage('Could not merge: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return LocaleKeys.notSet.tr();
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime.toLocal());
  }

  String _getEntityTypeDisplayName(String entityType) {
    switch (entityType) {
      case 'transaction':
        return LocaleKeys.transaction.tr();
      case 'category':
        return LocaleKeys.category.tr();
      case 'wallet':
        return LocaleKeys.wallet.tr();
      case 'party':
        return LocaleKeys.party.tr();
      case 'group':
        return LocaleKeys.group.tr();
      case 'transfer':
        return LocaleKeys.transfer.tr();
      case 'budget':
        return LocaleKeys.budget.tr();
      case 'budget_period_state':
        return LocaleKeys.budgetPeriod.tr();
      case 'notification':
        return LocaleKeys.notifications.tr();
      case 'reminder':
        return LocaleKeys.reminders.tr();
      case 'config':
        return LocaleKeys.settings.tr();
      default:
        return entityType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.synchronization.tr(),
        actions: [
          _isSyncing
              ? SizedBox(
                  width: 32.lx,
                  height: 32.lx,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : PageAppBarAction(
                  icon: LucideIcons.refreshCw,
                  tooltip: LocaleKeys.syncNow.tr(),
                  primary: true,
                  onTap: _triggerSync,
                ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                children: [
                  if (_quarantinedChanges.isNotEmpty) ...[
                    _buildQuarantinedSection(),
                    SizedBox(height: 16.lx),
                  ],
                  _buildSyncStatusSection(),
                  SizedBox(height: 16.lx),
                  _buildPendingChangesSection(),
                  SizedBox(height: 16.lx),
                  _buildFailedChangesSection(),
                ],
              ),
            ),
    );
  }

  Widget _section({
    required String title,
    int? count,
    LedgerChipTone tone = LedgerChipTone.neutral,
    String? hint,
    required String empty,
    required List<Widget> rows,
  }) {
    final t = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LedgerH6(
          title,
          trailing: count == null || count == 0
              ? null
              : LedgerChip('$count', tone: tone),
        ),
        if (hint != null) ...[
          SizedBox(height: 4.lx),
          Text(hint, style: TextStyle(fontSize: 11.5.lx, color: t.textMuted)),
        ],
        SizedBox(height: 6.lx),
        LedgerCard(
          padding: EdgeInsets.symmetric(horizontal: 12.lx),
          child: rows.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.lx),
                  child: Text(
                    empty,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                  ),
                )
              : Column(children: rows),
        ),
      ],
    );
  }

  Widget _changeMenu(
    LocalChange change, {
    required VoidCallback onRetry,
    VoidCallback? onMerge,
  }) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(
        LucideIcons.ellipsisVertical,
        size: 16.lx,
        color: context.tones.textMuted,
      ),
      onSelected: (v) {
        if (v == 'details') _showChangeDetails(change);
        if (v == 'merge') onMerge?.call();
        if (v == 'retry') onRetry();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'details',
          child: Text(LocaleKeys.syncViewDetails.tr()),
        ),
        if (onMerge != null)
          PopupMenuItem(
            value: 'merge',
            child: Text(LocaleKeys.syncMergeDuplicate.tr()),
          ),
        PopupMenuItem(value: 'retry', child: Text(LocaleKeys.retry.tr())),
      ],
    );
  }

  Widget _errorText(String text, Color color, {int lines = 2}) => Text(
        text,
        maxLines: lines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 11.5.lx, color: color),
      );

  Widget _buildSyncStatusSection() {
    final t = context.tones;
    return _section(
      title: LocaleKeys.lastSyncStatus.tr(),
      empty: LocaleKeys.noSyncHistory.tr(),
      rows: [
        for (final meta in _syncMetadata)
          LedgerRow(
            title: _getEntityTypeDisplayName(meta.entityType),
            subtitleWidget: meta.lastError == null
                ? null
                : _errorText(meta.lastError!, t.expenseColor, lines: 1),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDateTime(meta.lastAttemptedAt),
                  style: LedgerText.money(size: 11.lx, color: t.textMuted),
                ),
                if (meta.lastError != null) ...[
                  SizedBox(width: 6.lx),
                  Icon(
                    LucideIcons.circleAlert,
                    size: 15.lx,
                    color: t.expenseColor,
                  ),
                ],
              ],
            ),
            divider: meta != _syncMetadata.last,
            onTap: meta.lastError == null
                ? null
                : () => _showModelSyncError(meta, meta.lastError!),
          ),
      ],
    );
  }

  Widget _buildPendingChangesSection() {
    final t = context.tones;
    return _section(
      title: LocaleKeys.pendingChanges.tr(),
      count: _pendingChanges.length,
      empty: LocaleKeys.noPendingChanges.tr(),
      rows: [
        for (final change in _pendingChanges)
          LedgerRow(
            leading: Icon(
              change.deleted ? LucideIcons.trash2 : LucideIcons.upload,
              size: 16.lx,
              color: change.deleted ? t.expenseColor : t.textSecondary,
            ),
            title: _getEntityTypeDisplayName(change.entityType),
            trailing: Text(
              _formatDateTime(change.createAt),
              style: LedgerText.money(size: 11.lx, color: t.textMuted),
            ),
            divider: change != _pendingChanges.last,
          ),
      ],
    );
  }

  /// Full error text plus the queued request payload, so validation
  /// failures show exactly what the server received.
  /// Down-sync failures have no queued change to inspect, so the error is
  /// only recoverable from the model's sync metadata.
  void _showModelSyncError(LocalSyncMetadata meta, String error) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getEntityTypeDisplayName(meta.entityType)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${LocaleKeys.lastAttempted.tr()}: '
                  '${_formatDateTime(meta.lastAttemptedAt)}',
                  style: TextStyle(
                    fontSize: 12.lx,
                    color: context.tones.textMuted,
                  ),
                ),
                SizedBox(height: 12.lx),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.lx),
                  decoration: BoxDecoration(
                    color: context.tones.surface2,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: SelectableText(
                    error,
                    style: LedgerText.money(
                      size: 11.lx,
                      color: context.tones.expenseColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.done.tr()),
          ),
        ],
      ),
    );
  }

  void _showChangeDetails(LocalChange change) {
    final payload = const JsonEncoder.withIndent('  ').convert(change.data);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getEntityTypeDisplayName(change.entityType)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (change.error != null) ...[
                  SelectableText(
                    change.error!,
                    style: TextStyle(
                        fontSize: 12.lx, color: context.tones.expenseColor),
                  ),
                  SizedBox(height: 12.lx),
                ],
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.lx),
                  decoration: BoxDecoration(
                    color: context.tones.surface2,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: SelectableText(
                    payload,
                    style: LedgerText.money(
                      size: 11.lx,
                      color: context.tones.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.done.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarantinedSection() {
    final t = context.tones;
    return _section(
      title: LocaleKeys.needsAttention.tr(),
      count: _quarantinedChanges.length,
      tone: LedgerChipTone.warm,
      hint: LocaleKeys.quarantinedHint.tr(),
      empty: '',
      rows: [
        for (final change in _quarantinedChanges)
          LedgerRow(
            leading: Icon(
              LucideIcons.triangleAlert,
              size: 16.lx,
              color: t.accentWarm,
            ),
            title: _getEntityTypeDisplayName(change.entityType),
            subtitleWidget: _errorText(change.error ?? '', t.accentWarm),
            trailing: _changeMenu(
              change,
              onRetry: () => _retryQuarantinedChange(change),
              onMerge: change.entityType == 'category'
                  ? () => _mergeDuplicateCategory(change)
                  : null,
            ),
            divider: change != _quarantinedChanges.last,
          ),
      ],
    );
  }

  Widget _buildFailedChangesSection() {
    final t = context.tones;
    return _section(
      title: LocaleKeys.failedChanges.tr(),
      count: _failedChanges.length,
      tone: LedgerChipTone.bad,
      empty: LocaleKeys.noFailedChanges.tr(),
      rows: [
        for (final change in _failedChanges)
          LedgerRow(
            leading: Icon(
              LucideIcons.circleX,
              size: 16.lx,
              color: t.expenseColor,
            ),
            title: _getEntityTypeDisplayName(change.entityType),
            subtitleWidget: _errorText(change.error ?? '', t.expenseColor),
            trailing: _changeMenu(
              change,
              onRetry: () => _retryFailedChange(change),
            ),
            divider: change != _failedChanges.last,
          ),
      ],
    );
  }
}
