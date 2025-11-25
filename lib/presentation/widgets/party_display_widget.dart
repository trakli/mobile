import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class PartyDisplayWidget extends StatelessWidget {
  final TransactionType type;
  final PartyEntity? party;
  final WalletEntity walletEntity;
  final int maxNameLength;
  final EdgeInsets? padding;
  final double? fromTextSize;
  final double? toTextSize;
  final double? maxToWidth;
  final double? toIconSize;
  final double? labelSize;

  const PartyDisplayWidget({
    super.key,
    required this.party,
    this.maxNameLength = 10,
    this.padding,
    this.fromTextSize,
    this.toTextSize,
    this.labelSize,
    this.toIconSize,
    this.maxToWidth,
    required this.walletEntity,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type == TransactionType.income
                ? LocaleKeys.from.tr()
                : LocaleKeys.to.tr(),
            style: TextStyle(
              color: const Color(0xFF576760),
              fontSize: labelSize ?? 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 1.w,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(git
              spacing: 4.w,
              children: [
                ImageWidget(
                  mediaEntity: party?.icon,
                  // selectedIcon: Icons.person,
                  placeholderIcon: Icons.person,
                  placeholderSize: toIconSize ?? 12.sp,
                  accentColor: transactionTileTextColor,
                  iconSize: toIconSize ?? 12.sp,
                  emojiSize: toIconSize ?? 12.sp,
                ),
                SizedBox(
                  // width: 50.w,
                  child: Text(
                    (party?.name ?? LocaleKeys.unknown.tr())
                        .extractWords(maxSize: maxNameLength),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: transactionTileTextColor,
                      fontSize: fromTextSize ?? 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "-",
            style: TextStyle(
              color: transactionTileTextColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
              horizontal: 8.w,
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 4.w,
              children: [
                ImageWidget(
                  mediaEntity: walletEntity.icon,
                  placeholderImageAsset: Assets.images.wallet,
                  placeholderSize: toIconSize ?? 12.sp,
                  accentColor: Colors.blueAccent,
                  iconSize: toIconSize ?? 12.sp,
                  emojiSize: toIconSize ?? 12.sp,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxToWidth ?? 0.2.sw),
                  child: Text(
                    (walletEntity.name).extractWords(maxSize: 10),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: toTextSize ?? 9.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
