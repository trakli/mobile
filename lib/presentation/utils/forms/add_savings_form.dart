import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddSavingsForm extends StatefulWidget {
  const AddSavingsForm({super.key});

  @override
  State<AddSavingsForm> createState() => _AddSavingsFormState();
}

class _AddSavingsFormState extends State<AddSavingsForm> {
  late IconData? selectedIcon;

  @override
  void initState() {
    selectedIcon = Icons.add;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: ui.TextDirection.rtl,
              spacing: 8.w,
              children: [
                GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(
                      context,
                      widget: const SelectIconBottomSheet(),
                    );
                  },
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      color: appPrimaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.images.galleryAdd,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: LocaleKeys.typeHere.tr(),
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: LocaleKeys.typeHere.tr(),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 54.h,
              width: double.infinity,
              child: Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    hideKeyBoard();
                    if (Form.of(context).validate()) {
                      // Do something
                    }
                  },
                  child: Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Create saving",
                      ),
                      SvgPicture.asset(
                        Assets.images.add,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
