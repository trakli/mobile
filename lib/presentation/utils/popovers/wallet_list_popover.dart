import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class WalletListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<WalletEntity> onSelect;


  const WalletListPopover({
    super.key,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
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
              state.wallets.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.noWalletsYet.tr(),
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
                        final wallet = state.wallets[index];
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.w),
                          onTap: () {
                            onSelect(wallet);
                            AppNavigator.pop(context);
                          },
                          title: Text(
                            wallet.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: SvgPicture.asset(
                            Assets.images.arrowRight,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 4.h);
                      },
                      itemCount: state.wallets.length,
                    ),
            ],
          ),
        );
      },
    );
  }
}
