import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';
import 'package:trakli/presentation/utils/colors.dart';

class InfoInterface extends StatelessWidget {
  final EmptyStateModel data;
  final VoidCallback? action;

  const InfoInterface({
    super.key,
    this.action,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Section
              CircleAvatar(
                radius: 36.sp,
                backgroundColor: appPrimaryColor.withAlpha(30),
                child: Icon(
                  data.icon,
                  size: 36.sp,
                  color: appPrimaryColor,
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                data.title.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10.sp),

              // Subtitle
              Text(
                data.description.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.sp),

              // Quick Start Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "QUICK START:",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: appPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    for (int i = 0; i < data.quickStartSteps.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _buildStep(
                            "${i + 1}", data.quickStartSteps[i].tr()),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              SizedBox(
                width: double.infinity,
                height: 48.sp,
                child: ElevatedButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.add),
                  label: Text(
                    data.buttonText.tr(),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              if (data.tipText != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: const Color(0xFFFFA000),
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.sp),
                      Expanded(
                        child: Text(
                          data.tipText!.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.brown[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12.sp,
          backgroundColor: appPrimaryColor,
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8.sp),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
