import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show PickerDateRange;
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/dialogs/date_range_picker.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DateListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<PickerDateRange> onSelect;
  final ValueChanged<String> onSelectString;

  const DateListPopover({
    super.key,
    required this.label,
    required this.onSelect,
    required this.onSelectString,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: dateOptions.length,
            itemBuilder: (context, index) {
              final option = dateOptions[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                onTap: () async {
                  if (index == dateOptions.length - 1) {
                    await showCustomDialog(
                      widget: DateRangePicker(
                        onDateSelected: (range) {
                          onSelect(range);
                          onSelectString(option);
                        },
                      ),
                    );
                    if (context.mounted) {
                      AppNavigator.pop(context);
                    }
                  } else {
                    onSelect(
                      PickerDateRange(
                        getStartDateFromKey(option),
                        DateTime.now(),
                      ),
                    );
                    onSelectString(option);
                    AppNavigator.pop(context);
                  }
                },
                title: Text(
                  option.tr(),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: SvgPicture.asset(
                  Assets.images.arrowRight,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4.h);
            },
          ),
        ],
      ),
    );
  }
}
