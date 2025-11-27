import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class EmptyHomeWidget extends StatefulWidget {
  const EmptyHomeWidget({super.key});

  @override
  State<EmptyHomeWidget> createState() => _EmptyHomeWidgetState();
}

class _EmptyHomeWidgetState extends State<EmptyHomeWidget> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentIndex = 0;
  final int _numPages = 5;

  final List<EmptyStateModel> _pages = [
    emptyTransactionData,
    emptyWalletData,
    emptyCategoryData,
    emptyPartyData,
    youAllSetData,
  ];

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentIndex < _numPages - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: appPrimaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.waving_hand_outlined,
                color: appPrimaryColor,
                size: 28.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${LocaleKeys.homeWelcome.tr()}, ${user?.firstName ?? ""}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: appPrimaryColor,
                      ),
                    ),
                    Text(
                      LocaleKeys.financeInfo.tr(),
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: appPrimaryColor,
              dotColor: Colors.green.shade200,
              dotHeight: 8.h,
              dotWidth: 8.h,
              expansionFactor: 3,
              spacing: 6.w,
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final data = _pages[index];
              return _buildPage(data);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPage(EmptyStateModel data) {
    final cubit = context.read<MainNavigationCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: appPrimaryColor.withAlpha(30),
            child: Icon(
              data.icon,
              size: 28.sp,
              color: appPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            data.title1?.tr() ?? data.title.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            data.description1?.tr() ?? data.description.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${LocaleKeys.whyThisMatters.tr()}:",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: appPrimaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
                if (data.quickSteps != null)
                  ...data.quickSteps!.map(
                    (p) => _buildPoint(
                      icon: p.icon,
                      text: p.description.tr(),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          if (data.buttonText.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  switch (_currentIndex) {
                    case 0:
                      final selectedWallet =
                          context.read<WalletCubit>().currentSelectedWallet;
                      AppNavigator.push(
                        context,
                        AddTransactionScreen(selectedWallet: selectedWallet),
                      );
                    case 1:
                      cubit.updateIndex(MainNavigationPageState.wallet);
                    case 2:
                      AppNavigator.push(
                        context,
                        const CategoryScreen(),
                      );
                    case 3:
                      AppNavigator.push(context, const PartyScreen());
                  }
                },
                child: Text(
                  data.buttonText1?.tr() ?? "",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPoint({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: appPrimaryColor, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
