import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/wallet_tile_mini.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class SelectWalletBottomSheet extends StatelessWidget {
  final List<WalletEntity> wallets;
  final Function(WalletEntity) onSelect;

  const SelectWalletBottomSheet({
    super.key,
    required this.wallets,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Align(
            child: Container(
              width: 90.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.selectWallet.tr(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return GestureDetector(
                onTap: () {
                  onSelect(wallet);
                },
                child: WalletTileMini(
                  name: wallet.name,
                  balance: wallet.balance,
                  currency: wallet.currencyCode,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.h);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
