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
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

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
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteParty.tr(),
        subTitle:
            LocaleKeys.deletePartyConfirm.tr(namedArgs: {'name': party.name}),
        mainAction: () {
          context.read<PartyCubit>().deleteParty(party.clientId);
          AppNavigator.pop(context);
        },
        secondaryAction: () {
          AppNavigator.pop(context);
        },
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
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
            child: ImageWidget(
              mediaEntity: party.icon,
              accentColor: Theme.of(context).primaryColor,
              iconSize: 20.sp,
              emojiSize: 20.sp,
              placeholderIcon: Icons.person_outline,
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
