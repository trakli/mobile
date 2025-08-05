import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class DateRangePicker extends StatelessWidget {
  final Function(PickerDateRange) onDateSelected;

  const DateRangePicker({
    super.key,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 4.h),
            SizedBox(
              height: 0.5.sh,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SfDateRangePickerTheme(
                  data: SfDateRangePickerThemeData(
                    todayHighlightColor: Theme.of(context).primaryColor,
                    todayCellTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    backgroundColor: Colors.white,
                    headerTextStyle: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    viewHeaderTextStyle: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                    headerBackgroundColor: Theme.of(context).primaryColor,
                    trailingDatesTextStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                    leadingDatesTextStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                    startRangeSelectionColor: Theme.of(context).primaryColor,
                    endRangeSelectionColor: Theme.of(context).primaryColor,
                    // activeDatesTextStyle: AppTypography.bodySmallRegular,
                    // rangeSelectionColor: AppColors.calendarSelected,
                  ),
                  child: SfDateRangePicker(
                    // showTodayButton: true,
                    showActionButtons: true,
                    onSelectionChanged: (value) {
                      // print("Something changed");
                      // print(value.value);
                    },
                    onSubmit: (value) {
                      if (value != null) {
                        final val = value as PickerDateRange;
                        onDateSelected(val);
                        AppNavigator.pop(context, val);
                      } else {
                        // AppAlerts.showWarningSnackBar(LocaleKeys.calendar_select_date_range.tr());
                      }
                    },
                    onCancel: () {
                      AppNavigator.pop(context);
                    },
                    headerStyle: const DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                    ),
                    headerHeight: 52.h,
                    selectionMode: DateRangePickerSelectionMode.range,
                    selectionRadius: 16,
                    showNavigationArrow: true,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      viewHeaderHeight: 40.h,
                      dayFormat: "EEE",
                      showTrailingAndLeadingDates: true,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
