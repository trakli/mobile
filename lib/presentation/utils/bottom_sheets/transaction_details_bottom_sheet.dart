import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/share_to_space_sheet.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/path_helper.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_view.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/transfer_counterpart_wallet.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class TransactionDetailsBottomSheet extends StatefulWidget {
  const TransactionDetailsBottomSheet({
    super.key,
    required this.transaction,
    required this.accentColor,
    required this.onDelete,
    required this.onEdit,
    this.hideActions = false,
  });

  final TransactionCompleteEntity transaction;
  final Color accentColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool hideActions;

  @override
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  /// 0 = Images, 1 = Files
  int _selectedAttachmentTab = 0;

  /// Description of the expense this refund reimburses, if resolvable locally.
  String? _refundOriginalLabel(BuildContext context) {
    final txn = widget.transaction.transaction;
    if (!txn.isRefund || txn.refundOfTransactionId == null) return null;
    final original =
        context.watch<TransactionCubit>().state.transactions.firstWhereOrNull(
              (t) => t.transaction.id == txn.refundOfTransactionId,
            );
    if (original == null) return null;
    return original.transaction.description.isNotEmpty
        ? original.transaction.description
        : LocaleKeys.noDescription.tr();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final transfers = context.watch<TransferCubit>().state.transfers;
    final counterpart = transferCounterpartWalletFor(
      widget.transaction,
      transfers,
      wallets,
    );

    final complete = widget.transaction;
    final transaction = complete.transaction;
    final categories = complete.categories;
    final party = complete.party;
    final wallet = complete.wallet;
    final isTransfer = transaction.isTransferLeg;
    final isIncome = transaction.type == TransactionType.income;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final category = categories.isEmpty ? null : categories.first;
    final title = transaction.description.trim().isNotEmpty
        ? transaction.description.trim()
        : (category?.name ?? party?.name ?? LocaleKeys.noDescription.tr());
    final refundOf = _refundOriginalLabel(context);
    final amountColor = isTransfer
        ? t.textPrimary
        : (isIncome ? t.incomeColor : t.expenseColor);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14.lx,
          10.lx,
          14.lx,
          14.lx + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 12.lx),
              Row(
                children: [
                  LedgerCoin(
                    media: category?.icon,
                    icon: isTransfer
                        ? LucideIcons.arrowLeftRight
                        : (category == null
                            ? (isIncome
                                ? LucideIcons.arrowDownLeft
                                : LucideIcons.arrowUpRight)
                            : null),
                  ),
                  SizedBox(width: 10.lx),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.lx,
                        fontWeight: FontWeight.w600,
                        color: t.textPrimary,
                      ),
                    ),
                  ),
                  LedgerIconButton(
                    icon: LucideIcons.x,
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 14.lx),
              LedgerBigNumber(
                ledgerSignedAmount(complete),
                color: amountColor,
              ),
              if (transaction.isRefund ||
                  transaction.recurrencePeriod != null) ...[
                SizedBox(height: 8.lx),
                Wrap(
                  spacing: 6.lx,
                  runSpacing: 4.lx,
                  children: [
                    if (transaction.isRefund)
                      LedgerChip(
                        LocaleKeys.refund.tr(),
                        icon: LucideIcons.undo2,
                        tone: LedgerChipTone.good,
                      ),
                    if (transaction.recurrencePeriod != null)
                      LedgerChip(
                        _recurrencePeriodLabel(transaction.recurrencePeriod!),
                        icon: LucideIcons.repeat,
                      ),
                  ],
                ),
              ],
              if (refundOf != null) ...[
                SizedBox(height: 6.lx),
                Text(
                  '${LocaleKeys.refundOf.tr()}: $refundOf',
                  style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                ),
              ],
              SizedBox(height: 14.lx),
              LedgerCard(
                padding: EdgeInsets.symmetric(horizontal: 12.lx),
                child: Column(
                  children: [
                    if (isTransfer) ...[
                      _Field(
                        icon: LucideIcons.wallet,
                        label: LocaleKeys.from.tr(),
                        value:
                            isIncome ? (counterpart?.name ?? '') : wallet.name,
                      ),
                      _Field(
                        icon: LucideIcons.wallet,
                        label: LocaleKeys.to.tr(),
                        value:
                            isIncome ? wallet.name : (counterpart?.name ?? ''),
                      ),
                    ] else ...[
                      _Field(
                        icon: LucideIcons.wallet,
                        label: LocaleKeys.wallet.tr(),
                        value: wallet.name,
                      ),
                      if (party != null)
                        _Field(
                          icon: LucideIcons.userRound,
                          label: isIncome
                              ? LocaleKeys.from.tr()
                              : LocaleKeys.to.tr(),
                          value: party.name,
                        ),
                      _Field(
                        icon: LucideIcons.tag,
                        label: LocaleKeys.category.tr(),
                        value: categories.isEmpty
                            ? LocaleKeys.none.tr()
                            : categories.map((c) => c.name).join(', '),
                        muted: categories.isEmpty,
                      ),
                    ],
                    _Field(
                      icon: LucideIcons.folder,
                      label: LocaleKeys.group.tr(),
                      value: complete.group?.name ?? LocaleKeys.none.tr(),
                      muted: complete.group == null,
                    ),
                    _Field(
                      icon: LucideIcons.calendar,
                      label: LocaleKeys.txFormWhen.tr(),
                      value: DateFormat('EEE, MMM d, y · HH:mm', locale)
                          .format(transaction.datetime.toLocal()),
                      divider: false,
                    ),
                  ],
                ),
              ),
              if (complete.files.isNotEmpty) ...[
                SizedBox(height: 14.lx),
                LedgerH6(LocaleKeys.attachment.tr()),
                SizedBox(height: 6.lx),
                Row(
                  children: [
                    _AttachmentTab(
                      label: LocaleKeys.images.tr(),
                      isSelected: _selectedAttachmentTab == 0,
                      onTap: () => setState(() => _selectedAttachmentTab = 0),
                      accentColor: t.brandText,
                    ),
                    SizedBox(width: 16.lx),
                    _AttachmentTab(
                      label: LocaleKeys.files.tr(),
                      isSelected: _selectedAttachmentTab == 1,
                      onTap: () => setState(() => _selectedAttachmentTab = 1),
                      accentColor: t.brandText,
                    ),
                  ],
                ),
                SizedBox(height: 8.lx),
                _AttachmentTabContent(
                  files: complete.files,
                  selectedTab: _selectedAttachmentTab,
                  accentColor: t.brandText,
                ),
              ],
              if (!widget.hideActions) ...[
                SizedBox(height: 16.lx),
                LedgerButton(
                  label: LocaleKeys.spaceShareTitle.tr(),
                  icon: LucideIcons.share2,
                  style: LedgerButtonStyle.outline,
                  large: true,
                  onPressed: () => showShareToSpaceSheet(context, complete),
                ),
                SizedBox(height: 8.lx),
                Row(
                  children: [
                    Expanded(
                      child: LedgerButton(
                        label: LocaleKeys.edit.tr(),
                        icon: LucideIcons.pencil,
                        large: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onEdit();
                        },
                      ),
                    ),
                    SizedBox(width: 8.lx),
                    Expanded(
                      child: LedgerButton(
                        label: LocaleKeys.delete.tr(),
                        icon: LucideIcons.trash2,
                        style: LedgerButtonStyle.outline,
                        foreground: t.expenseColor,
                        large: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onDelete();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool muted;
  final bool divider;

  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    this.muted = false,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.lx),
      decoration: BoxDecoration(
        border:
            divider ? Border(bottom: BorderSide(color: t.borderLight)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.lx, color: t.textMuted),
          SizedBox(width: 10.lx),
          SizedBox(
            width: 70.lx,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.lx,
                color: muted ? t.textMuted : t.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _recurrencePeriodLabel(String period) {
  switch (period) {
    case 'daily':
      return LocaleKeys.daily.tr();
    case 'weekly':
      return LocaleKeys.weekly.tr();
    case 'monthly':
      return LocaleKeys.monthly.tr();
    case 'yearly':
      return LocaleKeys.yearly.tr();
    default:
      return period;
  }
}

class _AttachmentTab extends StatelessWidget {
  const _AttachmentTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? accentColor : context.tones.textMuted,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 2.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: isSelected ? accentColor : Colors.transparent,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTabContent extends StatelessWidget {
  const _AttachmentTabContent({
    required this.files,
    required this.selectedTab,
    required this.accentColor,
  });

  final List<MediaFileEntity> files;
  final int selectedTab;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final imageItems = files
        .where((f) => isImageAttachmentPath(f.path))
        .map((f) => ExistingAttachment(f))
        .toList();
    final fileItems = files
        .where((f) => !isImageAttachmentPath(f.path))
        .map((f) => ExistingAttachment(f))
        .toList();
    final items = selectedTab == 0 ? imageItems : fileItems;
    final emptyMessage =
        selectedTab == 0 ? LocaleKeys.noImages.tr() : LocaleKeys.noFiles.tr();

    if (items.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: context.tones.textMuted,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = 72.w;
        final gapWidth = 8.w;
        final contentWidth =
            items.length * tileWidth + (items.length - 1) * gapWidth;
        final horizontalPadding = (constraints.maxWidth - contentWidth) / 2;
        final padding = horizontalPadding > 0
            ? EdgeInsets.symmetric(horizontal: horizontalPadding)
            : null;

        return SizedBox(
          height: 100.h,
          child: AttachmentListView(
            items: items,
            showRemoveButton: false,
            accentColor: accentColor,
            onRemove: (_) {},
            padding: padding,
          ),
        );
      },
    );
  }
}
