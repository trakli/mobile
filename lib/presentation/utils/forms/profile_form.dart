import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  UserEntity? user;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNameController = TextEditingController();

  @override
  void initState() {
    user = context.read<AuthCubit>().state.user;
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    phoneNameController.text = user?.phone ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.firstName.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: firstNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: LocaleKeys.firstName.tr(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appPrimaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.nameIsRequired.tr();
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.lastName.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: lastNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: LocaleKeys.lastName.tr(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appPrimaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.nameIsRequired.tr();
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.phoneNumber.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: phoneNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: LocaleKeys.phoneNumberHint.tr(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appPrimaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.phoneIsRequired.tr();
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.country.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: LocaleKeys.country.tr(),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.sp),
                child: CountryFlag.fromCountryCode(
                  shape: const Circle(),
                  "cm",
                  width: 24.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appPrimaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: Text(LocaleKeys.save.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
