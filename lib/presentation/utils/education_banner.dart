import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EducationBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  const EducationBanner({
    super.key,
    required this.message,
    this.icon = Icons.lightbulb_outline,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF061D23),
                height: 1.4,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: const Color(0xFF576760),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
