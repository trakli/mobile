import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/group_tile.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<GroupCubit>()..getGroups(),
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: const CustomBackButton(),
          titleText: LocaleKeys.groupsMyGroups.tr(),
          headerTextColor: const Color(0xFFEBEDEC),
          actions: [
            InkWell(
              onTap: () {
                AppNavigator.push(context, const AddGroupScreen());
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xFFEBEDEC),
                ),
                padding: EdgeInsets.all(8.r),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 24.r,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.failure.hasError) {
              return Center(
                child: Text(
                  state.failure.customMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.groups.isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.noGroupsFound.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GroupTile(group: state.groups[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                },
                itemCount: state.groups.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
