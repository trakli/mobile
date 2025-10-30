import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart' show setOnboardingMode;
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/onboarding/widgets/all_set_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/language_setting_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/wallet_setup_widget.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class OnboardSettingsScreen extends StatefulWidget {
  const OnboardSettingsScreen({super.key});

  @override
  State<OnboardSettingsScreen> createState() => _OnboardSettingsScreenState();
}

class _OnboardSettingsScreenState extends State<OnboardSettingsScreen> {
  PageController pageController = PageController();
  List<Currency> currencies = [];
  Currency? selectedCurrency;

  int _currentPage = 0;
  final int _pageSize = 3;

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  void prevPage() {
    pageController.previousPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  void _loadCurrencies() {
    setState(() {
      const countryCode = KeyConstants.defaultCurrencyCode;

      final allCurrencies = CurrencyService().getAll();

      // Make XAF (Cameroon) the first currency
      final xafCurrency =
          allCurrencies.firstWhere((c) => c.code == countryCode);
      currencies = [xafCurrency];

      // Add all other currencies except XAF
      currencies.addAll(allCurrencies.where((c) => c.code != countryCode));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingCubit, OnboardingState>(
          listenWhen: (previous, current) =>
              previous.currencySymbol != current.currencySymbol,
          listener: (context, state) {
            final currency = state.entity?.selectedCurrency;
            if (currency != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setupDefaultGroupAndWallet(
                  context: context,
                  currencyCode: currency.code,
                );
              });
            }
          },
        ),
        BlocListener<WalletCubit, WalletState>(
          listenWhen: (previous, current) =>
              previous.isSaving != current.isSaving,
          listener: (context, state) {
            if (state.isSaving) {
              showLoader();
            } else {
              hideLoader();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: 0.08.sh,
            bottom: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.images.logoGreen,
                      height: 38.h,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      LocaleKeys.welcomeText.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      LocaleKeys.welcomeDesc.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(12.r),
                            child: LinearProgressIndicator(
                              value: (_currentPage + 1) / _pageSize,
                              backgroundColor: Colors.grey,
                              valueColor:
                                  AlwaysStoppedAnimation(appPrimaryColor),
                              minHeight: 6.h,
                            ),
                          ),
                        ),
                        Text(
                          'Step ${_currentPage + 1} of $_pageSize',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: ((index) {
                    setState(() {
                      _currentPage = index;
                    });
                  }),
                  children: [
                    pageOne,
                    pageTwo,
                    pageThree,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get pageOne {
    return LanguageSettingWidget(
      onTap: () {
        nextPage();
      },
    );
  }

  Widget get pageTwo {
    return WalletSetupWidget(
      onNext: () {
        nextPage();
      },
      onPrev: () {
        prevPage();
      },
    );
  }

  Widget get pageThree {
    return AllSetWidget(
      onTap: () async {
        setOnboardingMode(false);
        AppNavigator.removeAllPreviousAndPush(
          context,
          MainNavigationScreen(),
        );
      },
      onPrev: () {
        prevPage();
      },
    );
  }
}
