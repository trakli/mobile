import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/bottom_sheets/pick_group_bottom_sheet.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_wallet_bottom_sheet.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class DefaultsSettingsScreen extends StatelessWidget {
  const DefaultsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupCubit>().state.groups;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final configState = context.watch<ConfigCubit>().state;

    final defaultGroupConfig =
        configState.getConfigByKey(ConfigConstants.defaultGroup);
    final defaultGroupId = defaultGroupConfig?.value as String?;
    final group =
        groups.firstWhereOrNull((entity) => entity.clientId == defaultGroupId);

    final defaultWalletConfig =
        configState.getConfigByKey(ConfigConstants.defaultWallet);
    final defaultWalletId = defaultWalletConfig?.value as String?;
    final wallet = wallets
        .firstWhereOrNull((entity) => entity.clientId == defaultWalletId);

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.defaults.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8.h),
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: SvgPicture.asset(
                  Assets.images.people,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(LocaleKeys.switchDefaultGroup.tr()),
              subtitle: Text(
                group?.name ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: groups.length > 1
                  ? () async {
                      final pickedGroup =
                          await showCustomBottomSheet<GroupEntity>(
                        context,
                        widget: PickGroupBottomSheet(
                          group: group,
                        ),
                      );
                      if (pickedGroup != null && context.mounted) {
                        context.read<ConfigCubit>().saveConfig(
                              key: ConfigConstants.defaultGroup,
                              type: ConfigType.string,
                              value: pickedGroup.clientId,
                            );
                      }
                    }
                  : null,
              trailing: groups.length > 1
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    )
                  : null,
            ),
            SizedBox(height: 24.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(LocaleKeys.defaultWallet.tr()),
              subtitle: wallet != null
                  ? Text(
                      wallet.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
              onTap: wallets.isNotEmpty
                  ? () async {
                      await showCustomBottomSheet(
                        context,
                        widget: SelectWalletBottomSheet(
                          wallets: wallets,
                          onSelect: (selectedWallet) {
                            if (context.mounted) {
                              context.read<ConfigCubit>().saveConfig(
                                    key: ConfigConstants.defaultWallet,
                                    type: ConfigType.string,
                                    value: selectedWallet.clientId,
                                  );
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                    }
                  : null,
              trailing: wallets.isNotEmpty
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    )
                  : null,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
