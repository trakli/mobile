import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/group_list_popover.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';

class GroupTypePopover extends StatelessWidget {
  final ValueChanged<GroupOption> onSelect;

  const GroupTypePopover({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: GroupOption.values.length,
            itemBuilder: (context, index) {
              final GlobalKey key = GlobalKey();
              final groupCubit = context.read<GroupCubit>();
              final option = GroupOption.values.elementAt(index);
              if (groupCubit.state.groups.isEmpty && index == 2) {
                return const SizedBox.shrink();
              }
              return Builder(builder: (context) {
                return ListTile(
                  key: key,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () async {
                    onSelect(option);
                    if (index == 2) {
                      await showCustomPopOver(context,
                          widget: GroupListPopover(
                            label: LocaleKeys.pickGroup.tr(),
                            onSelect: (group) {
                              context.read<ConfigCubit>().saveConfig(
                                    key: ConfigConstants.defaultGroup,
                                    type: ConfigType.string,
                                    value: group.clientId,
                                  );
                            },
                          ));
                    }
                    if (context.mounted) {
                      AppNavigator.pop(context);
                    }
                  },
                  title: Text(
                    option.customName.tr(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: SvgPicture.asset(
                    Assets.images.arrowRight,
                  ),
                );
              });
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 2.h);
            },
          ),
        ],
      ),
    );
  }
}

