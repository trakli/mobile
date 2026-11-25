import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/insights_frequency_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/notification_settings/helpers/notification_settings_helpers.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, showLoader, hideLoader;
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.notificationSettings.tr(),
      ),
      body: const _NotificationSettingsBody(),
    );
  }
}

class _NotificationSettingsBody extends StatelessWidget {
  const _NotificationSettingsBody();

  bool _getConfigBoolValue(ConfigState state, String key,
      {bool defaultValue = true}) {
    final config = state.getConfigByKey(key);
    if (config == null || config.value == null) return defaultValue;
    return config.value as bool? ?? defaultValue;
  }

  String _getConfigStringValue(ConfigState state, String key,
      {String defaultValue = InsightsFrequencyConstants.weekly}) {
    final config = state.getConfigByKey(key);
    if (config == null || config.value == null) return defaultValue;
    return config.value as String? ?? defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final configState = context.watch<ConfigCubit>().state;

    // Get notification preference values with defaults
    final email =
        _getConfigBoolValue(configState, ConfigConstants.notificationsEmail);
    final push =
        _getConfigBoolValue(configState, ConfigConstants.notificationsPush);
    final inapp =
        _getConfigBoolValue(configState, ConfigConstants.notificationsInapp);
    final reminders = _getConfigBoolValue(
        configState, ConfigConstants.notificationsReminders);
    final insights =
        _getConfigBoolValue(configState, ConfigConstants.notificationsInsights);
    final insightsFrequency = _getConfigStringValue(
        configState, ConfigConstants.insightsFrequency,
        defaultValue: InsightsFrequencyConstants.weekly);
    final inactivity = _getConfigBoolValue(
        configState, ConfigConstants.notificationsInactivity);

    if (configState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.lx),
            Text(LocaleKeys.loadingPreferences.tr()),
          ],
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ConfigCubit, ConfigState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure.hasError,
          listener: (context, state) {
            showSnackBar(
              message: state.failure.customMessage,
            );
          },
        ),
        BlocListener<ConfigCubit, ConfigState>(
          listenWhen: (previous, current) =>
              previous.isSaving != current.isSaving,
          listener: (context, state) {
            if (state.isSaving) {
              showLoader();
            } else {
              hideLoader();
            }
          },
        ),
      ],
      child: Builder(builder: (context) {
        final config = context.read<ConfigCubit>();
        void save(String key, bool v) =>
            config.saveConfig(key: key, type: ConfigType.bool, value: v);
        return LedgerSettingsList(
          children: [
            LedgerSettingsGroup(
              title: LocaleKeys.notificationChannels.tr(),
              children: [
                LedgerSettingsToggle(
                  icon: LucideIcons.mail,
                  title: LocaleKeys.emailNotifications.tr(),
                  subtitle: LocaleKeys.emailNotificationsDesc.tr(),
                  value: email,
                  onChanged: (v) => save(ConfigConstants.notificationsEmail, v),
                ),
                LedgerSettingsToggle(
                  icon: LucideIcons.smartphone,
                  title: LocaleKeys.pushNotifications.tr(),
                  subtitle: LocaleKeys.pushNotificationsDesc.tr(),
                  value: push,
                  onChanged: (v) => save(ConfigConstants.notificationsPush, v),
                ),
                LedgerSettingsToggle(
                  icon: LucideIcons.bell,
                  title: LocaleKeys.inAppNotifications.tr(),
                  subtitle: LocaleKeys.inAppNotificationsDesc.tr(),
                  value: inapp,
                  onChanged: (v) => save(ConfigConstants.notificationsInapp, v),
                ),
              ],
            ),
            LedgerSettingsGroup(
              title: LocaleKeys.notificationTypes.tr(),
              children: [
                LedgerSettingsToggle(
                  icon: LucideIcons.alarmClock,
                  title: LocaleKeys.reminders.tr(),
                  subtitle: LocaleKeys.remindersDesc.tr(),
                  value: reminders,
                  onChanged: (v) =>
                      save(ConfigConstants.notificationsReminders, v),
                ),
                LedgerSettingsToggle(
                  icon: LucideIcons.trendingUp,
                  title: LocaleKeys.financialInsights.tr(),
                  subtitle: LocaleKeys.financialInsightsDesc.tr(),
                  value: insights,
                  onChanged: (v) =>
                      save(ConfigConstants.notificationsInsights, v),
                ),
                if (insights)
                  LedgerSettingsRow(
                    icon: LucideIcons.calendarClock,
                    title: LocaleKeys.insightsFrequency.tr(),
                    subtitle: LocaleKeys.insightsFrequencyDesc.tr(),
                    value: NotificationSettingsHelpers.getFrequencyLabel(
                      insightsFrequency,
                    ),
                    onTap: () async {
                      final picked = await showLedgerOptionsSheet<String>(
                        context,
                        title: LocaleKeys.selectFrequency.tr(),
                        selected: insightsFrequency,
                        options: [
                          for (final f in InsightsFrequencyConstants.values)
                            LedgerOption(
                              f,
                              NotificationSettingsHelpers.getFrequencyLabel(f),
                            ),
                        ],
                      );
                      if (picked != null) {
                        config.saveConfig(
                          key: ConfigConstants.insightsFrequency,
                          type: ConfigType.string,
                          value: picked,
                        );
                      }
                    },
                  ),
                LedgerSettingsToggle(
                  icon: LucideIcons.userRound,
                  title: LocaleKeys.engagementReminders.tr(),
                  subtitle: LocaleKeys.engagementRemindersDesc.tr(),
                  value: inactivity,
                  onChanged: (v) =>
                      save(ConfigConstants.notificationsInactivity, v),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
