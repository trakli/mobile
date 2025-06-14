import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/pick_group_tile.dart';

class PickGroupBottomSheet extends StatefulWidget {
  const PickGroupBottomSheet({super.key});

  @override
  State<PickGroupBottomSheet> createState() => _PickGroupBottomSheetState();
}

class _PickGroupBottomSheetState extends State<PickGroupBottomSheet> {
  int? val = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Align(
            child: Container(
              width: 90.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Pick group",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Separate your income and expenses with groups for things that should really not be mixed. For example business and personal.",
            style: TextStyle(
              fontSize: 14.sp,
              color: neutralN900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          SearchBar(
            leading: SvgPicture.asset(
              Assets.images.searchSpecial,
              width: 24.sp,
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            hintText: "Search",
            onChanged: (value) {},
          ),
          SizedBox(height: 16.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 0.4.sh,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return PickGroupTile(
                  value: index,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8.h);
              },
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                AppNavigator.push(context, const AddGroupScreen());
              },
              label: const Text("Add group"),
              icon: const Icon(Icons.add),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      AppNavigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neutralN40,
                      foregroundColor: neutralN900,
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Confirm"),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
