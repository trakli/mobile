import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/wallet_type_popover.dart';

class GroupSetupWidget extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const GroupSetupWidget({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<GroupSetupWidget> createState() => _GroupSetupWidgetState();
}

class _GroupSetupWidgetState extends State<GroupSetupWidget> {
  WalletOption? _selectedGroupOption = WalletOption.createAutomatically;
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey gloKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _optionController.text = _selectedGroupOption?.customName.tr() ?? "";
  }

  @override
  void dispose() {
    _optionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configCubit = context.watch<ConfigCubit>();
    final groupCubit = context.watch<GroupCubit>();
    ConfigEntity? sConfig;
    sConfig = configCubit.state.configs
        .firstWhereOrNull((e) => e.key == ConfigConstants.defaultGroup);
    GroupEntity? group = groupCubit.state.groups
        .firstWhereOrNull((e) => e.clientId == sConfig?.value);
    
    return BlocListener<GroupCubit, GroupState>(
      listener: (BuildContext context, GroupState state) {
        if (state.isSaving) {
          showLoader();
        } else {
          hideLoader();
        }
        if (state.failure.hasError) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.h),
            CircleAvatar(
              radius: 30.sp,
              backgroundColor: appPrimaryColor.withAlpha(30),
              child: Icon(
                Icons.group,
                size: 28.sp,
                color: appPrimaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.setupGroupTitle.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.setupGroupDesc.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.groupSetup.tr(),
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Builder(builder: (context) {
                    return TextFormField(
                      controller: _optionController,
                      readOnly: true,
                      key: gloKey,
                      onTap: () {
                        showCustomPopOver(
                          context,
                          maxWidth: 0.8.sw,
                          widget: WalletTypePopover(
                            onSelect: (type) {
                              setState(() {
                                _selectedGroupOption = type;
                              });
                              _optionController.text =
                                  _selectedGroupOption?.customName.tr() ?? "";
                            },
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            Assets.images.arrowDown,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_selectedGroupOption == WalletOption.createManually) ...[
                    SizedBox(height: 16.h),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.enterName.tr(),
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
                  if (_selectedGroupOption ==
                          WalletOption.selectFromWalletList &&
                      group != null) ...[
                    SizedBox(height: 16.h),
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onPrev,
                  child: Text(LocaleKeys.prev.tr()),
                ),
                PrimaryButton(
                  onPress: () async {
                    final hasDefaultGroup = configCubit.state
                        .hasConfig(ConfigConstants.defaultGroup);
                    if (!hasDefaultGroup) {
                      final groupCubit = context.read<GroupCubit>();
                      if (_selectedGroupOption ==
                              WalletOption.createManually &&
                          (_formKey.currentState?.validate() ?? false)) {
                        await groupCubit.createAndSaveDefaultGroup(
                          name: _nameController.text,
                        );
                        widget.onNext();
                      } else if (_selectedGroupOption ==
                          WalletOption.createAutomatically) {
                        await groupCubit.createAndSaveDefaultGroup(
                          name: LocaleKeys.defaultGroupName.tr(),
                        );
                        widget.onNext();
                      } else if (_selectedGroupOption ==
                              WalletOption.selectFromWalletList &&
                          group != null) {
                        // Save existing group as default
                        await configCubit.saveConfig(
                          key: ConfigConstants.defaultGroup,
                          type: ConfigType.string,
                          value: group.clientId,
                        );
                        widget.onNext();
                      }
                    } else {
                      widget.onNext();
                    }
                  },
                  buttonText: LocaleKeys.next.tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

