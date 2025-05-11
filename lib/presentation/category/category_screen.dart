import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_state.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/category_tile.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/core/constants/colors.dart';
import 'package:trakli/core/constants/text_styles.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: "Categories",
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          InkWell(
            onTap: () {
              AppNavigator.push(
                context,
                AddCategoryScreen(
                  accentColor: Theme.of(context).primaryColor,
                ),
              );
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
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.failure.hasError) {
            return Center(
              child: Text(
                state.failure.customMessage,
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income Categories',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  categoriesList(
                    categories: state.categories
                        .where((c) => c.type == CategoryType.income)
                        .toList(),
                    accentColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Expense Categories',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  categoriesList(
                    categories: state.categories
                        .where((c) => c.type == CategoryType.expense)
                        .toList(),
                    type: CategoryType.expense,
                    accentColor: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoriesList({
    required List<CategoryEntity> categories,
    CategoryType type = CategoryType.income,
    required Color accentColor,
  }) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No categories found',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryTile(
          category: category,
          accentColor: accentColor,
          onEdit: () {
            AppNavigator.push(
              context,
              AddCategoryScreen(
                category: category,
                accentColor: accentColor,
              ),
            );
          },
          onDelete: () {
            context
                .read<CategoryCubit>()
                .deleteCategory(category.clientGeneratedId!);
          },
        );
      },
    );
  }
}
