import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/helpers.dart';

import 'package:trakli/presentation/widgets/image_widget.dart';

class AddCategoryForm extends StatefulWidget {
  final Color accentColor;
  final CategoryEntity? category;
  final TransactionType type;
  final Function(
      {required String name,
      required String description,
      required TransactionType type,
      IconData? icon,
      MediaEntity? mediaEntity}) onSubmit;

  const AddCategoryForm({
    super.key,
    this.accentColor = const Color(0xFFEB5757),
    this.category,
    required this.onSubmit,
    required this.type,
  });

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late IconData? selectedIcon;
  MediaEntity? mediaEntity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController =
        TextEditingController(text: widget.category?.description);
    selectedIcon = Icons.add;
    mediaEntity = widget.category?.icon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Form(
        key: _formKey,
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
                      widget: SelectIconBottomSheet(
                        onSelect: (mediaType, image) {
                          setState(() {
                            mediaEntity = MediaEntity(
                                content: image, mediaType: mediaType);
                          });
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: ImageWidget(
                      mediaEntity: mediaEntity,
                      accentColor: widget.accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Category name",
                      labelText: "Category name",
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
            SizedBox(height: 8.h),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: LocaleKeys.typeHere.tr(),
                labelText: "Description",
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 54.h,
              width: double.infinity,
              child: Builder(builder: (context) {
                return PrimaryButton(
                  onPress: () {
                    hideKeyBoard();
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        type: widget.type,
                        mediaEntity: mediaEntity,
                      );
                    }
                  },
                  buttonText: widget.category != null
                      ? "Update category"
                      : "Create category",
                  backgroundColor: widget.accentColor,
                  iconPath: widget.category != null
                      ? Assets.images.edit2
                      : Assets.images.add,
                  iconColor: Colors.white,
                  textDirection: ui.TextDirection.rtl,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
