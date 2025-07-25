import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoryListPopover extends StatelessWidget {
  final String label;

  const CategoryListPopover({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appPrimaryColor),
            ),
          );
        }
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
              state.categories.isEmpty
                  ? Center(
                      child: Text(
                        'No Categories yet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                          onTap: () {
                            AppNavigator.pop(context);
                          },
                          title: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: ImageWidget(
                            mediaEntity: category.icon,
                            iconSize: 24.sp,
                            emojiSize: 24.sp,
                            placeholderIcon: Icons.category,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 4.h);
                      },
                      itemCount: state.categories.length,
                    ),
            ],
          ),
        );
      },
    );
  }
}
