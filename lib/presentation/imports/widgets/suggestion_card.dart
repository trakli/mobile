import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/imports/import_review_status.dart';
import 'package:trakli/presentation/imports/widgets/picker_with_hint.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/custom_auto_complete_search.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class SuggestionCard extends StatefulWidget {
  final int position;
  final TransactionSuggestionEntity suggestion;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final ValueChanged<TransactionSuggestionEntity> onChanged;

  const SuggestionCard({
    super.key,
    required this.position,
    required this.suggestion,
    required this.accepted,
    required this.onAcceptedChanged,
    required this.onChanged,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  late TextEditingController _amountCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TransactionType _type;
  bool _expanded = false;

  static const _expandDuration = Duration(milliseconds: 180);

  @override
  void initState() {
    super.initState();
    final s = widget.suggestion;
    _amountCtrl = TextEditingController(text: s.amount?.toString() ?? '');
    _descCtrl = TextEditingController(text: s.description ?? '');
    _dateCtrl = TextEditingController(text: s.date ?? '');
    _type = s.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _emitTextUpdate() {
    widget.onChanged(widget.suggestion.copyWith(
      amount: parseAmount(_amountCtrl.text),
      description: _descCtrl.text,
      date: _dateCtrl.text,
      type: _type,
    ));
  }

  String _primaryText() {
    final desc = widget.suggestion.description;
    if (desc != null && desc.trim().isNotEmpty) return desc.trim();
    final party = widget.suggestion.party;
    if (party != null && party.trim().isNotEmpty) return party.trim();
    return '#${widget.position + 1}';
  }

  String _amountText() {
    final s = widget.suggestion;
    final amount = s.amount;
    if (amount == null) return '';
    final signed = s.type == TransactionType.income ? amount : -amount;
    final code = s.currency?.trim().toUpperCase();
    if (code == null || code.isEmpty) {
      final n =
          NumberFormat.decimalPatternDigits(decimalDigits: 2).format(amount);
      return signed < 0 ? '$ledgerMinus$n' : '+$n';
    }
    return LedgerMoney.format(signed, code, sign: true);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final status = importRowStatus(widget.suggestion);
    final category = widget.suggestion.category?.trim() ?? '';
    final (statusText, statusColor) = switch (status) {
      ImportRowStatus.duplicate => (
          LocaleKeys.importReviewPossibleDuplicate.tr(),
          tones.warmText
        ),
      ImportRowStatus.needsCategory => (
          LocaleKeys.importReviewChooseCategory.tr(),
          tones.expenseColor
        ),
      ImportRowStatus.ready => (category, tones.textMuted),
    };
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tones.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.lx),
              child: Row(
                children: [
                  LedgerCheck(
                    value: widget.accepted,
                    onChanged: widget.onAcceptedChanged,
                  ),
                  SizedBox(width: 11.lx),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _primaryText(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: LedgerText.money(
                            size: 11.5.lx,
                            weight: FontWeight.w400,
                            color: tones.textPrimary,
                          ),
                        ),
                        if (statusText.isNotEmpty)
                          Text(
                            statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.lx,
                              color: statusColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.lx),
                  LedgerAmount(
                    _amountText(),
                    size: 12.5,
                    color: widget.suggestion.type == TransactionType.income
                        ? tones.incomeColor
                        : null,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: _expandDuration,
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(0, 4.lx, 0, 12.lx),
              child: _editableBody(tones.brandFill),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableBody(Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: LocaleKeys.importAmount.tr(),
                  isDense: true,
                ),
                onChanged: (_) => _emitTextUpdate(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: DropdownButtonFormField<TransactionType>(
                initialValue: _type,
                isDense: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.importType.tr(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text(LocaleKeys.transactionExpense.tr()),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text(LocaleKeys.transactionIncome.tr()),
                  ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _type = v);
                  _emitTextUpdate();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _descCtrl,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDescription.tr(),
            isDense: true,
          ),
          onChanged: (_) => _emitTextUpdate(),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final wallets = state.wallets.where((w) => w.id != null).toList();
            final selected = _findById<WalletEntity>(
              wallets,
              widget.suggestion.walletId,
              (w) => w.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importWallet.tr(),
              suggestionText: widget.suggestion.wallet,
              picker: CustomAutoCompleteSearch<WalletEntity>(
                key: ValueKey('wallet_${widget.suggestion.walletId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return wallets;
                  return wallets
                      .where((w) => w.name.toLowerCase().contains(query));
                },
                displayStringForOption: (w) => w.name,
                onSelected: (w) =>
                    widget.onChanged(widget.suggestion.withWalletId(w.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<PartyCubit, PartyState>(
          builder: (context, state) {
            final parties = state.parties.where((p) => p.id != null).toList();
            final selected = _findById<PartyEntity>(
              parties,
              widget.suggestion.partyId,
              (p) => p.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importParty.tr(),
              suggestionText: widget.suggestion.party,
              picker: CustomAutoCompleteSearch<PartyEntity>(
                key: ValueKey('party_${widget.suggestion.partyId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return parties;
                  return parties
                      .where((p) => p.name.toLowerCase().contains(query));
                },
                displayStringForOption: (p) => p.name,
                onSelected: (p) =>
                    widget.onChanged(widget.suggestion.withPartyId(p.id)),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final categories = state.categories
                .where((c) => c.id != null && c.type == _type)
                .toList();
            final selected = _findById<CategoryEntity>(
              categories,
              widget.suggestion.categoryId,
              (c) => c.id,
            );
            return PickerWithHint(
              label: LocaleKeys.importCategory.tr(),
              suggestionText: widget.suggestion.category,
              picker: CustomAutoCompleteSearch<CategoryEntity>(
                key: ValueKey(
                    'category_${_type.name}_${widget.suggestion.categoryId ?? 'none'}'),
                label: '',
                accentColor: accent,
                initialValue: selected,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return categories;
                  return categories
                      .where((c) => c.name.toLowerCase().contains(query));
                },
                displayStringForOption: (c) => c.name,
                onSelected: (c) =>
                    widget.onChanged(widget.suggestion.withCategoryId(c.id)),
              ),
            );
          },
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _dateCtrl,
          decoration: InputDecoration(
            labelText: LocaleKeys.importDate.tr(),
            hintText: 'YYYY-MM-DD',
            isDense: true,
          ),
          onChanged: (_) => _emitTextUpdate(),
        ),
      ],
    );
  }
}

T? _findById<T>(List<T> items, int? id, int? Function(T) idOf) {
  if (id == null) return null;
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}
