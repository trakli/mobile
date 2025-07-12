import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';

class PartyListItem extends StatelessWidget {
  final PartyEntity party;

  const PartyListItem({
    super.key,
    required this.party,
  });

  void _handleEdit(BuildContext context) {
    AppNavigator.push(
      context,
      AddPartyScreen(party: party),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          LocaleKeys.partyDeleteParty.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          LocaleKeys.partyDeletePartyConfirm
              .tr(namedArgs: {'name': party.name}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleKeys.cancel.tr(),
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PartyCubit>().deleteParty(party.clientId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              LocaleKeys.delete.tr(),
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  party.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (party.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    party.description!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: accentColor.withValues(alpha: 0.2),
            ),
            child: PopupMenuButton(
              icon: SvgPicture.asset(
                height: 20.h,
                width: 20.w,
                Assets.images.more,
                colorFilter: ColorFilter.mode(
                  accentColor,
                  BlendMode.srcIn,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => _handleEdit(context),
                    height: 40.h,
                    child: Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor.withAlpha(50),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.edit2,
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(LocaleKeys.edit.tr()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => _showDeleteConfirmation(context),
                    height: 40.h,
                    child: Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withAlpha(50),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.trash,
                            colorFilter: const ColorFilter.mode(
                              Colors.redAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(LocaleKeys.delete.tr()),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
