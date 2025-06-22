import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/globals.dart';

class DateListPopover extends StatelessWidget {
  final String label;

  const DateListPopover({
    super.key,
    required this.label,
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
            itemBuilder: (context, index) {
              final option = dateOptions[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                onTap: () async {
                  AppNavigator.pop(context);
                  if (index == dateOptions.length - 1) {
                    await showDatePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1000),
                      ),
                      lastDate: DateTime.now().add(
                        const Duration(days: 1000),
                      ),
                    );
                  }
                },
                title: Text(
                  option,
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
            itemCount: dateOptions.length,
          ),
        ],
      ),
    );
  }
}
