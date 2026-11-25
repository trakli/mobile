import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class DefaultsSettingsScreen extends StatelessWidget {
  const DefaultsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupCubit>().state.groups;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final configState = context.watch<ConfigCubit>().state;

    final defaultGroupConfig =
        configState.getConfigByKey(ConfigConstants.defaultGroup);
    final defaultGroupId = defaultGroupConfig?.value as String?;
    final group =
        groups.firstWhereOrNull((entity) => entity.clientId == defaultGroupId);

    final defaultWalletConfig =
        configState.getConfigByKey(ConfigConstants.defaultWallet);
    final defaultWalletId = defaultWalletConfig?.value as String?;
    final wallet = wallets
        .firstWhereOrNull((entity) => entity.clientId == defaultWalletId);

    return BlocListener<CurrencyCubit, CurrencyState>(
      listener: (context, state) {
        state.maybeWhen(
          loading: showLoader,
          error: (failure) {
            hideLoader();
            showSnackBar(message: failure.customMessage, borderRadius: 8.r);
          },
          orElse: hideLoader,
        );
      },
      child: Scaffold(
        backgroundColor: context.tones.bgPage,
        appBar: PageAppBar(title: LocaleKeys.defaults.tr()),
        body: LedgerSettingsList(
          children: [
            LedgerSettingsGroup(
              children: [
                LedgerSettingsRow(
                  icon: LucideIcons.coins,
                  title: LocaleKeys.defaultCurrency.tr(),
                  value: context.watch<CurrencyCubit>().state.currency?.code,
                  onTap: () => showCurrencyPicker(
                    context: context,
                    theme: ledgerCurrencyPickerTheme(context),
                    onSelect: (c) =>
                        context.read<CurrencyCubit>().setCurrency(c),
                  ),
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.folder,
                  title: LocaleKeys.switchDefaultGroup.tr(),
                  value: group?.name,
                  onTap: groups.length > 1
                      ? () async {
                          final picked = await showLedgerOptionsSheet<String>(
                            context,
                            title: LocaleKeys.switchDefaultGroup.tr(),
                            selected: group?.clientId,
                            options: [
                              for (final g in groups)
                                LedgerOption(g.clientId, g.name),
                            ],
                          );
                          if (picked != null && context.mounted) {
                            context.read<ConfigCubit>().saveConfig(
                                  key: ConfigConstants.defaultGroup,
                                  type: ConfigType.string,
                                  value: picked,
                                );
                          }
                        }
                      : null,
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.wallet,
                  title: LocaleKeys.defaultWallet.tr(),
                  value: wallet?.name,
                  onTap: wallets.isNotEmpty
                      ? () async {
                          final picked = await showLedgerOptionsSheet<String>(
                            context,
                            title: LocaleKeys.defaultWallet.tr(),
                            selected: wallet?.clientId,
                            options: [
                              for (final w in wallets)
                                LedgerOption(
                                  w.clientId,
                                  w.name,
                                  subtitle: w.currencyCode,
                                ),
                            ],
                          );
                          if (picked != null && context.mounted) {
                            context.read<ConfigCubit>().saveConfig(
                                  key: ConfigConstants.defaultWallet,
                                  type: ConfigType.string,
                                  value: picked,
                                );
                          }
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
