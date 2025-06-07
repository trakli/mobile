import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/party_tile.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyCubit, PartyState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: const CustomBackButton(),
            titleText: LocaleKeys.parties.tr(),
            headerTextColor: const Color(0xFFEBEDEC),
            actions: [
              InkWell(
                onTap: () {
                  AppNavigator.push(context, const AddPartyScreen());
                },
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFFEBEDEC),
                  ),
                  padding: EdgeInsets.all(8.r),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 24.r,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.parties.isEmpty
                    ? Center(
                        child: Text(LocaleKeys.partyNoParties.tr()),
                      )
                    : ListView.separated(
                        itemCount: state.parties.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final party = state.parties[index];
                          return PartyTile(party: party);
                        },
                      ),
          ),
        );
      },
    );
  }
}
