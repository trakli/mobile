import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => AppNavigator.pop(context),
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: color ?? Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Icon(
          Icons.arrow_back,
          size: 20.r,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
