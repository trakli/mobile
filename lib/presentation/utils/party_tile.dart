import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/party_entity.dart' show PartyEntity;
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';

class PartyTile extends StatelessWidget {
  final PartyEntity party;

  const PartyTile({
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
          'Delete Party',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${party.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PartyCubit>().deleteParty(party.clientId);
              AppNavigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              'Delete',
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: transactionTileBorderColor,
        ),
      ),
      padding: EdgeInsets.all(8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.w,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.groups_outlined,
              size: 20.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4.h,
              children: [
                Text(
                  party.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF061D23),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (party.description != null) ...[
                  Text(
                    party.description!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF576760),
                    ),
                    overflow: TextOverflow.ellipsis,
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
              color: appPrimaryColor.withValues(alpha: 0.2),
            ),
            child: PopupMenuButton(
              icon: SvgPicture.asset(
                height: 20.h,
                width: 20.w,
                Assets.images.more,
                colorFilter: ColorFilter.mode(
                  appPrimaryColor,
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
                            color: appPrimaryColor.withAlpha(50),
                          ),
                          child: SvgPicture.asset(
                            height: 16.h,
                            width: 16.w,
                            Assets.images.edit2,
                            colorFilter: ColorFilter.mode(
                              appPrimaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const Text('Edit'),
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
                        const Text('Delete'),
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
