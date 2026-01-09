import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/notification_settings/cubit/notification_preferences_cubit.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, showLoader, hideLoader;

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.notificationSettings.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
      ),
      body: const _NotificationSettingsBody(),
    );
  }
}

class _NotificationSettingsBody extends StatelessWidget {
  const _NotificationSettingsBody();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationPreferencesCubit,
            NotificationPreferencesState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure.hasError,
          listener: (context, state) {
            // Show error message when there's a failure
            showSnackBar(
              message: state.failure.customMessage,
              // backgroundColor: appDangerColor,
              // borderRadius: 8.r,
            );
          },
        ),
        BlocListener<NotificationPreferencesCubit,
            NotificationPreferencesState>(
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
      child: BlocBuilder<NotificationPreferencesCubit,
          NotificationPreferencesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(LocaleKeys.loadingPreferences.tr()),
                ],
              ),
            );
          }

          final preferences = state.preferences;
          if (preferences == null) {
            return Center(
              child: Text(LocaleKeys.errorLoadingPreferences.tr()),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(LocaleKeys.notificationChannels.tr()),
                SizedBox(height: 12.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.email_outlined,
                  title: LocaleKeys.emailNotifications.tr(),
                  subtitle: LocaleKeys.emailNotificationsDesc.tr(),
                  value: preferences.channels.email,
                  onChanged: (v) => context
                      .read<NotificationPreferencesCubit>()
                      .updateChannel(
                        email: v,
                        push: preferences.channels.push,
                        inapp: preferences.channels.inapp,
                      ),
                ),
                SizedBox(height: 8.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.phone_android_outlined,
                  title: LocaleKeys.pushNotifications.tr(),
                  subtitle: LocaleKeys.pushNotificationsDesc.tr(),
                  value: preferences.channels.push,
                  onChanged: (v) => context
                      .read<NotificationPreferencesCubit>()
                      .updateChannel(
                        email: preferences.channels.email,
                        push: v,
                        inapp: preferences.channels.inapp,
                      ),
                ),
                SizedBox(height: 8.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: LocaleKeys.inAppNotifications.tr(),
                  subtitle: LocaleKeys.inAppNotificationsDesc.tr(),
                  value: preferences.channels.inapp,
                  onChanged: (v) => context
                      .read<NotificationPreferencesCubit>()
                      .updateChannel(
                        email: preferences.channels.email,
                        push: preferences.channels.push,
                        inapp: v,
                      ),
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader(LocaleKeys.notificationTypes.tr()),
                SizedBox(height: 12.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.access_time_outlined,
                  title: LocaleKeys.reminders.tr(),
                  subtitle: LocaleKeys.remindersDesc.tr(),
                  value: preferences.types.reminders,
                  onChanged: (v) =>
                      context.read<NotificationPreferencesCubit>().updateType(
                            reminders: v,
                            insights: preferences.types.insights,
                            inactivity: preferences.types.inactivity,
                          ),
                ),
                SizedBox(height: 8.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.trending_up_outlined,
                  title: LocaleKeys.financialInsights.tr(),
                  subtitle: LocaleKeys.financialInsightsDesc.tr(),
                  value: preferences.types.insights,
                  onChanged: (v) =>
                      context.read<NotificationPreferencesCubit>().updateType(
                            reminders: preferences.types.reminders,
                            insights: v,
                            inactivity: preferences.types.inactivity,
                          ),
                ),
                SizedBox(height: 8.h),
                _buildToggleItem(
                  context: context,
                  icon: Icons.person_outline,
                  title: LocaleKeys.engagementReminders.tr(),
                  subtitle: LocaleKeys.engagementRemindersDesc.tr(),
                  value: preferences.types.inactivity,
                  onChanged: (v) =>
                      context.read<NotificationPreferencesCubit>().updateType(
                            reminders: preferences.types.reminders,
                            insights: preferences.types.insights,
                            inactivity: v,
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF061D23),
      ),
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF061D23),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF576760),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
