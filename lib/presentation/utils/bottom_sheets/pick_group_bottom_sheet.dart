import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/pick_group_tile.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class PickGroupBottomSheet extends StatefulWidget {
  final GroupEntity? group;
  const PickGroupBottomSheet({super.key, this.group});

  @override
  State<PickGroupBottomSheet> createState() => _PickGroupBottomSheetState();
}

class _PickGroupBottomSheetState extends State<PickGroupBottomSheet> {
  GroupEntity? selectedGroup;

  @override
  void initState() {
    selectedGroup = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupCubit>().state.groups;

    if (selectedGroup == null && groups.isNotEmpty) {
      selectedGroup = groups.first;
    }
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
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
            LocaleKeys.pickGroup.tr(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.pickGroupDesc.tr(),
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
            hintText: LocaleKeys.search.tr(),
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
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return PickGroupTile<GroupEntity?>(
                  value: group,
                  groupValue: selectedGroup,
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value;
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
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neutralN40,
                      foregroundColor: neutralN900,
                    ),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: selectedGroup == null
                        ? null
                        : () {
                            final group = selectedGroup!;
                            Navigator.of(context).pop<GroupEntity>(group);
                          },
                    child: Text(LocaleKeys.confirm.tr()),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
