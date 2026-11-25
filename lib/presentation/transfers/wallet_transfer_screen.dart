import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/exchange_rate_formatter.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/locale_keys.g.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/remote_config/cubit/remote_config_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletTransferScreen extends StatefulWidget {
  const WalletTransferScreen({
    super.key,
    this.initialFromWalletClientId,
    this.embedded = false,
    this.onSavedSuccessfully,
  });

  final String? initialFromWalletClientId;

  /// When true, omits the Scaffold + AppBar so this can be embedded inside
  /// another screen (e.g. as a tab inside [AddTransactionScreen]).
  final bool embedded;

  /// Called after a successful save. Defaults to `Navigator.pop()` when null.
  final VoidCallback? onSavedSuccessfully;

  @override
  State<WalletTransferScreen> createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  Currency? currency;
  WalletEntity? selectedFromWallet;
  WalletEntity? selectedToWallet;
  DateTime _selectedTransferDate = DateTime.now();
  TimeOfDay _selectedTransferTime = TimeOfDay.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _transferDateController = TextEditingController();
  final TextEditingController _transferTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double _minimumTransferAmount(BuildContext context) =>
      context.read<RemoteConfigCubit>().state.config.minimumTransferAmount;

  String _minimumTransferAmountForLocale(BuildContext context) {
    final value = _minimumTransferAmount(context);
    final fixed = value.toStringAsFixed(6);
    return fixed.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  final DateFormat _transferDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _transferTimeFormat = DateFormat('h:mm a');

  void _syncTransferDateTimeControllers() {
    final combinedDateTime = DateTime(
      _selectedTransferDate.year,
      _selectedTransferDate.month,
      _selectedTransferDate.day,
      _selectedTransferTime.hour,
      _selectedTransferTime.minute,
    );
    _transferDateController.text = _transferDateFormat.format(combinedDateTime);
    _transferTimeController.text = _transferTimeFormat.format(combinedDateTime);
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _exchangeRateController.addListener(() => setState(() {}));
    _syncTransferDateTimeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallets = context.read<WalletCubit>().state.wallets;
      if (wallets.isNotEmpty) {
        setState(() {
          // If an initial wallet is provided, use it as the source wallet
          selectedFromWallet = widget.initialFromWalletClientId == null
              ? wallets.first
              : wallets.firstWhere(
                  (w) => w.clientId == widget.initialFromWalletClientId,
                  orElse: () => wallets.first,
                );

          // Default destination wallet: first wallet with a different clientId
          selectedToWallet = wallets.firstWhere(
            (w) => w.clientId != selectedFromWallet!.clientId,
            orElse: () => wallets.length > 1 ? wallets[1] : selectedFromWallet!,
          );

          _prefillExchangeRate();
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _exchangeRateController.dispose();
    _transferDateController.dispose();
    _transferTimeController.dispose();
    super.dispose();
  }

  /// Null when no rate is known — the field stays empty, never a silent 1:1.
  double? _defaultRateFor(WalletEntity? from, WalletEntity? to) {
    if (from == null || to == null) return null;
    if (from.currencyCode == to.currencyCode) return 1.0;
    final entity = context.read<ExchangeRateCubit>().state.entity;
    final fromRate = entity?.rates[from.currencyCode];
    final toRate = entity?.rates[to.currencyCode];
    if (fromRate == null || toRate == null) return null;
    return toRate / fromRate;
  }

  void _prefillExchangeRate() {
    final rate = _defaultRateFor(selectedFromWallet, selectedToWallet);
    _exchangeRateController.text =
        rate == null ? '' : formatExchangeRateForDisplay(rate);
  }

  Future<void> _showWalletSelector({
    required bool isFromWallet,
    required List<WalletEntity> availableWallets,
  }) async {
    final current = isFromWallet ? selectedFromWallet : selectedToWallet;
    final picked = await showLedgerOptionsSheet<String>(
      context,
      title: isFromWallet
          ? LocaleKeys.selectSourceWallet.tr()
          : LocaleKeys.selectDestinationWallet.tr(),
      selected: current?.clientId,
      options: [
        for (final w in availableWallets)
          LedgerOption(
            w.clientId,
            w.name,
            subtitle: LedgerMoney.format(w.balance, w.currencyCode),
            leading: LedgerCoin(icon: LucideIcons.wallet, media: w.icon),
          ),
      ],
    );
    if (picked == null || !mounted) return;
    final wallet = availableWallets.firstWhere((w) => w.clientId == picked);
    setState(() {
      if (isFromWallet) {
        selectedFromWallet = wallet;
      } else {
        selectedToWallet = wallet;
      }
      _prefillExchangeRate();
    });
  }

  String? _validateForm() {
    final wallets = context.read<WalletCubit>().state.wallets;
    final minTransferAmount = _minimumTransferAmount(context);

    if (wallets.isEmpty) {
      return LocaleKeys.noWalletsAvailable.tr();
    }

    if (selectedFromWallet == null) {
      return LocaleKeys.selectSourceWallet.tr();
    }

    if (selectedToWallet == null) {
      return LocaleKeys.selectDestinationWallet.tr();
    }

    if (selectedFromWallet?.clientId == selectedToWallet?.clientId) {
      return LocaleKeys.cannotTransferToSameWallet.tr();
    }

    if (_amountController.text.isEmpty) {
      return LocaleKeys.amountRequired.tr();
    }

    final amount = parseAmount(_amountController.text.trim());
    if (amount < minTransferAmount) {
      return LocaleKeys.amountNotZero.tr(
        namedArgs: {'minAmount': _minimumTransferAmountForLocale(context)},
      );
    }

    // Validate destination/received amount too (for cross-currency transfers).
    double exchangeRate = 1.0;
    if (selectedFromWallet != null &&
        selectedToWallet != null &&
        selectedFromWallet!.currencyCode != selectedToWallet!.currencyCode) {
      final parsedRate = parseAmount(_exchangeRateController.text.trim());
      if (parsedRate <= 0) {
        return LocaleKeys.exchangeRateRequired.tr();
      }
      exchangeRate = parsedRate;
    }
    final receiveAmount = (selectedFromWallet != null &&
            selectedToWallet != null &&
            selectedFromWallet!.currencyCode == selectedToWallet!.currencyCode)
        ? amount
        : amount * exchangeRate;

    if (receiveAmount < minTransferAmount) {
      return LocaleKeys.amountNotZero.tr(
        namedArgs: {'minAmount': _minimumTransferAmountForLocale(context)},
      );
    }

    if (selectedFromWallet != null && amount > selectedFromWallet!.balance) {
      return LocaleKeys.insufficientBalance.tr();
    }

    return null;
  }

  void _performTransfer() {
    hideKeyBoard();

    final validationError = _validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final amount = parseAmount(_amountController.text.trim());

      double exchangeRate = 1.0;
      if (selectedFromWallet != null &&
          selectedToWallet != null &&
          selectedFromWallet!.currencyCode != selectedToWallet!.currencyCode) {
        final parsedRate = parseAmount(_exchangeRateController.text.trim());
        if (parsedRate <= 0) return;
        exchangeRate = parsedRate;
      }

      final receiveAmount = (selectedFromWallet != null &&
              selectedToWallet != null &&
              selectedFromWallet!.currencyCode ==
                  selectedToWallet!.currencyCode)
          ? amount
          : amount * exchangeRate;

      final minTransferAmount = _minimumTransferAmount(context);
      if (amount < minTransferAmount || receiveAmount < minTransferAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.amountNotZero.tr(
                namedArgs: {
                  'minAmount': _minimumTransferAmountForLocale(context)
                },
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final now = getNewFormattedUtcDateTime();
      final selectedDateTime = DateTime(
        _selectedTransferDate.year,
        _selectedTransferDate.month,
        _selectedTransferDate.day,
        _selectedTransferTime.hour,
        _selectedTransferTime.minute,
      );
      final transferDateTime =
          getFormattedUtcDateTimeFromUtc(selectedDateTime.toUtc());

      final transfer = TransferEntity(
        clientId: '',
        amount: amount,
        datetime: transferDateTime,
        createdAt: now,
        updatedAt: now,
        exchangeRate: exchangeRate,
        fromWalletClientId: selectedFromWallet!.clientId,
        toWalletClientId: selectedToWallet!.clientId,
      );

      final transactionDescription =
          LocaleKeys.walletTransferDefaultDescription.tr(
        namedArgs: {
          'fromCurrency': selectedFromWallet!.currencyCode,
          'toCurrency': selectedToWallet!.currencyCode,
        },
      );

      context.read<TransferCubit>().addTransfer(
            transfer,
            transactionDescription: transactionDescription,
          );
    }
  }

  bool get _crossCurrency =>
      selectedFromWallet != null &&
      selectedToWallet != null &&
      selectedFromWallet!.currencyCode != selectedToWallet!.currencyCode;

  String _receivesText() {
    final amount = parseAmount(_amountController.text.trim());
    final rate = parseAmount(_exchangeRateController.text.trim());
    final formatted = rate > 0
        ? LedgerMoney.format(amount * rate, selectedToWallet!.currencyCode)
        : '…';
    return LocaleKeys.destinationWalletWillReceive
        .tr(namedArgs: {'amount': formatted});
  }

  Widget _walletRow({
    required String label,
    required WalletEntity? wallet,
    required bool isFromWallet,
    required bool divider,
  }) {
    final t = context.tones;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final available = isFromWallet
        ? wallets
        : wallets
            .where((w) => w.clientId != selectedFromWallet?.clientId)
            .toList();
    return LedgerRow(
      leading: LedgerCoin(icon: LucideIcons.wallet, media: wallet?.icon),
      title: wallet?.name ?? LocaleKeys.selectWallet.tr(),
      subtitle: label,
      divider: divider,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (wallet != null)
            Text(
              LedgerMoney.format(wallet.balance, wallet.currencyCode),
              style: LedgerText.money(size: 13.lx, color: t.textSecondary),
            ),
          SizedBox(width: 6.lx),
          Icon(LucideIcons.chevronDown, size: 16.lx, color: t.textMuted),
        ],
      ),
      onTap: available.isEmpty
          ? null
          : () => _showWalletSelector(
                isFromWallet: isFromWallet,
                availableWallets: available,
              ),
    );
  }

  void _swapWallets() {
    if (selectedFromWallet == null || selectedToWallet == null) return;
    setState(() {
      final temp = selectedFromWallet;
      selectedFromWallet = selectedToWallet;
      selectedToWallet = temp;
      _prefillExchangeRate();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedTransferDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    setState(() {
      _selectedTransferDate = picked;
      _syncTransferDateTimeControllers();
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTransferTime,
    );
    if (picked == null) return;
    setState(() {
      _selectedTransferTime = picked;
      _syncTransferDateTimeControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final body = BlocBuilder<TransferCubit, TransferState>(
      builder: (context, transferState) {
        final minTransferAmount = _minimumTransferAmount(context);
        final figureStyle = LedgerText.money(
          size: 30.lx,
          weight: FontWeight.w600,
          color: t.textPrimary,
        );
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              14.lx,
              6.lx,
              14.lx,
              MediaQuery.of(context).viewInsets.bottom + 40.lx,
            ),
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  LedgerCard(
                    padding: EdgeInsets.symmetric(horizontal: 12.lx),
                    child: Column(
                      children: [
                        _walletRow(
                          label: LocaleKeys.from.tr(),
                          wallet: selectedFromWallet,
                          isFromWallet: true,
                          divider: true,
                        ),
                        _walletRow(
                          label: LocaleKeys.to.tr(),
                          wallet: selectedToWallet,
                          isFromWallet: false,
                          divider: false,
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: const Alignment(0.35, 0),
                      child: LedgerIconButton(
                        icon: LucideIcons.arrowUpDown,
                        tooltip: LocaleKeys.walletTransfer.tr(),
                        onTap: _swapWallets,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.lx),
              LedgerCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LedgerH6(LocaleKeys.amount.tr()),
                    SizedBox(height: 6.lx),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: figureStyle,
                            onChanged: (_) => setState(() {}),
                            decoration: ledgerBareInput(
                              LocaleKeys.amountHint.tr(),
                              figureStyle.copyWith(color: t.textMuted),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys.amountRequired.tr();
                              }
                              final number = double.tryParse(value);
                              if (number == null) {
                                return LocaleKeys.mustBeNumber.tr();
                              }
                              if (number < minTransferAmount) {
                                return LocaleKeys.amountNotZero.tr(
                                  namedArgs: {
                                    'minAmount':
                                        _minimumTransferAmountForLocale(
                                            context),
                                  },
                                );
                              }
                              if (selectedFromWallet != null &&
                                  number > selectedFromWallet!.balance) {
                                return LocaleKeys.insufficientBalance.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        if (selectedFromWallet != null)
                          Text(
                            selectedFromWallet!.currencyCode,
                            style: LedgerText.money(
                              size: 14.lx,
                              color: t.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_crossCurrency) ...[
                SizedBox(height: 12.lx),
                LedgerFieldsCard(
                  children: [
                    LedgerFieldRow(
                      icon: LucideIcons.arrowRightLeft,
                      label: LocaleKeys.exchangeRate.tr(),
                      divider: false,
                      valueWidget: LedgerInlineField(
                        controller: _exchangeRateController,
                        hint: LocaleKeys.exchangeRate.tr(),
                        maxLines: 1,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      trailing: Text(
                        '${selectedFromWallet!.currencyCode} → ${selectedToWallet!.currencyCode}',
                        style: LedgerText.money(
                          size: 12.lx,
                          color: t.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.lx),
                LedgerNote(icon: LucideIcons.info, text: _receivesText()),
              ],
              SizedBox(height: 12.lx),
              LedgerFieldsCard(
                children: [
                  LedgerFieldRow(
                    icon: LucideIcons.calendar,
                    label: LocaleKeys.date.tr(),
                    value: _transferDateController.text,
                    chevron: true,
                    onTap: _pickDate,
                  ),
                  LedgerFieldRow(
                    icon: LucideIcons.clock,
                    label: LocaleKeys.time.tr(),
                    value: _transferTimeController.text,
                    chevron: true,
                    divider: false,
                    onTap: _pickTime,
                  ),
                ],
              ),
              SizedBox(height: 18.lx),
              LedgerButton(
                label: LocaleKeys.transferMoney.tr(),
                icon: LucideIcons.arrowRightLeft,
                large: true,
                busy: transferState.isSaving,
                onPressed: _performTransfer,
              ),
            ],
          ),
        );
      },
    );

    final listener = BlocListener<TransferCubit, TransferState>(
      listenWhen: (previous, current) =>
          previous.isSaving != current.isSaving ||
          previous.saveSuccess != current.saveSuccess ||
          previous.failure != current.failure,
      listener: (context, state) {
        if (state.failure.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.transferFailedWithMessage
                  .tr(namedArgs: {'message': state.failure.customMessage})),
              backgroundColor: Colors.red,
            ),
          );
          context.read<TransferCubit>().resetSaveState();
        } else if (state.saveSuccess) {
          context.read<TransferCubit>().resetSaveState();
          if (widget.onSavedSuccessfully != null) {
            widget.onSavedSuccessfully!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: body,
    );

    if (widget.embedded) {
      return listener;
    }

    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(title: LocaleKeys.walletTransfer.tr()),
      body: listener,
    );
  }
}
