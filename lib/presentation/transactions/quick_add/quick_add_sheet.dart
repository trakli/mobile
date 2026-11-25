import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/ai_chat/dictation/dictation_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/quick_add/quick_add_parser.dart';
import 'package:trakli/presentation/transfers/wallet_transfer_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showSnackBar;
import 'package:trakli/presentation/utils/ledger/ledger_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

Future<void> showQuickAddSheet(BuildContext context, {String? initialText}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => BlocProvider(
      create: (_) => getIt<DictationCubit>(),
      child: QuickAddSheet(initialText: initialText),
    ),
  );
}

enum _QuickType { expense, income, transfer }

class QuickAddSheet extends StatefulWidget {
  final String? initialText;

  /// Fixed clock for tests and screenshots.
  final DateTime? now;

  const QuickAddSheet({super.key, this.initialText, this.now});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final _text = TextEditingController();
  _QuickType _type = _QuickType.expense;
  bool _typeTouched = false;
  String _keypad = '';
  bool _keypadTouched = false;
  QuickAddParse _parse = const QuickAddParse();

  CategoryEntity? _category;
  WalletEntity? _wallet;
  PartyEntity? _party;
  GroupEntity? _group;
  DateTime? _date;
  TimeOfDay? _time;
  bool _partyCleared = false;
  bool _saving = false;

  DateTime get _now => widget.now ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _text.text = widget.initialText!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onText(_text.text);
      });
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  QuickAddParser _parser() {
    return QuickAddParser(
      categories: context.read<CategoryCubit>().state.categories,
      wallets: context.read<WalletCubit>().state.wallets,
      parties: context.read<PartyCubit>().state.parties,
      history: context.read<TransactionCubit>().state.transactions,
    );
  }

  void _onText(String value) {
    final parse = _parser().parse(value, now: _now);
    setState(() {
      _parse = parse;
      if (!_keypadTouched) {
        _keypad = parse.amount == null ? '' : _trimAmount(parse.amount!);
      }
      final hint = parse.typeHint;
      if (!_typeTouched && hint != null) {
        _type = hint == TransactionType.income
            ? _QuickType.income
            : _QuickType.expense;
      }
    });
  }

  String _trimAmount(double v) {
    final s = v.toStringAsFixed(2);
    return s.endsWith('.00') ? s.substring(0, s.length - 3) : s;
  }

  TransactionType get _txType => _type == _QuickType.income
      ? TransactionType.income
      : TransactionType.expense;

  double? get _amount => double.tryParse(_keypad);

  WalletEntity? _effectiveWallet(List<WalletEntity> wallets) {
    if (_wallet != null) return _wallet;
    if (_parse.wallet != null) return _parse.wallet;
    final defaultId = context
        .read<ConfigCubit>()
        .state
        .getConfigByKey(ConfigConstants.defaultWallet)
        ?.value as String?;
    return wallets.firstWhereOrNull((w) => w.clientId == defaultId) ??
        wallets.firstOrNull;
  }

  CategoryEntity? get _effectiveCategory {
    final c = _category ?? _parse.category;
    if (c == null || c.type != _txType) return _category;
    return c;
  }

  PartyEntity? get _effectiveParty =>
      _partyCleared ? null : (_party ?? _parse.party);

  DateTime get _effectiveDate {
    final d = _date ?? _parse.date ?? _now;
    final time = _time ?? TimeOfDay.fromDateTime(_now);
    return DateTime(d.year, d.month, d.day, time.hour, time.minute);
  }

  void _tapKey(String key) {
    setState(() {
      _keypadTouched = true;
      if (key == 'del') {
        if (_keypad.isNotEmpty) {
          _keypad = _keypad.substring(0, _keypad.length - 1);
        }
        return;
      }
      if (key == '.') {
        if (_keypad.contains('.')) return;
        _keypad = _keypad.isEmpty ? '0.' : '$_keypad.';
        return;
      }
      final dot = _keypad.indexOf('.');
      if (dot >= 0 && _keypad.length - dot > 2) return;
      if (_keypad == '0') {
        _keypad = key;
      } else if (_keypad.length < 12) {
        _keypad += key;
      }
    });
  }

  String _dateLabel(DateTime d) {
    final n = _now;
    final today = DateTime(n.year, n.month, n.day);
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return LocaleKeys.homeToday.tr();
    if (day == today.subtract(const Duration(days: 1))) {
      return LocaleKeys.quickAddYesterday.tr();
    }
    return DateFormat(
            'EEE, MMM d', Localizations.localeOf(context).toLanguageTag())
        .format(d);
  }

  Future<(T?,)?> _pick<T>({
    required String title,
    required List<T?> items,
    required String Function(T?) label,
    required Widget Function(T?) leading,
    T? selected,
  }) {
    return showModalBottomSheet<(T?,)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PickerSheet<T>(
        title: title,
        items: items,
        label: label,
        leading: leading,
        selected: selected,
      ),
    );
  }

  Future<void> _pickCategory() async {
    final cats = context
        .read<CategoryCubit>()
        .state
        .categories
        .where((c) => c.type == _txType)
        .toList();
    final picked = await _pick<CategoryEntity>(
      title: LocaleKeys.quickAddPickCategory.tr(),
      items: cats,
      label: (c) => c!.name,
      leading: (c) => LedgerCoin(media: c!.icon),
      selected: _effectiveCategory,
    );
    if (picked?.$1 != null) setState(() => _category = picked!.$1);
  }

  Future<void> _pickWallet() async {
    final wallets = context.read<WalletCubit>().state.wallets;
    final picked = await _pick<WalletEntity>(
      title: LocaleKeys.quickAddPickWallet.tr(),
      items: wallets,
      label: (w) => w!.name,
      leading: (w) => LedgerCoin(icon: ledgerWalletIcon(w!.type)),
      selected: _effectiveWallet(wallets),
    );
    if (picked?.$1 != null) setState(() => _wallet = picked!.$1);
  }

  Future<void> _pickParty() async {
    final parties = context.read<PartyCubit>().state.parties;
    final picked = await _pick<PartyEntity>(
      title: LocaleKeys.quickAddPickPerson.tr(),
      items: [null, ...parties],
      label: (p) => p?.name ?? LocaleKeys.quickAddNone.tr(),
      leading: (p) => p == null
          ? const LedgerCoin(icon: LucideIcons.x)
          : LedgerInitials(p.name, size: 32),
      selected: _effectiveParty,
    );
    if (!mounted || picked == null) return;
    setState(() {
      _party = picked.$1;
      _partyCleared = picked.$1 == null;
    });
  }

  Future<void> _pickGroup() async {
    final groups = context.read<GroupCubit>().state.groups;
    final picked = await _pick<GroupEntity>(
      title: LocaleKeys.quickAddPickGroup.tr(),
      items: [null, ...groups],
      label: (g) => g?.name ?? LocaleKeys.quickAddNone.tr(),
      leading: (g) => g == null
          ? const LedgerCoin(icon: LucideIcons.x)
          : LedgerCoin(media: g.icon, icon: LucideIcons.folder),
      selected: _group,
    );
    if (picked != null) setState(() => _group = picked.$1);
  }

  Future<void> _pickDate() async {
    final n = _now;
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(n.year + 1, 12, 31),
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_effectiveDate),
    );
    if (time != null && mounted) setState(() => _time = time);
  }

  String _whenLabel(DateTime d) {
    final day = _dateLabel(d);
    if (_time == null) return day;
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      _time!,
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    return '$day · $time';
  }

  void _openFullForm() {
    final wallets = context.read<WalletCubit>().state.wallets;
    final navigator = Navigator.of(context);
    navigator.pop();
    AppNavigator.push(
      navigator.context,
      AddTransactionScreen(
        transactionType: _txType,
        initialAmount: _amount,
        initialDescription: _description(),
        initialCategory: _effectiveCategory,
        initialWallet: _effectiveWallet(wallets),
        initialParty: _effectiveParty,
        initialDate: _effectiveDate,
      ),
    );
  }

  void _openTransfer() {
    final navigator = Navigator.of(context);
    navigator.pop();
    AppNavigator.push(navigator.context, const WalletTransferScreen());
  }

  String _description() {
    if (_parse.description.isNotEmpty) return _parse.description;
    return _effectiveCategory?.name ?? '';
  }

  void _save(WalletEntity? wallet) {
    final amount = _amount;
    if (amount == null || amount <= 0) {
      showSnackBar(message: LocaleKeys.quickAddNeedAmount.tr());
      return;
    }
    if (wallet == null) {
      showSnackBar(message: LocaleKeys.quickAddNoWallet.tr());
      return;
    }
    setState(() => _saving = true);
    context.read<TransactionCubit>().addTransaction(
          amount: amount,
          description: _description(),
          categoryIds: [
            if (_effectiveCategory != null) _effectiveCategory!.clientId,
          ],
          type: _txType,
          datetime: _effectiveDate,
          walletClientId: wallet.clientId,
          partyClientId: _effectiveParty?.clientId,
          groupClientId: _group?.clientId,
        );
  }

  void _onDictation(BuildContext context, DictationState state) {
    if (state.recognizedWords.isNotEmpty &&
        state.recognizedWords != _text.text) {
      _text.text = state.recognizedWords;
      _text.selection = TextSelection.collapsed(offset: _text.text.length);
      _onText(_text.text);
    }
    if (state.error != DictationError.none) {
      showSnackBar(
        message: switch (state.error) {
          DictationError.permissionDenied =>
            LocaleKeys.aiChatDictationPermissionDenied.tr(),
          DictationError.unavailable =>
            LocaleKeys.aiChatDictationUnavailable.tr(),
          _ => LocaleKeys.aiChatDictationFailed.tr(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final wallet = _effectiveWallet(wallets);
    final currency = wallet?.currencyCode ?? 'EUR';
    final amount = _amount ?? 0;
    final amountText = LedgerMoney.format(
      amount,
      currency,
      decimals: _keypad.contains('.') || _keypad.isEmpty
          ? null
          : LedgerMoney.decimalsFor(currency),
    );
    final category = _effectiveCategory;
    final party = _effectiveParty;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<TransactionCubit, TransactionState>(
      listenWhen: (a, b) => _saving && a.isSaving && !b.isSaving,
      listener: (context, state) {
        setState(() => _saving = false);
        if (state.failure.hasError) {
          showSnackBar(message: state.failure.customMessage);
        } else {
          Navigator.of(context).pop();
          showSnackBar(message: LocaleKeys.quickAddSaved.tr(), isSuccess: true);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: t.bgSurface,
            border: Border(top: BorderSide(color: t.borderLight)),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 14.lx),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LedgerSheetHandle(),
                  SizedBox(height: 10.lx),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LedgerSeg<_QuickType>(
                      options: [
                        LedgerSegOption(_QuickType.expense,
                            LocaleKeys.transactionExpense.tr()),
                        LedgerSegOption(_QuickType.income,
                            LocaleKeys.transactionIncome.tr()),
                        LedgerSegOption(
                            _QuickType.transfer, LocaleKeys.transfer.tr()),
                      ],
                      selected: _type,
                      onChanged: (v) {
                        if (v == _QuickType.transfer) {
                          _openTransfer();
                          return;
                        }
                        setState(() {
                          _type = v;
                          _typeTouched = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10.lx),
                  LedgerBigNumber(
                    amountText,
                    size: 40,
                    color: _type == _QuickType.income ? t.incomeColor : null,
                  ),
                  SizedBox(height: 10.lx),
                  _SentenceField(
                    controller: _text,
                    onChanged: _onText,
                    onDictation: _onDictation,
                  ),
                  SizedBox(height: 10.lx),
                  LedgerChipRow(
                    children: [
                      LedgerFilterChip(
                        key: const ValueKey('quick-add-category'),
                        label: category?.name ?? LocaleKeys.category.tr(),
                        leading: LedgerMediaIcon(
                          media: category?.icon,
                          size: 13,
                        ),
                        selected: category != null,
                        muted: category == null,
                        onTap: _pickCategory,
                      ),
                      LedgerFilterChip(
                        key: const ValueKey('quick-add-wallet'),
                        label: wallet?.name ?? LocaleKeys.wallet.tr(),
                        icon: wallet == null
                            ? LucideIcons.wallet
                            : ledgerWalletIcon(wallet.type),
                        onTap: _pickWallet,
                      ),
                      if (party != null)
                        LedgerFilterChip(
                          label: party.name,
                          icon: party.type == null ||
                                  party.type == PartyType.individual
                              ? LucideIcons.userRound
                              : LucideIcons.store,
                          onTap: _pickParty,
                        ),
                      LedgerFilterChip(
                        label: _whenLabel(_effectiveDate),
                        onTap: _pickDate,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.lx),
                  LedgerChipRow(
                    children: [
                      if (party == null)
                        LedgerFilterChip(
                          label: LocaleKeys.quickAddPerson.tr(),
                          icon: LucideIcons.userRound,
                          onTap: _pickParty,
                        ),
                      LedgerFilterChip(
                        label: _group?.name ?? LocaleKeys.group.tr(),
                        icon: LucideIcons.folder,
                        onTap: _pickGroup,
                      ),
                      LedgerFilterChip(
                        label: LocaleKeys.quickAddRepeat.tr(),
                        icon: LucideIcons.repeat,
                        onTap: _openFullForm,
                      ),
                      LedgerFilterChip(
                        label: LocaleKeys.quickAddAttach.tr(),
                        icon: LucideIcons.paperclip,
                        onTap: _openFullForm,
                      ),
                      LedgerFilterChip(
                        key: const ValueKey('quick-add-more'),
                        label: LocaleKeys.quickAddMore.tr(),
                        icon: LucideIcons.slidersHorizontal,
                        onTap: _openFullForm,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.lx),
                  _Keypad(onKey: _tapKey),
                  SizedBox(height: 10.lx),
                  LedgerButton(
                    key: const ValueKey('quick-add-save'),
                    label: LocaleKeys.quickAddSave
                        .tr(namedArgs: {'amount': amountText}),
                    icon: LucideIcons.check,
                    large: true,
                    busy: _saving,
                    onPressed: () => _save(wallet),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SentenceField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final void Function(BuildContext, DictationState) onDictation;

  const _SentenceField({
    required this.controller,
    required this.onChanged,
    required this.onDictation,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final dictation = context.watch<DictationCubit?>();
    final listening = dictation?.state.isActive ?? false;
    final field = LedgerCard(
      padding: EdgeInsets.symmetric(horizontal: 10.lx, vertical: 2.lx),
      borderColor: listening ? t.brandText : null,
      child: Row(
        children: [
          Icon(LucideIcons.penLine, size: 16.lx, color: t.textMuted),
          SizedBox(width: 8.lx),
          Expanded(
            child: TextField(
              key: const ValueKey('quick-add-sentence'),
              controller: controller,
              onChanged: onChanged,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 13.lx, color: t.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9.lx),
                hintText: listening
                    ? LocaleKeys.aiChatDictationListening.tr()
                    : LocaleKeys.quickAddHint.tr(),
                hintStyle: TextStyle(fontSize: 13.lx, color: t.textMuted),
              ),
            ),
          ),
          if (dictation != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => dictation.toggle(
                languageCode: Localizations.localeOf(context).languageCode,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8.lx),
                child: Icon(
                  listening ? LucideIcons.micOff : LucideIcons.mic,
                  size: 16.lx,
                  color: listening ? t.brandText : t.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
    if (dictation == null) return field;
    return BlocListener<DictationCubit, DictationState>(
      listenWhen: (a, b) =>
          a.recognizedWords != b.recognizedWords ||
          (a.error != b.error && b.error != DictationError.none),
      listener: onDictation,
      child: field,
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const _Keypad({required this.onKey});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'del'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6.lx,
      crossAxisSpacing: 6.lx,
      childAspectRatio: 2.3,
      children: [
        for (final k in keys)
          Material(
            color: t.surface2,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('quick-add-key-$k'),
              onTap: () => onKey(k),
              child: Center(
                child: k == 'del'
                    ? Icon(
                        LucideIcons.delete,
                        size: 18.lx,
                        color: t.textPrimary,
                        semanticLabel: LocaleKeys.quickAddDelete.tr(),
                      )
                    : Text(
                        k,
                        style: LedgerText.money(
                          size: 17.lx,
                          weight: FontWeight.w600,
                          color: t.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T?> items;
  final String Function(T?) label;
  final Widget Function(T?) leading;
  final T? selected;

  const _PickerSheet({
    required this.title,
    required this.items,
    required this.label,
    required this.leading,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: t.bgSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 14.lx),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LedgerSheetHandle(),
            SizedBox(height: 10.lx),
            LedgerH6(title),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final item in items)
                    LedgerRow(
                      leading: leading(item),
                      title: label(item),
                      divider: item != items.last,
                      trailing: item == selected
                          ? Icon(LucideIcons.check,
                              size: 16.lx, color: t.brandText)
                          : null,
                      onTap: () => Navigator.of(context).pop((item,)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
