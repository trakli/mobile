import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';

class WalletTypePopover extends StatelessWidget {
  final ValueChanged<WalletOption> onSelect;

  const WalletTypePopover({
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
            itemCount: WalletOption.values.length,
            itemBuilder: (context, index) {
              final option = WalletOption.values.elementAt(index);
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                onTap: () async {
                  onSelect(option);
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
