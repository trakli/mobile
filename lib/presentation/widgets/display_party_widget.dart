import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DisplayPartyWidget extends StatelessWidget {
  final PartyEntity? party;

  const DisplayPartyWidget({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "From",
          style: TextStyle(
            color: const Color(0xFF576760),
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 8.w,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SizedBox(
            width: 50.w,
            child: Text(
              party?.name ?? 'Unknown'.extractWords(maxSize: 10),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: transactionTileTextColor,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
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
              SvgPicture.asset(
                width: 12.w,
                height: 12.h,
                Assets.images.wallet,
                colorFilter: const ColorFilter.mode(
                  Colors.blueAccent,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  'Default'.extractWords(maxSize: 10),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
