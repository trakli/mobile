import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/document_scan_screen.dart';
import 'package:trakli/presentation/transactions/add_transaction_form_compact_layout.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_form.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/transfers/wallet_transfer_screen.dart';
import 'package:trakli/providers/local_storage.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transaction;
  final PartyEntity? initialParty;
  final TransactionIntent? initialIntent;
  final double? initialAmount;
  final String? initialDescription;
  final CategoryEntity? initialCategory;
  final WalletEntity? initialWallet;
  final DateTime? initialDate;

  const AddTransactionScreen({
    super.key,
    this.transactionType = TransactionType.expense,
    this.accentColor = const Color(0xFFEB5757),
    this.transaction,
    this.initialParty,
    this.initialIntent,
    this.initialAmount,
    this.initialDescription,
    this.initialCategory,
    this.initialWallet,
    this.initialDate,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

enum _TxTab { expense, income, transfer }

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String formDisplay = 'full';
  late _TxTab _tab;

  bool get _isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    LocalStorage().getTransactionFormDisplay().then((val) {
      if (mounted) setState(() => formDisplay = val ?? 'full');
    });
    final type = widget.transaction?.transaction.type ?? widget.transactionType;
    _tab = type == TransactionType.income ? _TxTab.income : _TxTab.expense;
  }

  void _swipe(DragEndDetails details) {
    if (_isEdit) return;
    final v = details.primaryVelocity ?? 0;
    if (v.abs() < 200) return;
    final i = _tab.index + (v < 0 ? 1 : -1);
    if (i < 0 || i >= _TxTab.values.length) return;
    setState(() => _tab = _TxTab.values[i]);
  }

  Widget _form(TransactionType type) {
    if (formDisplay != 'compact') {
      return LedgerTransactionForm(
        transactionType: type,
        transactionCompleteEntity: widget.transaction,
        initialParty: widget.initialParty,
        initialIntent: widget.initialIntent,
        initialAmount: widget.initialAmount,
        initialDescription: widget.initialDescription,
        initialCategory: widget.initialCategory,
        initialWallet: widget.initialWallet,
        initialDate: widget.initialDate,
      );
    }
    return AddTransactionFormCompactLayout(
      transactionType: type,
      accentColor:
          type == TransactionType.expense ? appDangerColor : appPrimaryColor,
      transactionCompleteEntity: widget.transaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final children = <_TxTab, Widget>{
      if (!_isEdit || widget.transaction!.transaction.type ==
          TransactionType.expense)
        _TxTab.expense: KeyedSubtree(
          key: const ValueKey('tx-form-expense'),
          child: _form(TransactionType.expense),
        ),
      if (!_isEdit || widget.transaction!.transaction.type ==
          TransactionType.income)
        _TxTab.income: KeyedSubtree(
          key: const ValueKey('tx-form-income'),
          child: _form(TransactionType.income),
        ),
      if (!_isEdit)
        _TxTab.transfer: const KeyedSubtree(
          key: ValueKey('tx-form-transfer'),
          child: WalletTransferScreen(embedded: true),
        ),
    };
    final tabs = children.keys.toList();
    final index = tabs.indexOf(_tab).clamp(0, tabs.length - 1);

    return Scaffold(
      backgroundColor: t.bgPage,
      body: SafeArea(
        child: BlocListener<TransactionCubit, TransactionState>(
          listenWhen: (previous, current) =>
              previous.isSaving && !current.isSaving,
          listener: (context, state) {
            if (!state.failure.hasError && mounted) {
              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 0),
                child: LedgerScreenBar(
                  leadingIcon: LucideIcons.x,
                  title: _isEdit
                      ? LocaleKeys.editTransaction.tr()
                      : LocaleKeys.txFormNewTransaction.tr(),
                  actions: [
                    if (!_isEdit)
                      LedgerIconButton(
                        icon: LucideIcons.scanLine,
                        tooltip: LocaleKeys.txFormScan.tr(),
                        onTap: () => AppNavigator.push(
                          context,
                          const DocumentScanScreen(),
                        ),
                      ),
                  ],
                ),
              ),
              if (!_isEdit)
                Padding(
                  padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 10.lx),
                  child: LedgerSeg<_TxTab>(
                    options: [
                      LedgerSegOption(
                        _TxTab.expense,
                        LocaleKeys.transactionExpense.tr(),
                      ),
                      LedgerSegOption(
                        _TxTab.income,
                        LocaleKeys.transactionIncome.tr(),
                      ),
                      LedgerSegOption(
                        _TxTab.transfer,
                        LocaleKeys.transfer.tr(),
                      ),
                    ],
                    selected: _tab,
                    onChanged: (v) => setState(() => _tab = v),
                  ),
                )
              else
                SizedBox(height: 12.lx),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: _swipe,
                  child: IndexedStack(
                    index: index,
                    children: children.values.toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
