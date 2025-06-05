import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

class WalletTileMini extends StatefulWidget {
  final String name;
  final double balance;
  final String currency;

  const WalletTileMini({
    super.key,
    required this.name,
    required this.balance,
    required this.currency,
  });

  @override
  State<WalletTileMini> createState() => _WalletTileMiniState();
}

class _WalletTileMiniState extends State<WalletTileMini> {
  Currency? currencyData;

  @override
  void initState() {
    super.initState();
    currencyData = CurrencyService().findByCode(widget.currency);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.w,
        children: [
          HeroIcon(
            HeroIcons.folder,
            size: 48.sp,
            style: HeroIconStyle.solid,
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF061D23),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF061D23),
                    ),
                    text: "",
                    children: [
                      TextSpan(
                        text: currencyData?.symbol ?? widget.currency,
                      ),
                      TextSpan(
                        text: widget.balance.toStringAsFixed(2),
                      ),
                    ],
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
