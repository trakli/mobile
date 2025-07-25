import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/domain/entities/party_entity.dart';

class AddPartyForm extends StatefulWidget {
  final bool showClose;

  const AddPartyForm({
    super.key,
    this.showClose = false,
  });

  @override
  State<AddPartyForm> createState() => _AddPartyFormState();
}

class _AddPartyFormState extends State<AddPartyForm> {
  PartyType _selectedType = PartyType.individual;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Stack(
        children: [
          Container(
            padding: widget.showClose ? EdgeInsets.only(top: 18.h) : null,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.name.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: LocaleKeys.partyEnterPartyName.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.nameIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.description.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.typeHere.tr(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.type.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<PartyType>(
                    value: _selectedType,
                    items: PartyType.values.map((type) {
                      return DropdownMenuItem<PartyType>(
                        value: type,
                        child: Text(type.customName),
                      );
                    }).toList(),
                    onChanged: (type) {
                      if (type != null) {
                        setState(() {
                          _selectedType = type;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      hintText: LocaleKeys.selectPartyType.tr(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 54.h,
                    width: double.infinity,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            hideKeyBoard();
                            if (Form.of(context).validate()) {
                              // Pass _selectedType to your party creation logic here
                            }
                          },
                          child: Row(
                            spacing: 8.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.partyCreateParty.tr(),
                              ),
                              SvgPicture.asset(
                                Assets.images.add,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.showClose)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  AppNavigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
        ],
      ),
    );
  }
}
