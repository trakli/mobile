import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/colors.dart';
import 'package:trakli/core/constants/text_styles.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/forms/add_category_form.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryEntity? category;
  final TransactionType type;
  final Color? accentColor;

  const AddCategoryScreen({
    super.key,
    this.category,
    this.accentColor,
    required this.type,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category != null ? 'Edit Category' : 'Add Category',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listenWhen: (previous, current) =>
            previous.isSaving != current.isSaving,
        listener: (context, state) {
          if (state.failure.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.customMessage),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (!state.isSaving && !state.failure.hasError) {
            AppNavigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: AddCategoryForm(
              category: widget.category,
              type: widget.type,
              accentColor: widget.accentColor ?? const Color(0xFFEB5757),
              onSubmit: (name, description, type, icon) {
                hideKeyBoard();
                if (widget.category != null) {
                  context.read<CategoryCubit>().updateCategory(
                        clientId: widget.category!.clientGeneratedId!,
                        name: name,
                        slug: _generateSlug(name),
                        userId: widget.category!.userId,
                        description: description,
                      );
                } else {
                  context.read<CategoryCubit>().addCategory(
                        name: name,
                        slug: _generateSlug(name),
                        type: widget.type,
                        userId: 1,
                        description: description,
                      );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
