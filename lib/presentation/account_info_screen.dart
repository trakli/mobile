import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/profile_form.dart';
import 'package:trakli/presentation/utils/info_tile.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: appPrimaryColor,
        titleText: "Account Info",
        headerTextColor: Colors.white,
        leading: const CustomBackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          spacing: 12.h,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                label: Text(
                  isEditing ? "Cancel" : "Edit Infos",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isEditing ? Colors.red : appPrimaryColor,
                  ),
                ),
                icon: SvgPicture.asset(
                  isEditing ? Assets.images.close : Assets.images.edit2,
                  colorFilter: ColorFilter.mode(
                    isEditing ? Colors.red : appPrimaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                iconAlignment: IconAlignment.end,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  side: BorderSide(
                    color: isEditing ? Colors.red : appPrimaryColor,
                  ),
                ),
              ),
            ),
            if (isEditing) const ProfileForm() else _infoWidget,
          ],
        ),
      ),
    );
  }

  Widget get _infoWidget {
    final user = context.read<AuthCubit>().state.user;
    return Column(
      spacing: 12.h,
      children: [
        InfoTile(
          title: "First Name",
          subTitle: user?.firstName ?? "",
        ),
        InfoTile(
          title: "Last Name",
          subTitle: user?.lastName ?? "",
        ),
        const InfoTile(
          title: "Country",
          subTitle: "Cameroon",
          countryCode: "cm",
        ),
        InfoTile(
          title: "Phone Number",
          subTitle: user?.phone ?? "Not set",
        ),
      ],
    );
  }
}
