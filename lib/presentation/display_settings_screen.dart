import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/providers/local_storage.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  String? formDisplay;

  @override
  void initState() {
    getFormDisplay();
    super.initState();
  }

  void getFormDisplay() async {
    await LocalStorage().getTransactionFormDisplay().then((val) {
      setState(() {
        formDisplay = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        titleText: "Display Settings",
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _showFormDisplaySheet(context);
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.display_settings,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Transaction form display mode",
              ),
              subtitle: (formDisplay != null)
                  ? Text(
                      getFormDisplayText(
                        formDisplay ?? "",
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {},
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.display_settings,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Theme Mode",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFormDisplaySheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoActionSheet(
            title: const Text("Select Form Display Mode"),
            actions: List.generate(
              supportedFormDisplays.length,
              (index) => CupertinoActionSheetAction(
                onPressed: () async {
                  LocalStorage().updateTransactionFormDisplay(
                    supportedFormDisplays.elementAt(index),
                  );
                  setState(() {
                    formDisplay = supportedFormDisplays.elementAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  getFormDisplayText(
                    supportedFormDisplays.elementAt(index),
                  ),
                  style: TextStyle(
                    color: supportedFormDisplays.elementAt(index) == formDisplay
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
