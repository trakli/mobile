import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

/// Result of [showLedgerPicker]; a null [value] means the user cleared the
/// field, while a null result means the sheet was dismissed.
class LedgerPick<T> {
  final T? value;
  const LedgerPick(this.value);
}

Future<LedgerPick<T>?> showLedgerPicker<T>(
  BuildContext context, {
  required String title,
  required List<T> Function(BuildContext context) items,
  required String Function(T item) label,
  String Function(T item)? subtitle,
  Widget Function(T item)? leading,
  bool Function(T item)? isSelected,
  bool searchable = false,
  bool allowClear = false,
  void Function(BuildContext context)? onAddNew,
}) {
  final providers = <BlocProvider>[
    if (_find<WalletCubit>(context) case final c?)
      BlocProvider<WalletCubit>.value(value: c),
    if (_find<CategoryCubit>(context) case final c?)
      BlocProvider<CategoryCubit>.value(value: c),
    if (_find<PartyCubit>(context) case final c?)
      BlocProvider<PartyCubit>.value(value: c),
    if (_find<GroupCubit>(context) case final c?)
      BlocProvider<GroupCubit>.value(value: c),
  ];
  return showModalBottomSheet<LedgerPick<T>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => MultiBlocProvider(
      providers: providers,
      child: _LedgerPickerSheet<T>(
        title: title,
        items: items,
        label: label,
        subtitle: subtitle,
        leading: leading,
        isSelected: isSelected,
        searchable: searchable,
        allowClear: allowClear,
        onAddNew: onAddNew,
      ),
    ),
  );
}

T? _find<T extends StateStreamableSource<Object?>>(BuildContext context) {
  try {
    return BlocProvider.of<T>(context, listen: false);
  } catch (_) {
    return null;
  }
}

class _LedgerPickerSheet<T> extends StatefulWidget {
  final String title;
  final List<T> Function(BuildContext context) items;
  final String Function(T item) label;
  final String Function(T item)? subtitle;
  final Widget Function(T item)? leading;
  final bool Function(T item)? isSelected;
  final bool searchable;
  final bool allowClear;
  final void Function(BuildContext context)? onAddNew;

  const _LedgerPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.label,
    this.subtitle,
    this.leading,
    this.isSelected,
    required this.searchable,
    required this.allowClear,
    this.onAddNew,
  });

  @override
  State<_LedgerPickerSheet<T>> createState() => _LedgerPickerSheetState<T>();
}

class _LedgerPickerSheetState<T> extends State<_LedgerPickerSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final all = widget.items(context);
    final q = _query.trim().toLowerCase();
    final shown = q.isEmpty
        ? all
        : all.where((i) => widget.label(i).toLowerCase().contains(q)).toList();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 12.lx),
              LedgerH6(
                widget.title,
                actionLabel: widget.allowClear
                    ? LocaleKeys.txFormClear.tr()
                    : null,
                onAction: () => Navigator.of(context).pop(LedgerPick<T>(null)),
              ),
              if (widget.searchable) ...[
                SizedBox(height: 10.lx),
                TextField(
                  autofocus: false,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(fontSize: 13.5.lx, color: t.textPrimary),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: LocaleKeys.search.tr(),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 16.lx,
                      color: t.textMuted,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.lx,
                      vertical: 9.lx,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 6.lx),
              Flexible(
                child: shown.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.lx),
                        child: Text(
                          LocaleKeys.txFormNoMatches.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.lx,
                            color: t.textMuted,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: shown.length,
                        itemBuilder: (context, i) {
                          final item = shown[i];
                          final selected =
                              widget.isSelected?.call(item) ?? false;
                          return LedgerRow(
                            leading: widget.leading?.call(item),
                            title: widget.label(item),
                            subtitle: widget.subtitle?.call(item),
                            titleStyle: TextStyle(
                              fontSize: 13.5.lx,
                              color: t.textPrimary,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            divider: i != shown.length - 1,
                            trailing: selected
                                ? Icon(
                                    LucideIcons.check,
                                    size: 16.lx,
                                    color: t.brandText,
                                  )
                                : null,
                            onTap: () =>
                                Navigator.of(context).pop(LedgerPick<T>(item)),
                          );
                        },
                      ),
              ),
              if (widget.onAddNew != null) ...[
                SizedBox(height: 10.lx),
                LedgerButton(
                  label: LocaleKeys.txFormAddNew.tr(),
                  icon: LucideIcons.plus,
                  style: LedgerButtonStyle.outline,
                  onPressed: () => widget.onAddNew!(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
