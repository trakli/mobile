import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:trakli/data/datasources/notification/notification_preferences_remote_datasource.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  NotificationPreferences? _preferences;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final datasource =
          GetIt.I<NotificationPreferencesRemoteDataSource>();
      final prefs = await datasource.getPreferences();
      setState(() {
        _preferences = prefs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _savePreferences() async {
    if (_preferences == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final datasource =
          GetIt.I<NotificationPreferencesRemoteDataSource>();
      await datasource.updatePreferences(_preferences!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.preferencesUpdated.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.preferencesUpdateFailed.tr())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _updateChannel(String channel, bool value) {
    if (_preferences == null) return;
    setState(() {
      switch (channel) {
        case 'email':
          _preferences = _preferences!.copyWith(
            channels: _preferences!.channels.copyWith(email: value),
          );
          break;
        case 'push':
          _preferences = _preferences!.copyWith(
            channels: _preferences!.channels.copyWith(push: value),
          );
          break;
        case 'inapp':
          _preferences = _preferences!.copyWith(
            channels: _preferences!.channels.copyWith(inapp: value),
          );
          break;
      }
    });
    _savePreferences();
  }

  void _updateType(String type, bool value) {
    if (_preferences == null) return;
    setState(() {
      switch (type) {
        case 'reminders':
          _preferences = _preferences!.copyWith(
            types: _preferences!.types.copyWith(reminders: value),
          );
          break;
        case 'insights':
          _preferences = _preferences!.copyWith(
            types: _preferences!.types.copyWith(insights: value),
          );
          break;
        case 'inactivity':
          _preferences = _preferences!.copyWith(
            types: _preferences!.types.copyWith(inactivity: value),
          );
          break;
      }
    });
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.notificationSettings.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
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

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.r, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadPreferences();
                },
                child: Text(LocaleKeys.retry.tr()),
              ),
            ],
          ),
        ),
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
            icon: Icons.email_outlined,
            title: LocaleKeys.emailNotifications.tr(),
            subtitle: LocaleKeys.emailNotificationsDesc.tr(),
            value: _preferences?.channels.email ?? true,
            onChanged: (v) => _updateChannel('email', v),
          ),
          SizedBox(height: 8.h),
          _buildToggleItem(
            icon: Icons.phone_android_outlined,
            title: LocaleKeys.pushNotifications.tr(),
            subtitle: LocaleKeys.pushNotificationsDesc.tr(),
            value: _preferences?.channels.push ?? true,
            onChanged: (v) => _updateChannel('push', v),
          ),
          SizedBox(height: 8.h),
          _buildToggleItem(
            icon: Icons.notifications_outlined,
            title: LocaleKeys.inAppNotifications.tr(),
            subtitle: LocaleKeys.inAppNotificationsDesc.tr(),
            value: _preferences?.channels.inapp ?? true,
            onChanged: (v) => _updateChannel('inapp', v),
          ),
          SizedBox(height: 24.h),
          _buildSectionHeader(LocaleKeys.notificationTypes.tr()),
          SizedBox(height: 12.h),
          _buildToggleItem(
            icon: Icons.access_time_outlined,
            title: LocaleKeys.reminders.tr(),
            subtitle: LocaleKeys.remindersDesc.tr(),
            value: _preferences?.types.reminders ?? true,
            onChanged: (v) => _updateType('reminders', v),
          ),
          SizedBox(height: 8.h),
          _buildToggleItem(
            icon: Icons.trending_up_outlined,
            title: LocaleKeys.financialInsights.tr(),
            subtitle: LocaleKeys.financialInsightsDesc.tr(),
            value: _preferences?.types.insights ?? true,
            onChanged: (v) => _updateType('insights', v),
          ),
          SizedBox(height: 8.h),
          _buildToggleItem(
            icon: Icons.person_outline,
            title: LocaleKeys.engagementReminders.tr(),
            subtitle: LocaleKeys.engagementRemindersDesc.tr(),
            value: _preferences?.types.inactivity ?? true,
            onChanged: (v) => _updateType('inactivity', v),
          ),
          if (_isSaving)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Center(
                child: SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
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
