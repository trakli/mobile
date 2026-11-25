import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/holdings/add_holding_screen.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

String _formatQuantity(double value) =>
    NumberFormat('#,##0.########').format(value);

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key});

  void _openForm(BuildContext context, {HoldingEntity? holding}) {
    AppNavigator.push(
      context,
      BlocProvider.value(
        value: context.read<HoldingCubit>(),
        child: AddHoldingScreen(holding: holding),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, HoldingEntity holding) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      title: LocaleKeys.holdingDeleteTitle.tr(),
      message: LocaleKeys.holdingDeleteMessage.tr(),
    );
    if (!confirmed || !context.mounted) return;
    final ok = await context.read<HoldingCubit>().deleteHolding(holding.id);
    if (ok) {
      showSnackBar(message: LocaleKeys.holdingDeleted.tr(), isSuccess: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.holdingsTitle.tr(),
        actions: [
          BlocBuilder<HoldingCubit, HoldingState>(
            buildWhen: (a, b) => a.isRepricing != b.isRepricing,
            builder: (context, state) => state.isRepricing
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
                    tooltip: LocaleKeys.holdingsRefreshPrices.tr(),
                    onTap: () => context.read<HoldingCubit>().refreshPrices(),
                  ),
          ),
          PageAppBarAction(
            icon: LucideIcons.plus,
            primary: true,
            tooltip: LocaleKeys.holdingsAdd.tr(),
            onTap: () => _openForm(context),
          ),
        ],
      ),
      body: BlocConsumer<HoldingCubit, HoldingState>(
        listenWhen: (a, b) => a.failure != b.failure,
        listener: (context, state) {
          if (state.failure.hasError) {
            showSnackBar(message: state.failure);
          }
        },
        builder: (context, state) {
          final totals = state.totalsByCurrency.entries.toList();
          return RefreshIndicator(
            onRefresh: () => context.read<HoldingCubit>().loadHoldings(),
            child: state.holdings.isEmpty
                ? LedgerEmptyState(
                    loading: state.isLoading,
                    icon: LucideIcons.chartCandlestick,
                    title: LocaleKeys.holdingsEmptyTitle.tr(),
                    body: LocaleKeys.holdingsEmptyDesc.tr(),
                    actionLabel: LocaleKeys.holdingsAdd.tr(),
                    onAction: () => _openForm(context),
                  )
                : ListView(
                    padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                    children: [
                      Text(
                        LocaleKeys.holdingsTotalValue.tr(),
                        style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                      ),
                      SizedBox(height: 2.lx),
                      for (final (i, e) in totals.indexed)
                        i == 0
                            ? LedgerBigNumber(
                                LedgerMoney.format(e.value, e.key))
                            : LedgerAmount(
                                LedgerMoney.format(e.value, e.key),
                                size: 16,
                                color: t.textSecondary,
                              ),
                      SizedBox(height: 16.lx),
                      LedgerCard(
                        padding: EdgeInsets.symmetric(horizontal: 12.lx),
                        child: Column(
                          children: [
                            for (final h in state.holdings)
                              _HoldingRow(
                                holding: h,
                                divider: h != state.holdings.last,
                                onEdit: () => _openForm(context, holding: h),
                                onDelete: () => _confirmDelete(context, h),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _HoldingRow extends StatelessWidget {
  final HoldingEntity holding;
  final bool divider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HoldingRow({
    required this.holding,
    required this.divider,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final symbol = holding.symbol?.trim();
    final isAuto = holding.priceSource.isAuto;
    return LedgerRow(
      leading: LedgerCoin(
        icon: isAuto ? LucideIcons.chartLine : LucideIcons.gem,
      ),
      title: holding.name,
      subtitleWidget: Row(
        children: [
          if (symbol != null && symbol.isNotEmpty) ...[
            Text(
              symbol.toUpperCase(),
              style: LedgerText.money(size: 11.lx, color: t.textSecondary),
            ),
            SizedBox(width: 6.lx),
          ],
          Flexible(
            child: Text(
              '${_formatQuantity(holding.quantity)} × '
              '${LedgerMoney.format(holding.unitPrice, holding.currency)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5.lx, color: t.textMuted),
            ),
          ),
          SizedBox(width: 6.lx),
          LedgerChip(
            isAuto
                ? LocaleKeys.holdingsPriceLive.tr()
                : LocaleKeys.holdingsPriceManual.tr(),
            tone: isAuto ? LedgerChipTone.good : LedgerChipTone.neutral,
          ),
        ],
      ),
      onTap: onEdit,
      divider: divider,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LedgerAmount(
            LedgerMoney.format(holding.value, holding.currency),
            weight: FontWeight.w600,
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(
              LucideIcons.ellipsisVertical,
              size: 16.lx,
              color: t.textMuted,
            ),
            onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(LocaleKeys.edit.tr())),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  LocaleKeys.delete.tr(),
                  style: TextStyle(color: t.expenseColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
