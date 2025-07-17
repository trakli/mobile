import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class AddGroupsForm extends StatefulWidget {
  final GroupEntity? group;

  const AddGroupsForm({
    super.key,
    this.group,
  });

  @override
  State<AddGroupsForm> createState() => _AddGroupsFormState();
}

class _AddGroupsFormState extends State<AddGroupsForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late MediaEntity? mediaEntity;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.group?.name);
    _descriptionController =
        TextEditingController(text: widget.group?.description);
    mediaEntity = widget.group?.icon;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listenWhen: (previous, current) => previous.isSaving != current.isSaving,
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
      builder: (context, state) {
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
                          color: appPrimaryColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: ImageWidget(
                          mediaEntity: mediaEntity,
                          accentColor: appPrimaryColor,
                          placeholderImageAsset: Assets.images.galleryAdd,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.groupEnterGroupName.tr(),
                          labelText: LocaleKeys.groupGroupName.tr(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.nameIsRequired.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.typeHere.tr(),
                    labelText: LocaleKeys.groupGroupDescription.tr(),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 54.h,
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: state.isSaving
                          ? null
                          : () {
                              hideKeyBoard();
                              if (Form.of(context).validate()) {
                                if (widget.group == null) {
                                  context.read<GroupCubit>().addGroup(
                                        _nameController.text,
                                        description:
                                            _descriptionController.text.isEmpty
                                                ? null
                                                : _descriptionController.text,
                                        media: mediaEntity?.content?.isEmpty ==
                                                true
                                            ? null
                                            : mediaEntity,
                                      );
                                } else {
                                  context.read<GroupCubit>().updateGroup(
                                        widget.group!.clientId,
                                        name: _nameController.text,
                                        description:
                                            _descriptionController.text.isEmpty
                                                ? null
                                                : _descriptionController.text,
                                        media: mediaEntity?.content?.isEmpty ==
                                                true
                                            ? null
                                            : mediaEntity,
                                      );
                                }
                              }
                            },
                      child: Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.group == null
                                ? LocaleKeys.groupCreateGroup.tr()
                                : LocaleKeys.groupUpdate.tr(),
                          ),
                          SvgPicture.asset(
                            widget.group == null
                                ? Assets.images.add
                                : Assets.images.galleryAdd,
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
      },
    );
  }
}
