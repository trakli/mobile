import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/exports/cubit/export_cubit.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/category_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/date_list_popover.dart';
import 'package:trakli/presentation/utils/popovers/wallet_list_popover.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/presentation/activity/activity_grouping.dart';
import 'package:trakli/presentation/activity/activity_screen.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/utils/ledger/ledger_currency.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showSearch = false;
  String _query = '';
  List<dynamic> selectedItems = [];
  PickerDateRange? dateRange;

  @override
  void initState() {
    final cubit = context.read<TransactionCubit>();
    cubit.loadWallets();
    super.initState();
  }

  List<TransactionCompleteEntity> filterTransactions({
    required List<TransactionCompleteEntity> transactions,
  }) {
    final filteredTransactions = selectedItems.isEmpty && dateRange == null
        ? transactions
        : (() {
            final selectedCategories =
                selectedItems.whereType<CategoryEntity>().toList();
            final selectedWallets =
                selectedItems.whereType<WalletEntity>().toList();

            final hasCategoryFilter = selectedCategories.isNotEmpty;
            final hasWalletFilter = selectedWallets.isNotEmpty;

            return transactions.where((transaction) {
              final categoryMatch = hasCategoryFilter &&
                  transaction.categories.any((cat) => selectedCategories
                      .any((selected) => selected.clientId == cat.clientId));
              final walletMatch = hasWalletFilter &&
                  selectedWallets.any((wallet) =>
                      wallet.clientId == transaction.wallet.clientId);

              final dateMatch = matchTransactionDate(
                dateRange,
                transaction.transaction,
              );

              if (hasCategoryFilter && hasWalletFilter) {
                return categoryMatch && walletMatch && dateMatch;
              } else if (hasCategoryFilter) {
                return categoryMatch && dateMatch;
              } else if (hasWalletFilter) {
                return walletMatch && dateMatch;
              } else {
                return dateMatch;
              }
            }).toList();
          })();
    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocProvider(
      create: (_) => getIt<ExportCubit>(),
      child: BlocListener<ExportCubit, ExportState>(
        listenWhen: (previous, current) =>
            previous.file != current.file ||
            previous.failure != current.failure ||
            previous.blocker != current.blocker,
        listener: _onExportStateChanged,
        child: _buildScaffold(tones),
      ),
    );
  }

  void _onExportStateChanged(BuildContext context, ExportState state) {
    if (state.file != null) {
      final file = state.file!;
      context.read<ExportCubit>().clearFile();
      _showExportActions(file);
      return;
    }

    if (state.failure.hasError) {
      showSnackBar(message: state.failure);
      return;
    }

    switch (state.blocker) {
      case ExportBlocker.signedOut:
        showSnackBar(message: LocaleKeys.exportRequiresAccount.tr());
      case ExportBlocker.pendingSync:
        showSnackBar(message: LocaleKeys.exportAwaitingSync.tr());
      case ExportBlocker.none:
        break;
    }
  }

  /// The file is ready; let the user decide whether it should be kept on the
  /// device or handed to another app.
  void _showExportActions(ExportedFile file) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 12.lx),
              LedgerH6(file.name),
              LedgerRow(
                leading: const LedgerCoin(icon: LucideIcons.download),
                title: LocaleKeys.save.tr(),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _saveFile(file);
                },
              ),
              LedgerRow(
                leading: const LedgerCoin(icon: LucideIcons.share2),
                title: LocaleKeys.share.tr(),
                divider: false,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _shareFile(file);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareFile(ExportedFile file) {
    Share.shareXFiles([
      XFile.fromData(
        file.bytes,
        name: file.name,
        mimeType: file.mimeType,
      ),
    ], fileNameOverrides: [
      file.name
    ]);
  }

  /// Writes the export through the system file picker, so the user chooses
  /// where it lands and ends up with a copy they can find again.
  Future<void> _saveFile(ExportedFile file) async {
    try {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: LocaleKeys.export.tr(),
        fileName: file.name,
        bytes: file.bytes,
      );
      if (path == null) return;
      showSnackBar(
        message: LocaleKeys.exportSaved.tr(namedArgs: {'name': file.name}),
        isSuccess: true,
      );
    } catch (_) {
      showSnackBar(message: LocaleKeys.exportSaveFailed.tr());
    }
  }

  /// Server-side exports only cover synced records, so a filter pinned to a
  /// wallet or category that has not reached the server yet cannot be honoured.
  void _export(BuildContext context, ExportFormat format) {
    final wallets = selectedItems.whereType<WalletEntity>().toList();
    final categories = selectedItems.whereType<CategoryEntity>().toList();

    if (wallets.any((wallet) => wallet.id == null) ||
        categories.any((category) => category.id == null)) {
      showSnackBar(message: LocaleKeys.exportAwaitingSync.tr());
      return;
    }

    final start = dateRange?.startDate;

    showSnackBar(
      message: LocaleKeys.exportPreparing.tr(),
      isSuccess: true,
    );

    context.read<ExportCubit>().exportTransactions(
          format: format,
          from: start,
          to: start == null ? null : (dateRange?.endDate ?? start),
          walletIds: wallets.map((wallet) => wallet.id!).toList(),
          categoryIds: categories.map((category) => category.id!).toList(),
        );
  }

  Widget _buildScaffold(AppTones tones) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final t = context.tones;
        final currency = LedgerCurrency.of(context);
        final now = DateTime.now();
        final transactions =
            filterTransactions(transactions: state.transactions)
                .where(ActivityFilter(query: _query).matches)
                .toList();
        final days = groupActivityByDay(
          transactions,
          currency: currency.code,
          rates: currency.rates,
        );

        var totalIn = 0.0;
        var totalOut = 0.0;
        for (final tx in transactions) {
          if (tx.transaction.isTransferLeg) continue;
          final v = ledgerConvert(
            tx.transaction.amount,
            tx.wallet.currencyCode,
            currency.code,
            currency.rates,
          );
          if (tx.transaction.type == TransactionType.income) {
            totalIn += v;
          } else {
            totalOut += v;
          }
        }
        final kept = totalIn - totalOut;

        return Scaffold(
          backgroundColor: t.bgPage,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 0),
                  child: LedgerScreenBar(
                    leadingIcon: LucideIcons.chevronLeft,
                    title: LocaleKeys.transactions.tr(),
                    actions: [
                      LedgerIconButton(
                        icon: showSearch ? LucideIcons.x : LucideIcons.search,
                        tooltip: LocaleKeys.search.tr(),
                        onTap: () => setState(() {
                          showSearch = !showSearch;
                          if (!showSearch) _query = '';
                        }),
                      ),
                      _ExportButton(
                        onExport: (format) => _export(context, format),
                      ),
                      LedgerIconButton(
                        icon: LucideIcons.plus,
                        tooltip: LocaleKeys.addTransaction.tr(),
                        onTap: () => AppNavigator.push(
                          context,
                          const AddTransactionScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSearch)
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 0),
                    child: TextField(
                      autofocus: true,
                      onChanged: (q) => setState(() => _query = q),
                      style: TextStyle(fontSize: 13.lx),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: LocaleKeys.activitySearchHint.tr(),
                        prefixIcon: Icon(LucideIcons.search, size: 16.lx),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 0),
                  child: LedgerChipRow(
                    children: [
                      _filterChip(FilterType.date, LucideIcons.calendar),
                      _filterChip(FilterType.category, LucideIcons.tag),
                      _filterChip(FilterType.wallet, LucideIcons.wallet),
                      for (final (i, item) in selectedItems.indexed)
                        LedgerFilterChip(
                          label: _selectedLabel(item),
                          icon: LucideIcons.x,
                          selected: true,
                          onTap: () => setState(() {
                            selectedItems.removeAt(i);
                            if (item is DateFilterOption) dateRange = null;
                          }),
                        ),
                    ],
                  ),
                ),
                if (state.transactions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowIn.tr(),
                            value: LedgerMoney.format(totalIn, currency.code),
                            color: t.incomeColor,
                          ),
                        ),
                        SizedBox(width: 6.lx),
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowOut.tr(),
                            value: LedgerMoney.format(totalOut, currency.code),
                            color: t.expenseColor,
                          ),
                        ),
                        SizedBox(width: 6.lx),
                        Expanded(
                          child: LedgerTotalTile(
                            label: LocaleKeys.statsFlowKept.tr(),
                            value: LedgerMoney.format(
                              kept,
                              currency.code,
                              sign: true,
                            ),
                            color: kept >= 0 ? t.incomeColor : t.expenseColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: state.isLoading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(t.brandFill),
                          ),
                        )
                      : state.transactions.isEmpty
                          ? InfoInterface(
                              action: () => AppNavigator.push(
                                context,
                                const AddTransactionScreen(),
                              ),
                              data: emptyTransactionData,
                            )
                          : days.isEmpty
                              ? Center(
                                  child: Text(
                                    LocaleKeys.noTransactionsFound.tr(),
                                    style: TextStyle(
                                      fontSize: 13.lx,
                                      color: t.textMuted,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                    14.lx,
                                    12.lx,
                                    14.lx,
                                    24.lx,
                                  ),
                                  itemCount: days.length,
                                  itemBuilder: (context, i) {
                                    final day = days[i];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.lx),
                                      child: LedgerCard(
                                        padding: EdgeInsets.fromLTRB(
                                          12.lx,
                                          10.lx,
                                          12.lx,
                                          2.lx,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            LedgerH6(
                                              activityDayLabel(
                                                context,
                                                day.day,
                                                now,
                                              ),
                                              trailing: Text(
                                                LedgerMoney.format(
                                                  day.net,
                                                  currency.code,
                                                  sign: true,
                                                ),
                                                style: LedgerText.money(
                                                  size: 11.lx,
                                                  color: day.net >= 0
                                                      ? t.incomeColor
                                                      : t.expenseColor,
                                                ),
                                              ),
                                            ),
                                            for (final tx in day.transactions)
                                              LedgerTransactionRow(
                                                transaction: tx,
                                                subtitle: activitySubtitle(tx),
                                                verticalPadding: 8,
                                                divider:
                                                    tx != day.transactions.last,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _selectedLabel(Object? item) {
    if (item is WalletEntity) return item.name;
    if (item is CategoryEntity) return item.name;
    if (item is DateFilterOption) {
      return item == DateFilterOption.custom
          ? (formatRange(dateRange) ?? '')
          : item.name.tr();
    }
    return '';
  }

  Widget _filterChip(FilterType filterType, IconData icon) {
    return Builder(
      builder: (chipContext) => LedgerFilterChip(
        label: filterType.filterName.tr(),
        icon: icon,
        onTap: () => showCustomPopOver(
          chipContext,
          maxWidth: 0.45.sw,
          widget: switch (filterType) {
            FilterType.wallet => WalletListPopover(
                label: filterType.filterName.tr(),
                onSelect: (wallet) => setState(() {
                  if (!selectedItems.any((item) =>
                      item is WalletEntity &&
                      item.clientId == wallet.clientId)) {
                    selectedItems.add(wallet);
                  }
                }),
              ),
            FilterType.category => CategoryListPopover(
                label: filterType.filterName.tr(),
                onSelect: (category) => setState(() {
                  if (!selectedItems.any((item) =>
                      item is CategoryEntity &&
                      item.clientId == category.clientId)) {
                    selectedItems.add(category);
                  }
                }),
              ),
            FilterType.date => DateListPopover(
                label: filterType.filterName.tr(),
                onSelect: (range) => setState(() => dateRange = range),
                onSelectString: (option) => setState(() {
                  selectedItems.removeWhere((item) => item is DateFilterOption);
                  selectedItems.add(option);
                }),
              ),
          },
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final void Function(ExportFormat format) onExport;

  const _ExportButton({required this.onExport});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    Widget item(IconData icon, String label, ExportFormat format) =>
        MenuItemButton(
          leadingIcon: Icon(icon, size: 16.lx, color: t.textSecondary),
          onPressed: () => onExport(format),
          child: Text(label, style: TextStyle(fontSize: 13.5.lx)),
        );
    return MenuAnchor(
      alignmentOffset: Offset(0, 4.lx),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(t.bgSurface),
        side: WidgetStatePropertyAll(BorderSide(color: t.borderLight)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      menuChildren: [
        item(LucideIcons.fileText, LocaleKeys.toPdf.tr(), ExportFormat.pdf),
        item(
          LucideIcons.fileSpreadsheet,
          LocaleKeys.toExcel.tr(),
          ExportFormat.xlsx,
        ),
      ],
      builder: (context, controller, _) => LedgerIconButton(
        icon: LucideIcons.download,
        tooltip: LocaleKeys.export.tr(),
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
