import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/insights_frequency_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/notification_settings/helpers/notification_settings_helpers.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class InsightsFrequencySelectorBottomSheet extends StatelessWidget {
  final String currentValue;
  final ConfigCubit configCubit;

  const InsightsFrequencySelectorBottomSheet({
    super.key,
    required this.currentValue,
    required this.configCubit,
  });

  static void show(BuildContext context, String currentValue) {
    final configCubit = context.read<ConfigCubit>();
    showCustomBottomSheet(
      context,
      color: Theme.of(context).scaffoldBackgroundColor,
      widget: InsightsFrequencySelectorBottomSheet(
        currentValue: currentValue,
        configCubit: configCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              LocaleKeys.selectFrequency.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...InsightsFrequencyConstants.values.map((frequency) =>
              _FrequencyOption(
                label: NotificationSettingsHelpers.getFrequencyLabel(frequency),
                value: frequency,
                currentValue: currentValue,
                onTap: () {
                  configCubit.saveConfig(
                    key: ConfigConstants.insightsFrequency,
                    type: ConfigType.string,
                    value: frequency,
                  );
                  Navigator.pop(context);
                },
              )),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _FrequencyOption extends StatelessWidget {
  final String label;
  final String value;
  final String currentValue;
  final VoidCallback onTap;

  const _FrequencyOption({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentValue == value;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).primaryColor
              : const Color(0xFF061D23),
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: onTap,
    );
  }
}
