import 'dart:async';

import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class ProposedActionCard extends StatefulWidget {
  final ProposedActionBlock block;
  const ProposedActionCard({super.key, required this.block});

  @override
  State<ProposedActionCard> createState() => ProposedActionCardState();
}

class ProposedActionCardState extends State<ProposedActionCard> {
  final Map<String, dynamic> _edited = {};
  bool _busy = false;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.block.fields) {
      _edited[f.key] = f is CategoriesActionField
          ? (f.initialIds.isEmpty ? const <int>[] : <int>[f.initialIds.first])
          : f.value;
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _isoLocal(DateTime d) =>
      '${d.year}-${_two(d.month)}-${_two(d.day)}T${_two(d.hour)}:${_two(d.minute)}';
  String _fmt(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year} ${_two(d.hour)}:${_two(d.minute)}';

  Map<String, dynamic> _overrides() {
    final o = <String, dynamic>{};
    for (final f in widget.block.fields) {
      final v = _edited[f.key];
      if (v == null) continue;
      if (v is String && v.trim().isEmpty) continue;
      if (v is List && v.isEmpty) continue;
      o[f.key] = v;
    }
    return o;
  }

  Future<void> _confirm() async {
    setState(() => _busy = true);
    await context.read<AiChatCubit>().confirmAction(
          actionId: widget.block.id,
          overrides: _overrides(),
        );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _reject() async {
    setState(() => _busy = true);
    await context.read<AiChatCubit>().rejectAction(actionId: widget.block.id);
    if (mounted) setState(() => _busy = false);
  }

  ActionField? _fieldFor(String key) =>
      widget.block.fields.firstWhereOrNull((f) => f.key == key);

  String _displayOf(String key) {
    final f = _fieldFor(key);
    if (f == null) return '';
    final d = f.display?.trim() ?? '';
    if (d.isNotEmpty && !d.startsWith('#')) return d;
    final v = _edited[key];
    return v is String ? v.trim() : '';
  }

  String? _walletCurrency() {
    final id = _edited['wallet_id'];
    if (id is! num) return null;
    return context
        .watch<WalletCubit>()
        .state
        .wallets
        .firstWhereOrNull((w) => w.id == id.toInt())
        ?.currencyCode;
  }

  String _whenLabel() {
    final raw = _edited['datetime']?.toString();
    final dt = raw == null ? null : DateTime.tryParse(raw);
    final now = DateTime.now();
    final day = dt ?? now;
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return LocaleKeys.chatActionToday.tr();
    }
    return DateFormat.MMMd(context.locale.toLanguageTag()).format(day);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final block = widget.block;
    final pending = block.isPending;
    final amountField = _fieldFor('amount');
    final isTransaction = amountField != null;

    final description = _displayOf('description');
    final title =
        isTransaction && description.isNotEmpty ? description : block.summary;
    final subline = isTransaction
        ? [
            _displayOf('categories'),
            _displayOf('wallet_id'),
            _whenLabel(),
          ].where((p) => p.isNotEmpty).join(' \u00b7 ')
        : (description.isNotEmpty && description != title ? description : '');

    String? amountText;
    if (isTransaction) {
      final raw = _edited['amount'];
      final amount = raw is num ? raw.toDouble() : num.tryParse('$raw');
      if (amount != null) {
        final income = _edited['type']?.toString() == 'income';
        final code = _walletCurrency();
        amountText = code == null
            ? NumberFormat.decimalPatternDigits(decimalDigits: 2).format(amount)
            : LedgerMoney.format(amount.toDouble(), code, sign: income);
      }
    }
    final income = _edited['type']?.toString() == 'income';
    final highRisk = block.risk == 'high';

    final card = Container(
      padding: EdgeInsets.all(10.lx),
      decoration: BoxDecoration(
        color: pending
            ? Color.alphaBlend(
                tones.accentWarm.withValues(alpha: 0.06), tones.bgSurface)
            : tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: pending ? null : Border.all(color: tones.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highRisk) ...[
                Padding(
                  padding: EdgeInsets.only(top: 1.lx),
                  child: Icon(LucideIcons.triangleAlert,
                      size: 14.lx, color: tones.warmText),
                ),
                SizedBox(width: 6.lx),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: tones.textPrimary,
                        fontSize: 13.lx,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subline.isNotEmpty)
                      Text(
                        subline,
                        style: TextStyle(
                          color: tones.textMuted,
                          fontSize: 11.5.lx,
                        ),
                      ),
                  ],
                ),
              ),
              if (amountText != null) ...[
                SizedBox(width: 8.lx),
                LedgerAmount(
                  amountText,
                  size: 13,
                  weight: FontWeight.w600,
                  color: income ? tones.incomeColor : null,
                ),
              ],
            ],
          ),
          if (pending && _editing) ...[
            SizedBox(height: 10.lx),
            for (final f in block.fields)
              Padding(
                padding: EdgeInsets.only(bottom: 8.lx),
                child: _field(tones, f),
              ),
          ],
          if (!pending && !isTransaction) ...[
            SizedBox(height: 6.lx),
            for (final f in block.fields) _readonlyField(tones, f),
          ],
          SizedBox(height: 8.lx),
          if (pending)
            Row(
              children: [
                Expanded(
                  child: LedgerButton(
                    label: LocaleKeys.save.tr(),
                    busy: _busy,
                    onPressed: _busy ? null : _confirm,
                  ),
                ),
                SizedBox(width: 6.lx),
                Expanded(
                  child: _editing
                      ? LedgerButton(
                          label: LocaleKeys.dismiss.tr(),
                          style: LedgerButtonStyle.outline,
                          onPressed: _busy ? null : _reject,
                        )
                      : LedgerButton(
                          label: LocaleKeys.edit.tr(),
                          style: LedgerButtonStyle.outline,
                          onPressed: _busy
                              ? null
                              : () => setState(() => _editing = true),
                        ),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(
                  block.isExecuted
                      ? LucideIcons.circleCheck
                      : LucideIcons.circleX,
                  size: 14.lx,
                  color: block.isExecuted ? tones.brandText : tones.textMuted,
                ),
                SizedBox(width: 6.lx),
                Text(
                  block.isExecuted
                      ? LocaleKeys.done.tr()
                      : LocaleKeys.dismissed.tr(),
                  style: TextStyle(
                    color: block.isExecuted ? tones.brandText : tones.textMuted,
                    fontSize: 12.lx,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    if (!pending) return card;
    return CustomPaint(
      foregroundPainter: _DashedOutline(color: tones.accentWarm),
      child: card,
    );
  }

  Widget _field(AppTones tones, ActionField f) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(f.label,
              style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
        ),
        SizedBox(width: 8.w),
        Expanded(flex: 3, child: _input(tones, f)),
      ],
    );
  }

  /// Searchable currency picker (reuses the app's currency_picker).
  Widget _currencyInput(AppTones tones, CurrencyActionField f) {
    final code = (_edited[f.key]?.toString() ?? '').toUpperCase();
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () => showCurrencyPicker(
        context: context,
        theme: CurrencyPickerThemeData(
          bottomSheetHeight: 0.7.sh,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flagSize: 24.sp,
        ),
        onSelect: (Currency c) => setState(() => _edited[f.key] = c.code),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                code,
                style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
              ),
            ),
            Icon(Icons.expand_more_rounded,
                size: 16.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  Color _accent(AppTones tones) =>
      widget.block.risk == 'high' ? tones.accentWarm : tones.brand.deep;

  /// Wallet type (bank / cash / credit_card / mobile) as a dropdown.
  Widget _walletTypeInput(AppTones tones, WalletTypeActionField f) {
    final current = _edited[f.key]?.toString();
    return CustomDropdownSearch<WalletType>(
      label: "",
      accentColor: _accent(tones),
      selectedItem:
          WalletType.values.firstWhereOrNull((w) => w.serverKey == current),
      showSearchBox: false,
      items: (filter, infiniteScrollProps) => WalletType.values,
      itemAsString: (w) => w.customName,
      onChanged: (v) => setState(() => _edited[f.key] = v?.serverKey),
      compareFn: (i1, i2) => i1 == i2,
    );
  }

  Widget _input(AppTones tones, ActionField f) => switch (f) {
        final CurrencyActionField x => _currencyInput(tones, x),
        final WalletTypeActionField x => _walletTypeInput(tones, x),
        final EnumActionField x => _enumDropdown(tones, x),
        final WalletRefActionField x => _walletDropdown(tones, x),
        final PartyRefActionField x => _partyDropdown(tones, x),
        final NumberActionField x => _numberInput(tones, x),
        final DateTimeActionField x => _datetimeField(tones, x),
        final CategoriesActionField x => _categoryDropdown(tones, x),
        final TextActionField x => _textInput(tones, x),
      };

  Widget _enumDropdown(AppTones tones, EnumActionField f) =>
      CustomDropdownSearch<String>(
        label: "",
        accentColor: _accent(tones),
        selectedItem: f.options.contains(_edited[f.key]?.toString())
            ? _edited[f.key].toString()
            : null,
        showSearchBox: false,
        items: (filter, infiniteScrollProps) => f.options,
        itemAsString: _cap,
        onChanged: (v) => setState(() => _edited[f.key] = v),
        compareFn: (i1, i2) => i1 == i2,
      );

  Widget _walletDropdown(AppTones tones, WalletRefActionField f) {
    final wallets = context
        .watch<WalletCubit>()
        .state
        .wallets
        .where((w) => w.id != null)
        .toList();
    final currentId =
        _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null;
    return CustomDropdownSearch<WalletEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: wallets.firstWhereOrNull((w) => w.id == currentId),
      showSearchBox: false,
      items: (filter, infiniteScrollProps) => wallets,
      itemAsString: (w) => w.name,
      onChanged: (v) => setState(() => _edited[f.key] = v?.id),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
    );
  }

  Widget _partyDropdown(AppTones tones, PartyRefActionField f) {
    final parties = context
        .watch<PartyCubit>()
        .state
        .parties
        .where((p) => p.id != null)
        .toList();
    final currentId =
        _edited[f.key] is num ? (_edited[f.key] as num).toInt() : null;
    return CustomDropdownSearch<PartyEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: parties.firstWhereOrNull((p) => p.id == currentId),
      showClearButton: true,
      items: (filter, infiniteScrollProps) => parties,
      itemAsString: (p) => p.name,
      onChanged: (v) => setState(() => _edited[f.key] = v?.id),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
      filterFn: (p, filter) =>
          p.name.toLowerCase().contains(filter.toLowerCase()),
    );
  }

  Widget _numberInput(AppTones tones, NumberActionField f) => TextFormField(
        initialValue: _edited[f.key]?.toString() ?? '',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
        decoration: _inputDecoration(tones),
        onChanged: (v) => _edited[f.key] = num.tryParse(v) ?? v,
      );

  Widget _textInput(AppTones tones, TextActionField f) => TextFormField(
        initialValue: _edited[f.key]?.toString() ?? '',
        style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
        decoration: _inputDecoration(tones),
        onChanged: (v) => _edited[f.key] = v,
      );

  /// Single category as a dropdown; stored as a one-element list so the
  /// overrides payload shape stays unchanged.
  Widget _categoryDropdown(AppTones tones, CategoriesActionField f) {
    final selected = (_edited[f.key] as List?)?.cast<int>() ?? const <int>[];
    final categories = context
        .watch<CategoryCubit>()
        .state
        .categories
        .where((c) => c.id != null)
        .toList();
    return CustomDropdownSearch<CategoryEntity>(
      label: "",
      accentColor: _accent(tones),
      selectedItem: selected.isEmpty
          ? null
          : categories.firstWhereOrNull((c) => c.id == selected.first),
      showClearButton: true,
      items: (filter, infiniteScrollProps) => categories,
      itemAsString: (c) => c.name,
      onChanged: (v) => setState(
          () => _edited[f.key] = v?.id == null ? const <int>[] : <int>[v!.id!]),
      compareFn: (i1, i2) => i1.clientId == i2.clientId,
      filterFn: (c, filter) =>
          c.name.toLowerCase().contains(filter.toLowerCase()),
    );
  }

  Widget _datetimeField(AppTones tones, DateTimeActionField f) {
    final raw = _edited[f.key]?.toString() ?? '';
    final dt = DateTime.tryParse(raw);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final base = dt ?? now;
        final date = await showDatePicker(
          context: context,
          initialDate: base,
          firstDate: DateTime(2000),
          lastDate: DateTime(now.year + 1),
        );
        if (date == null || !mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(base),
        );
        final picked = DateTime(date.year, date.month, date.day,
            time?.hour ?? base.hour, time?.minute ?? base.minute);
        setState(() => _edited[f.key] = _isoLocal(picked));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dt != null ? _fmt(dt) : '',
                style: TextStyle(fontSize: 12.sp, color: tones.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 14.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppTones tones) => InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
      );

  Widget _readonlyField(AppTones tones, ActionField f) {
    final display = (f.display != null && f.display!.isNotEmpty)
        ? f.display!
        : '${f.value ?? ''}';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(f.label,
                style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: Text(
              display,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: tones.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedOutline extends CustomPainter {
  final Color color;
  _DashedOutline({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        (Offset.zero & size).deflate(0.5),
        const Radius.circular(AppRadii.md),
      ));
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedOutline old) => old.color != color;
}
