import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_widget.dart' show setOnboardingMode;
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/onboarding/widgets/all_set_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/category_setup_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/group_setup_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/language_setting_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/wallet_setup_widget.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/splash/splash_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

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
  late PageController pageController;
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

  @override
  void dispose() {
    // Safety: ensure we never leave a global loader overlay showing
    // when navigating away from onboarding.
    hideLoader();
    pageController.dispose();
    super.dispose();
  }

  void _loadCurrencyFromConfig() {
    final currency = getDefaultCurrencyFromConfig(context);
    if (currency != null) {
      context.read<CurrencyCubit>().setCurrency(currency);
    }
  }

  Future<void> _saveOnboardingComplete() async {
    context.read<ConfigCubit>().saveConfig(
          key: ConfigConstants.onboardingComplete,
          type: ConfigType.bool,
          value: true,
        );
  }

  int _getInitialStep({
    required bool hasDefaultLang,
    required bool hasDefaultGroup,
    required bool hasDefaultWallet,
    required bool hasDefaultCurrency,
  }) {
    if (!hasDefaultLang) return 0;
    if (!hasDefaultGroup) return 1;
    if (!hasDefaultWallet || !hasDefaultCurrency) return 2;

    // category setup always shown (you can also make this conditional)
    return 3;
  }

  Future<void> _determineSteps() async {
    final entityResult = await getIt<ConfigRepository>().getAllConfigs();
    final entityConfigs = entityResult.fold(
      (failure) => [],
      (entity) => entity,
    );

    final hasDefaultLang =
        entityConfigs.any((c) => c.key == ConfigConstants.defaultLang);

    final hasDefaultWallet =
        entityConfigs.any((c) => c.key == ConfigConstants.defaultWallet);

    final hasDefaultCurrency =
        entityConfigs.any((c) => c.key == ConfigConstants.defaultCurrency);

    final hasDefaultGroup =
        entityConfigs.any((c) => c.key == ConfigConstants.defaultGroup);

    final pages = [
      pageOne,
      pageTwo,
      pageThree,
      pageFive,
      pageFour,
    ];

    final initialIndex = _getInitialStep(
      hasDefaultLang: hasDefaultLang,
      hasDefaultGroup: hasDefaultGroup,
      hasDefaultWallet: hasDefaultWallet,
      hasDefaultCurrency: hasDefaultCurrency,
    );

    final isComplete = initialIndex >= pages.length - 1;

    if (isComplete) {
      await _saveOnboardingComplete();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppNavigator.removeAllPreviousAndPush(
          context,
          const MainNavigationScreen(),
        );
      });
      return;
    }

    setState(() {
      pendingPages = pages;
      _totalSteps = pages.length;
      _currentPage = initialIndex;
      pageController = PageController(initialPage: initialIndex);
      isSettingComplete = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !pageController.hasClients) return;
      pageController.jumpToPage(initialIndex);
    });
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
            backgroundColor: context.tones.bgPage,
            body: SafeArea(
              child: LedgerEmptyState(
                icon: LucideIcons.cloudAlert,
                title: configState.failure.customMessage,
                actionLabel: LocaleKeys.retry.tr(),
                onAction: () => context.read<ConfigCubit>().getConfigs(),
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
        backgroundColor: context.tones.bgPage,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.lx, 20.lx, 16.lx, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TrakliLogo(height: 26),
                    SizedBox(height: 18.lx),
                    Text(
                      LocaleKeys.welcomeText.tr(),
                      style: LedgerText.display(
                        size: 24.lx,
                        color: context.tones.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.lx),
                    Text(
                      LocaleKeys.welcomeDesc.tr(),
                      style: TextStyle(
                        fontSize: 13.5.lx,
                        height: 1.4,
                        color: context.tones.textSecondary,
                      ),
                    ),
                    SizedBox(height: 14.lx),
                    Row(
                      children: [
                        Expanded(
                          child: LedgerBar(
                            value: pendingPages.isEmpty
                                ? 1
                                : (_currentPage + 1) /
                                    (_totalSteps == 0 ? 1 : _totalSteps),
                          ),
                        ),
                        SizedBox(width: 10.lx),
                        Text(
                          LocaleKeys.stepCounter.tr(
                            args: [
                              (_currentPage + 1).toString(),
                              (_totalSteps == 0 ? 1 : _totalSteps).toString(),
                            ],
                          ),
                          style: LedgerText.money(
                            size: 12.lx,
                            color: context.tones.textMuted,
                          ),
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
                          hideKeyBoard();
                        },
                        children: pendingPages,
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

  Widget get pageFive {
    return CategorySetupWidget(
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
        await _saveOnboardingComplete();

        getIt<SynchAppDatabase>().sync();

        if (mounted) {
          AppNavigator.removeAllPreviousAndPush(
            context,
            const MainNavigationScreen(),
          );
        }
      },
      onPrev: () {
        prevPage();
      },
    );
  }
}
