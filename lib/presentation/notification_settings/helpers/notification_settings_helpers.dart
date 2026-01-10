import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/core/constants/insights_frequency_constants.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class NotificationSettingsHelpers {
  static String getFrequencyLabel(String frequency) {
    switch (frequency) {
      case InsightsFrequencyConstants.weekly:
        return LocaleKeys.insightsFrequencyWeekly.tr();
      case InsightsFrequencyConstants.monthly:
        return LocaleKeys.insightsFrequencyMonthly.tr();
      default:
        return LocaleKeys.insightsFrequencyWeekly.tr();
    }
  }
}
