import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class AddWalletForm extends StatefulWidget {
  final WalletEntity? wallet;

  const AddWalletForm({
    super.key,
    this.wallet,
  });

  @override
  State<AddWalletForm> createState() => _AddWalletFormState();
}

class _AddWalletFormState extends State<AddWalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  late WalletType _selectedType;
  Currency? currency;
  MediaEntity? mediaEntity;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.wallet?.type ?? WalletType.cash;
    currency = context.read<CurrencyCubit>().state.currency;

    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _descriptionController.text = widget.wallet!.description ?? '';
      currency = widget.wallet!.currency ?? currency;
      mediaEntity = widget.wallet?.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final walletCubit = context.read<WalletCubit>();

      // Parse balance with default value of 0.0 if empty
      final balanceText = _balanceController.text.trim();
      final balance =
          balanceText.isEmpty ? 0.0 : (double.tryParse(balanceText) ?? 0.0);

      if (widget.wallet != null) {
        // Update existing wallet
        walletCubit.updateWallet(
          clientId: widget.wallet!.clientId,
          name: _nameController.text,
          type: _selectedType,
          balance: balance,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          icon: mediaEntity,
        );
      } else {
        if (currency == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.pleaseSelectCurrency.tr()),
            ),
          );
          return;
        }
        // Create new wallet
        walletCubit.addWallet(
          name: _nameController.text,
          type: _selectedType,
          balance: balance,
          currency: currency!.code,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          icon: mediaEntity,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Close only once the write landed: a rejected duplicate name has to
    // stay on screen with its message.
    return BlocListener<WalletCubit, WalletState>(
      listenWhen: (previous, current) => previous.isSaving != current.isSaving,
      listener: (context, state) {
        if (state.failure.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.maybeMap(
                orElse: () => state.failure.customMessage,
                duplicate: (_) => LocaleKeys.walletNameAlreadyExists.tr(),
              )),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (!state.isSaving && !state.failure.hasError) {
          AppNavigator.pop(context);
        }
      },
      child: _form(context),
    );
  }

  void _pickIcon() {
    showCustomBottomSheet(
      context,
      color: Theme.of(context).scaffoldBackgroundColor,
      widget: SelectIconBottomSheet(
        onSelect: (mediaType, image) {
          setState(() {
            mediaEntity = MediaEntity(content: image, mediaType: mediaType);
          });
        },
      ),
    );
  }

  void _pickCurrency() {
    showCurrencyPicker(
      context: context,
      theme: ledgerCurrencyPickerTheme(context),
      onSelect: (value) => setState(() => currency = value),
    );
  }

  Future<void> _pickType() async {
    final picked = await showLedgerOptionsSheet<WalletType>(
      context,
      title: LocaleKeys.type.tr(),
      selected: _selectedType,
      options: [
        for (final type in WalletType.values)
          LedgerOption(type, type.customName),
      ],
    );
    if (picked != null) setState(() => _selectedType = picked);
  }

  Widget _form(BuildContext context) {
    final editing = widget.wallet != null;
    final code = currency?.code ?? widget.wallet?.currencyCode ?? 'XAF';

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
        children: [
          LedgerNameCard(
            controller: _nameController,
            hint: LocaleKeys.enterName.tr(),
            media: mediaEntity,
            onPickIcon: _pickIcon,
            validator: (value) => value == null || value.isEmpty
                ? LocaleKeys.nameIsRequired.tr()
                : null,
          ),
          SizedBox(height: 12.lx),
          LedgerFieldsCard(
            children: [
              LedgerFieldRow(
                icon: LucideIcons.wallet,
                label: LocaleKeys.balance.tr(),
                value: editing
                    ? LedgerMoney.format(widget.wallet!.balance, code)
                    : LocaleKeys.balanceWillBeSetToZero.tr(),
                placeholder: !editing,
              ),
              LedgerFieldRow(
                icon: LucideIcons.coins,
                label: LocaleKeys.formCurrency.tr(),
                value: code,
                chevron: !editing,
                onTap: editing ? null : _pickCurrency,
              ),
              LedgerFieldRow(
                icon: LucideIcons.layers,
                label: LocaleKeys.type.tr(),
                value: _selectedType.customName,
                chevron: true,
                onTap: _pickType,
              ),
              LedgerFieldRow(
                icon: LucideIcons.textAlignStart,
                label: LocaleKeys.formDescription.tr(),
                divider: false,
                valueWidget: LedgerInlineField(
                  controller: _descriptionController,
                  hint: LocaleKeys.typeHere.tr(),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.lx),
          BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) => LedgerButton(
              label: editing
                  ? LocaleKeys.updateWallet.tr()
                  : LocaleKeys.createWallet.tr(),
              icon: editing ? LucideIcons.check : LucideIcons.plus,
              large: true,
              busy: state.isSaving,
              onPressed: () {
                hideKeyBoard();
                _submitForm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
