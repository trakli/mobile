import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/party_debt.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_picker_sheet.dart';
import 'package:trakli/presentation/transactions/transaction_extras_section.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/add_party_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_display_cache.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_view.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_source_row.dart';

IconData ledgerIntentIcon(TransactionIntent intent) {
  return switch (intent) {
    TransactionIntent.regular => LucideIcons.circle,
    TransactionIntent.loanReceived => LucideIcons.arrowDownLeft,
    TransactionIntent.loanRepayment => LucideIcons.arrowUpRight,
    TransactionIntent.debtOwed => LucideIcons.handCoins,
    TransactionIntent.debtSettled => LucideIcons.checkCheck,
    TransactionIntent.investmentBuy => LucideIcons.trendingUp,
    TransactionIntent.investmentReturn => LucideIcons.coins,
    TransactionIntent.gift => LucideIcons.gift,
  };
}

/// Symbol placed before an amount (`€`, `$`), or null when the currency is
/// written as a code after the number (`XAF`).
String? ledgerPrefixSymbol(String code) {
  try {
    final symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
    final short = symbol.runes.length <= 2 &&
        !RegExp(r'^[A-Za-z]+$').hasMatch(symbol) &&
        symbol != code;
    return short ? symbol : null;
  } catch (_) {
    return null;
  }
}

/// Every field the app supports for an income or expense, laid out as one
/// card of rows. Submits through [TransactionCubit] exactly like the older
/// full form.
class LedgerTransactionForm extends StatefulWidget {
  final TransactionType transactionType;
  final TransactionCompleteEntity? transactionCompleteEntity;
  final PartyEntity? initialParty;
  final TransactionIntent? initialIntent;
  final double? initialAmount;
  final String? initialDescription;
  final CategoryEntity? initialCategory;
  final WalletEntity? initialWallet;
  final DateTime? initialDate;

  const LedgerTransactionForm({
    super.key,
    this.transactionType = TransactionType.expense,
    this.transactionCompleteEntity,
    this.initialParty,
    this.initialIntent,
    this.initialAmount,
    this.initialDescription,
    this.initialCategory,
    this.initialWallet,
    this.initialDate,
  });

  @override
  State<LedgerTransactionForm> createState() => _LedgerTransactionFormState();
}

class _LedgerTransactionFormState extends State<LedgerTransactionForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _extras = TransactionExtrasController();

  DateTime _date = DateTime.now();
  TransactionIntent _intent = TransactionIntent.regular;
  WalletEntity? _wallet;
  CategoryEntity? _category;
  PartyEntity? _party;
  GroupEntity? _group;
  List<String> _attachedFilePaths = [];
  List<MediaFileEntity> _existingMedia = [];
  bool _submitted = false;
  bool _editingAmount = false;
  final _amountFocus = FocusNode();

  bool get _isEdit => widget.transactionCompleteEntity != null;
  bool get _isIncome => widget.transactionType == TransactionType.income;

  List<AttachmentListItem> get _allAttachments => [
        ..._existingMedia.map((m) => ExistingAttachment(m)),
        ..._attachedFilePaths.map((p) => NewLocalAttachment(p)),
      ];

  @override
  void initState() {
    super.initState();
    final existing = widget.transactionCompleteEntity;
    if (existing != null) {
      final txn = existing.transaction;
      _intent = txn.intent.availableFor(widget.transactionType)
          ? txn.intent
          : TransactionIntent.regular;
      _extras.populateFrom(txn, widget.transactionType);
      if (existing.categories.isNotEmpty) {
        _category = existing.categories.first;
      }
      _amountController.text = _formatInput(txn.amount);
      _descriptionController.text = txn.description;
      _date = txn.datetime.toLocal();
      _wallet = existing.wallet;
      _party = existing.party;
      _group = existing.group;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _existingMedia = existing.files);
      });
    } else {
      _date = widget.initialDate ?? DateTime.now();
      _group = context.read<TransactionCubit>().state.selectedGroup;
      _party = widget.initialParty;
      _category = widget.initialCategory?.type == widget.transactionType
          ? widget.initialCategory
          : null;
      final intent = widget.initialIntent;
      if (intent != null && intent.availableFor(widget.transactionType)) {
        _intent = intent;
      }
      if (widget.initialAmount != null) {
        _amountController.text = _formatInput(widget.initialAmount!);
      }
      _descriptionController.text = widget.initialDescription ?? '';
      _wallet = widget.initialWallet ?? _defaultWallet();
    }
    if (_extras.wasRefund) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  WalletEntity? _defaultWallet() {
    final configState = context.read<ConfigCubit>().state;
    final id = configState.getConfigByKey(ConfigConstants.defaultWallet)?.value
        as String?;
    if (id == null) return null;
    return context
        .read<WalletCubit>()
        .state
        .wallets
        .firstWhereOrNull((w) => w.clientId == id);
  }

  String _formatInput(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEdit && _amountController.text.isEmpty && !_editingAmount) {
      _editingAmount = true;
    }
  }

  double? _parsedAmount() =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '.'));

  @override
  void dispose() {
    AttachmentDisplayCache.clear();
    _extras.dispose();
    _amountController.dispose();
    _amountFocus.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addAttachmentPath(String? path) {
    if (path == null || !mounted) return;
    setState(() => _attachedFilePaths = [..._attachedFilePaths, path]);
  }

  void _handleRemove(AttachmentListItem item) {
    switch (item) {
      case ExistingAttachment(media: final m):
        context.read<TransactionCubit>().deleteMedia(m.path);
        setState(() =>
            _existingMedia = _existingMedia.where((e) => e != m).toList());
      case NewLocalAttachment(path: final p):
        setState(() => _attachedFilePaths =
            _attachedFilePaths.where((path) => path != p).toList());
    }
  }

  Future<void> _pickWallet() async {
    final picked = await showLedgerPicker<WalletEntity>(
      context,
      title: LocaleKeys.wallet.tr(),
      items: (ctx) => ctx.watch<WalletCubit>().state.wallets,
      label: (w) => w.name,
      subtitle: (w) => w.currencyCode,
      leading: (w) => LedgerCoin(icon: ledgerWalletIcon(w.type), media: w.icon),
      isSelected: (w) => w.clientId == _wallet?.clientId,
      onAddNew: (ctx) => AppNavigator.push(ctx, const AddWalletScreen()),
    );
    if (picked == null || !mounted) return;
    setState(() => _wallet = picked.value ?? _wallet);
  }

  Future<void> _pickCategory() async {
    final picked = await showLedgerPicker<CategoryEntity>(
      context,
      title: LocaleKeys.category.tr(),
      searchable: true,
      items: (ctx) => ctx
          .watch<CategoryCubit>()
          .state
          .categories
          .where((c) => c.type == widget.transactionType)
          .toList(),
      label: (c) => c.name,
      leading: (c) => LedgerCoin(media: c.icon, icon: LucideIcons.tag),
      isSelected: (c) => c.clientId == _category?.clientId,
      onAddNew: (ctx) => AppNavigator.push(
        ctx,
        AddCategoryScreen(
          accentColor: _accent(context),
          type: widget.transactionType,
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _category = picked.value ?? _category);
  }

  Future<void> _pickParty() async {
    final picked = await showLedgerPicker<PartyEntity>(
      context,
      title: LocaleKeys.party.tr(),
      searchable: true,
      allowClear: _party != null,
      items: (ctx) => ctx.watch<PartyCubit>().state.parties,
      label: (p) => p.name,
      leading: (p) => LedgerInitials(p.name),
      isSelected: (p) => p.clientId == _party?.clientId,
      onAddNew: (ctx) => showDialog(
        context: ctx,
        builder: (_) => const AddPartyDialog(),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _party = picked.value);
  }

  Future<void> _pickGroup() async {
    final picked = await showLedgerPicker<GroupEntity>(
      context,
      title: LocaleKeys.group.tr(),
      searchable: true,
      allowClear: _group != null,
      items: (ctx) => ctx.watch<GroupCubit>().state.groups,
      label: (g) => g.name,
      leading: (g) => LedgerCoin(media: g.icon, icon: LucideIcons.folder),
      isSelected: (g) => g.clientId == _group?.clientId,
    );
    if (picked == null || !mounted) return;
    setState(() => _group = picked.value);
  }

  Future<void> _pickWhen() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1000)),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    if (!mounted) return;
    final time = pickedTime ?? TimeOfDay.fromDateTime(_date);
    setState(() {
      _date = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _openAttachSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 18.lx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 12.lx),
              LedgerH6(LocaleKeys.transactionAttachment.tr()),
              SizedBox(height: 10.lx),
              AttachmentSourceRow(
                accentColor: _accent(context),
                onFileAdded: (path) {
                  _addAttachmentPath(path);
                  if (path != null && sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _accent(BuildContext context) =>
      _isIncome ? context.tones.incomeColor : context.tones.expenseColor;

  void _submit() {
    setState(() => _submitted = true);
    final formValid = _formKey.currentState!.validate();
    if (!formValid ||
        _amountError() != null ||
        _wallet == null ||
        _category == null) {
      if (_amountError() != null) _startAmountEdit();
      return;
    }
    final amount = _parsedAmount()!;
    final description = _descriptionController.text;
    final cubit = context.read<TransactionCubit>();
    if (_isEdit) {
      cubit.updateTransaction(
        id: widget.transactionCompleteEntity!.transaction.clientId,
        amount: amount,
        description: description,
        datetime: _date,
        intent: _intent,
        categoryIds: [_category!.clientId],
        walletClientId: _wallet?.clientId,
        partyClientId: _party?.clientId,
        groupClientId: _group?.clientId,
        attachedFilePaths: _attachedFilePaths,
        recurrence: _extras.recurrence,
        clearRecurrence: _extras.clearRecurrence,
        isRefund: _extras.refundUpdate,
        refundOfClientId: _extras.refundOfClientId,
      );
    } else {
      cubit.addTransaction(
        amount: amount,
        description: description,
        type: widget.transactionType,
        intent: _intent,
        datetime: _date,
        walletClientId: _wallet!.clientId,
        categoryIds: [_category!.clientId],
        partyClientId: _party?.clientId,
        groupClientId: _group?.clientId,
        attachedFilePaths: _attachedFilePaths,
        recurrence: _extras.recurrence,
        isRefund: _extras.isRefund,
        refundOfClientId: _extras.refundOfClientId,
      );
    }
  }

  String _periodLabel(String period) {
    return switch (period) {
      'daily' => LocaleKeys.daily.tr(),
      'weekly' => LocaleKeys.weekly.tr(),
      'monthly' => LocaleKeys.monthly.tr(),
      'yearly' => LocaleKeys.yearly.tr(),
      _ => period,
    };
  }

  String _repeatSummary() {
    if (!_extras.isRecurring) return LocaleKeys.txFormNever.tr();
    final n = int.tryParse(_extras.recurrenceIntervalController.text) ?? 1;
    final period = _periodLabel(_extras.recurrencePeriod);
    if (n <= 1) return period;
    return LocaleKeys.txFormEvery.tr(
      namedArgs: {'count': '$n', 'period': period.toLowerCase()},
    );
  }

  String _attachmentName(AttachmentListItem item) {
    final path = switch (item) {
      ExistingAttachment(media: final m) => m.path,
      NewLocalAttachment(path: final p) => p,
    };
    return path.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = context.tones;
    final isSaving =
        context.select<TransactionCubit, bool>((c) => c.state.isSaving);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.lx, 4.lx, 14.lx, 12.lx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _amountRow(context),
                  SizedBox(height: 14.lx),
                  _intentSection(context),
                  SizedBox(height: 12.lx),
                  _fieldsCard(context),
                  if (_extras.isRecurring || _extras.isRefund) ...[
                    SizedBox(height: 12.lx),
                    TransactionExtrasSection(
                      controller: _extras,
                      transactionType: widget.transactionType,
                      accentColor: t.brandFill,
                      recurrenceToggle: false,
                      refundToggle: false,
                      onChanged: () => setState(() {}),
                    ),
                  ],
                  if (_allAttachments.isNotEmpty) ...[
                    SizedBox(height: 12.lx),
                    SizedBox(
                      height: 72.lx,
                      child: AttachmentListView(
                        items: _allAttachments,
                        showRemoveButton: true,
                        accentColor: t.brandFill,
                        onRemove: _handleRemove,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 12.lx),
            child: SizedBox(
              width: double.infinity,
              child: LedgerButton(
                key: const ValueKey('ledger-tx-save'),
                label: LocaleKeys.save.tr(),
                icon: LucideIcons.check,
                large: true,
                busy: isSaving,
                onPressed: _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _amountError() {
    final value = _amountController.text.trim();
    if (value.isEmpty) return LocaleKeys.amountIsRequired.tr();
    final number = _parsedAmount();
    if (number == null) return LocaleKeys.mustBeNumber.tr();
    if (number == 0) return LocaleKeys.amountMustNotBeZero.tr();
    return null;
  }

  void _startAmountEdit() {
    setState(() => _editingAmount = true);
    _amountFocus.requestFocus();
  }

  Widget _amountRow(BuildContext context) {
    final t = context.tones;
    final code = _wallet?.currencyCode;
    final color = _isIncome ? t.incomeColor : t.expenseColor;
    final amount = _parsedAmount();
    final error = _submitted ? _amountError() : null;
    final style = LedgerText.money(
      size: 34.lx,
      weight: FontWeight.w600,
      color: color,
      letterSpacing: -0.04 * 34.lx,
      height: 1.1,
    );
    final Widget figure;
    if (_editingAmount) {
      final symbol = code == null ? null : ledgerPrefixSymbol(code);
      figure = TextField(
        key: const ValueKey('ledger-tx-amount'),
        controller: _amountController,
        focusNode: _amountFocus,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        style: style,
        cursorColor: color,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => setState(() => _editingAmount = false),
        onTapOutside: (_) {
          _amountFocus.unfocus();
          setState(() => _editingAmount = false);
        },
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixText: '${_isIncome ? '+' : ''}${symbol ?? ''}',
          prefixStyle: style,
          suffixText: symbol == null && code != null ? ' $code' : null,
          suffixStyle: style.copyWith(fontSize: 16.lx),
          hintText: '0.00',
          hintStyle: style.copyWith(color: t.textMuted),
        ),
      );
    } else {
      final text = amount == null || code == null
          ? (amount == null ? '0.00' : _amountController.text)
          : LedgerMoney.format(amount, code, sign: _isIncome);
      figure = GestureDetector(
        key: const ValueKey('ledger-tx-amount-display'),
        onTap: _startAmountEdit,
        behavior: HitTestBehavior.opaque,
        child: LedgerBigNumber(
          text,
          color: amount == null ? t.textMuted : color,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_editingAmount)
              Expanded(child: figure)
            else
              Flexible(child: figure),
            if (_wallet != null) ...[
              SizedBox(width: 8.lx),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: LedgerChip(
                    (_isIncome
                            ? LocaleKeys.txFormCurrencyIntoWallet
                            : LocaleKeys.txFormCurrencyFromWallet)
                        .tr(namedArgs: {
                      'currency': _wallet!.currencyCode,
                      'wallet': _wallet!.name,
                    }),
                    onTap: _pickWallet,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (error != null) ...[
          SizedBox(height: 4.lx),
          Text(
            error,
            style: TextStyle(fontSize: 11.5.lx, color: t.expenseColor),
          ),
        ],
      ],
    );
  }

  Widget _intentSection(BuildContext context) {
    final t = context.tones;
    final options = TransactionIntent.optionsFor(widget.transactionType);
    final other = _isIncome ? TransactionType.expense : TransactionType.income;
    final otherOnly = TransactionIntent.values
        .where((i) =>
            i.availableFor(other) &&
            !i.availableFor(
              widget.transactionType,
            ))
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.txFormWhatKind.tr(),
          style: TextStyle(fontSize: 11.lx, color: t.textMuted),
        ),
        SizedBox(height: 5.lx),
        Wrap(
          spacing: 5.lx,
          runSpacing: 5.lx,
          children: [
            for (final intent in options)
              LedgerFilterChip(
                key: ValueKey('ledger-intent-${intent.serverKey}'),
                label: intent.label.tr(),
                icon: ledgerIntentIcon(intent),
                selected: intent == _intent,
                onTap: () => setState(() => _intent = intent),
              ),
          ],
        ),
        if (otherOnly > 0) ...[
          SizedBox(height: 4.lx),
          Text(
            (_isIncome
                    ? LocaleKeys.txFormMoreForExpenses
                    : LocaleKeys.txFormMoreForIncome)
                .tr(namedArgs: {'count': '$otherOnly'}),
            style: TextStyle(fontSize: 11.lx, color: t.textMuted),
          ),
        ],
      ],
    );
  }

  Widget _fieldsCard(BuildContext context) {
    final t = context.tones;
    final hasGroups =
        context.select<GroupCubit, bool>((c) => c.state.groups.isNotEmpty);
    final attachments = _allAttachments;
    final whenFormat = DateFormat(
        'EEE, MMM d · HH:mm', Localizations.localeOf(context).toLanguageTag());
    final missing = t.expenseColor;
    final debtChip = _debtChip(context);
    return LedgerCard(
      padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 2.lx),
      child: Column(
        children: [
          LedgerFieldRow(
            key: const ValueKey('ledger-tx-party'),
            icon: LucideIcons.userRound,
            label: _isIncome ? LocaleKeys.from.tr() : LocaleKeys.to.tr(),
            value: _party?.name ?? LocaleKeys.none.tr(),
            placeholder: _party == null,
            trailing: debtChip,
            chevron: debtChip == null,
            onTap: _pickParty,
          ),
          LedgerFieldRow(
            key: const ValueKey('ledger-tx-wallet'),
            icon: _wallet == null
                ? LucideIcons.wallet
                : ledgerWalletIcon(_wallet!.type),
            label: LocaleKeys.wallet.tr(),
            valueWidget: _wallet == null
                ? _missingText(
                    _submitted
                        ? LocaleKeys.walletIsRequired.tr()
                        : LocaleKeys.txFormChoose.tr(),
                    _submitted ? missing : t.textMuted,
                  )
                : null,
            value: _wallet?.name,
            chevron: true,
            onTap: _pickWallet,
          ),
          LedgerFieldRow(
            key: const ValueKey('ledger-tx-category'),
            icon: LucideIcons.tag,
            label: LocaleKeys.category.tr(),
            valueWidget: _category == null
                ? _missingText(
                    _submitted
                        ? LocaleKeys.categoryIsRequired.tr()
                        : LocaleKeys.txFormChoose.tr(),
                    _submitted ? missing : t.textMuted,
                  )
                : null,
            value: _category?.name,
            chevron: true,
            onTap: _pickCategory,
          ),
          if (hasGroups)
            LedgerFieldRow(
              key: const ValueKey('transaction-group-picker'),
              icon: LucideIcons.folder,
              label: LocaleKeys.group.tr(),
              value: _group?.name ?? LocaleKeys.none.tr(),
              placeholder: _group == null,
              chevron: true,
              onTap: _pickGroup,
            ),
          LedgerFieldRow(
            key: const ValueKey('ledger-tx-when'),
            icon: LucideIcons.calendar,
            label: LocaleKeys.txFormWhen.tr(),
            value: whenFormat.format(_date),
            chevron: true,
            onTap: _pickWhen,
          ),
          LedgerFieldRow(
            icon: LucideIcons.stickyNote,
            label: LocaleKeys.txFormNote.tr(),
            valueWidget: TextField(
              key: const ValueKey('ledger-tx-note'),
              controller: _descriptionController,
              style: TextStyle(fontSize: 12.5.lx, color: t.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: LocaleKeys.txFormAddNote.tr(),
                hintStyle: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
              ),
            ),
          ),
          LedgerFieldRow(
            icon: LucideIcons.repeat,
            label: LocaleKeys.txFormRepeats.tr(),
            value: _repeatSummary(),
            placeholder: !_extras.isRecurring,
            onTap: () =>
                setState(() => _extras.isRecurring = !_extras.isRecurring),
            trailing: LedgerToggle(
              key: const ValueKey('ledger-tx-repeat'),
              value: _extras.isRecurring,
              onChanged: (v) => setState(() => _extras.isRecurring = v),
            ),
          ),
          if (_isIncome)
            LedgerFieldRow(
              icon: LucideIcons.rotateCcw,
              label: LocaleKeys.txFormRefund.tr(),
              value: _extras.isRefund
                  ? (_extras.refundOfLabel ?? LocaleKeys.thisIsARefund.tr())
                  : LocaleKeys.none.tr(),
              placeholder: !_extras.isRefund,
              onTap: () => setState(() => _extras.isRefund = !_extras.isRefund),
              trailing: LedgerToggle(
                key: const ValueKey('ledger-tx-refund'),
                value: _extras.isRefund,
                onChanged: (v) => setState(() => _extras.isRefund = v),
              ),
            ),
          LedgerFieldRow(
            icon: LucideIcons.paperclip,
            label: LocaleKeys.txFormAttach.tr(),
            value: attachments.isEmpty
                ? LocaleKeys.none.tr()
                : attachments.length == 1
                    ? _attachmentName(attachments.first)
                    : LocaleKeys.txFormAttachMore.tr(namedArgs: {
                        'name': _attachmentName(attachments.first),
                        'count': '${attachments.length - 1}',
                      }),
            placeholder: attachments.isEmpty,
            divider: false,
            onTap: _openAttachSheet,
            trailing: Container(
              width: 28.lx,
              height: 28.lx,
              decoration: BoxDecoration(
                color: t.surface2,
                border: Border.all(color: t.borderLight),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Icon(
                attachments.isEmpty ? LucideIcons.plus : LucideIcons.image,
                size: 14.lx,
                color: t.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _debtChip(BuildContext context) {
    final party = _party;
    if (party == null) return null;
    final transactions =
        context.select<TransactionCubit, List<TransactionCompleteEntity>>(
      (c) => c.state.transactions,
    );
    ExchangeRateEntity? rates;
    try {
      rates = context.watch<ExchangeRateCubit>().state.entity;
    } catch (_) {
      rates = null;
    }
    final balance = computePartyDebt(
      transactions,
      party.clientId,
      rates: rates,
    );
    if (balance.direction == PartyDebtDirection.settled) return null;
    final code = rates?.baseCode ?? _wallet?.currencyCode;
    if (code == null) return null;
    return LedgerChip(
      LocaleKeys.txFormAmountLeft.tr(namedArgs: {
        'amount': LedgerMoney.format(balance.outstanding, code, short: true),
      }),
      tone: balance.direction == PartyDebtDirection.theyOweYou
          ? LedgerChipTone.good
          : LedgerChipTone.bad,
    );
  }

  Widget _missingText(String text, Color color) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12.5.lx, color: color),
    );
  }
}
