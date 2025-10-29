import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/onboarding/widgets/language_setting_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/wallet_setup_widget.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
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
    return BlocListener<OnboardingCubit, OnboardingState>(
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
                      "Let's set up your account in just a few steps",
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
    return WalletSetupWidget(onTap: () {
      nextPage();
    });
  }

  Widget get pageThree {
    final state = context.watch<OnboardingCubit>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingCubit, OnboardingState>(
          listener: (BuildContext context, OnboardingState state) {
            state.when(
              initial: () {},
              loading: () {
                showLoader();
              },
              success: (user) {
                hideLoader();
              },
              error: (failure) {
                hideLoader();
                showSnackBar(
                  message: failure.customMessage,
                  borderRadius: 8.r,
                );
              },
            );
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
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 36.h),
            Icon(
              Icons.currency_exchange,
              color: Theme.of(context).primaryColor,
              size: 100.r,
            ),
            SizedBox(height: 12.h),
            Text(
              LocaleKeys.selectCurrency.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: (state.entity?.selectedCurrency == currency)
                          ? Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: (state.entity?.selectedCurrency?.code ==
                                currency.code)
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedCurrency = currency;
                          context
                              .read<OnboardingCubit>()
                              .selectCurrency(currency);
                        });
                      },
                      leading: flagWidget(currency),
                      title: Text(
                        currency.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        currency.code,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: Text(
                        currency.symbol,
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      // trailing: ,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: Builder(builder: (context) {
                final state = context.watch<OnboardingCubit>().state;

                final isCurrencySelected =
                    state.entity?.selectedCurrency != null;

                return PrimaryButton(
                  onPress: !isCurrencySelected
                      ? null
                      : () async {
                          setOnboardingMode(false);
                          AppNavigator.removeAllPreviousAndPush(
                            context,
                            MainNavigationScreen(),
                          );
                        },
                  backgroundColor:
                      isCurrencySelected ? null : Colors.grey.shade300,
                  buttonTextColor: isCurrencySelected ? null : Colors.grey,
                  buttonText: LocaleKeys.done.tr(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
