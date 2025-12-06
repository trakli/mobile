import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart' show setOnboardingMode;
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/onboarding/widgets/all_set_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/group_setup_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/language_setting_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/wallet_setup_widget.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/splash/splash_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

// Reusable helper to resolve the default currency from configs
Currency? getDefaultCurrencyFromConfig(BuildContext context) {
  final configCubit = context.read<ConfigCubit>();
  final hasDefaultCurrency =
      configCubit.state.hasConfig(ConfigConstants.defaultCurrency);
  if (!hasDefaultCurrency) return null;

  final defaultCurrencyConfig =
      configCubit.state.getConfigByKey(ConfigConstants.defaultCurrency);
  final currencyCode = defaultCurrencyConfig?.value as String?;
  if (currencyCode == null || currencyCode.isEmpty) return null;

  final allCurrencies = CurrencyService().getAll();
  return allCurrencies.firstWhereOrNull((c) => c.code == currencyCode);
}

class OnboardSettingsScreen extends StatefulWidget {
  const OnboardSettingsScreen({super.key});

  @override
  State<OnboardSettingsScreen> createState() => _OnboardSettingsScreenState();
}

class _OnboardSettingsScreenState extends State<OnboardSettingsScreen> {
  PageController pageController = PageController();
  List<Currency> currencies = [];

  int _currentPage = 0;
  int _totalSteps = 0;
  List<Widget> pendingPages = [];
  bool isSettingComplete = false; // Start as false (setup in progress)

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

  @override
  void initState() {
    super.initState();
    _determineSteps();
    _loadCurrencyFromConfig();
  }

  void _loadCurrencyFromConfig() {
    final currency = getDefaultCurrencyFromConfig(context);
    if (currency != null) {
      context.read<CurrencyCubit>().setCurrency(currency);
    }
  }

  Future<void> _determineSteps() async {
    final entityResult = await getIt<ConfigRepository>().getAllConfigs();
    final entityConfigs = entityResult.fold(
      (failure) => [],
      (entity) => entity,
    );

    final hasDefaultLang = entityConfigs
        .any((config) => config.key == ConfigConstants.defaultLang);

    final hasDefaultWallet = entityConfigs
        .any((config) => config.key == ConfigConstants.defaultWallet);

    final hasDefaultCurrency = entityConfigs
        .any((config) => config.key == ConfigConstants.defaultCurrency);

    final hasDefaultGroup = entityConfigs
        .any((config) => config.key == ConfigConstants.defaultGroup);

    final List<Widget> nextPages = [];

    if (!hasDefaultLang) {
      nextPages.add(pageOne);
    }

    if (!hasDefaultGroup) {
      nextPages.add(pageTwo);
    }

    if (!hasDefaultWallet || !hasDefaultCurrency) {
      nextPages.add(pageThree);
    }

    nextPages.add(pageFour);

    final shouldShow = nextPages.length >= 2;

    if (!shouldShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppNavigator.removeAllPreviousAndPush(
          context,
          MainNavigationScreen(),
        );
      });
    } else {
      if (mounted) {
        setState(() {
          pendingPages = nextPages;
          _totalSteps = nextPages.length;
          if (shouldShow) {
            _currentPage = 0;
          } else if (_currentPage >= pendingPages.length) {
            _currentPage = pendingPages.length - 1;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !pageController.hasClients) return;
            pageController.jumpToPage(_currentPage);
          });
        });
      }

      setState(() {
        isSettingComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      // No buildWhen - rebuild on any state change or when isSettingComplete changes
      builder: (context, configState) {
        // Show splash screen if loading or setup is not complete
        if (configState.isLoading || !isSettingComplete) {
          return const SplashScreen();
        }

        // Show error state if there's a failure
        if (configState.failure.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    configState.failure.customMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConfigCubit>().getConfigs();
                    },
                    child: Text(LocaleKeys.retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        // Show content when not loading and no failure
        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CurrencyCubit, CurrencyState>(
          listenWhen: (previous, current) =>
              previous.currency != current.currency,
          listener: (context, state) {
            // Currency selection is now handled via config
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
        BlocListener<GroupCubit, GroupState>(
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
        BlocListener<ConfigCubit, ConfigState>(
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
          ),
          child: SafeArea(
            top: false,
            left: false,
            right: false,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: LinearProgressIndicator(
                                value: pendingPages.isEmpty
                                    ? 1
                                    : (_currentPage + 1) /
                                        (_totalSteps == 0 ? 1 : _totalSteps),
                                backgroundColor: Colors.grey,
                                valueColor:
                                    AlwaysStoppedAnimation(appPrimaryColor),
                                minHeight: 6.h,
                              ),
                            ),
                          ),
                          Text(
                            LocaleKeys.stepCounter.tr(
                              args: [
                                (_currentPage + 1).toString(),
                                (_totalSteps == 0 ? 1 : _totalSteps).toString(),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: pendingPages.isEmpty
                      ? const SizedBox.shrink()
                      : PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: pendingPages,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get pageOne {
    return LanguageSettingWidget(
      onTap: () async {
        final configCubit = context.read<ConfigCubit>();

        final hasDefaultLang =
            configCubit.state.hasConfig(ConfigConstants.defaultLang);

        if (!hasDefaultLang) {
          await configCubit.saveConfig(
            key: ConfigConstants.defaultLang,
            type: ConfigType.string,
            value: context.locale.languageCode,
          );
        }
        nextPage();
      },
    );
  }

  Widget get pageTwo {
    return GroupSetupWidget(
      onNext: () {
        nextPage();
      },
      onPrev: () {
        prevPage();
      },
    );
  }

  Widget get pageThree {
    return WalletSetupWidget(
      onNext: () {
        nextPage();
      },
      onPrev: () {
        prevPage();
      },
    );
  }

  Widget get pageFour {
    return AllSetWidget(
      onTap: () async {
        setOnboardingMode(false);
        context.read<ConfigCubit>().saveConfig(
              key: ConfigConstants.onboardingComplete,
              type: ConfigType.bool,
              value: true,
            );
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
