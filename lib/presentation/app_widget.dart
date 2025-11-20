import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/config_repository.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/benefits/cubit/benefits_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/linear_indicator.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/onboarding/onboarding_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/splash/splash_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/sync_cubit.dart';
import 'package:trakli/presentation/utils/theme.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

// Global flag to track if we're in onboarding mode
bool _isInOnboardingMode = false;

// Getter and setter for onboarding mode
bool get isInOnboardingMode => _isInOnboardingMode;

void setOnboardingMode(bool value) => _isInOnboardingMode = value;

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TransactionCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>()..listenToAuthStatus(),
        ),
        BlocProvider(
          create: (_) => getIt<LoginCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<RegisterCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<OnboardingCubit>()..getOnboardingState(),
        ),
        BlocProvider(
          create: (_) => getIt<ExchangeRateCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<WalletCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PartyCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<GroupCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SyncCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PlansCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<BenefitsCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ConfigCubit>(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  initState() {
    super.initState();
    clearKeychainValues();
    // _setupOnboardingWatch();
  }

  Future<void> clearKeychainValues() async {
    final prefs = getIt<PreferenceManager>();

    if (prefs.getBool(KeyConstants.isFirstAppLaunch) ?? true) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.deleteAll();

      await prefs.setBool(KeyConstants.isFirstAppLaunch, false);
    }
  }

  // Future<void> _setupOnboardingWatch() async {
  //   final entityResult =
  //       await getIt<OnboardingRepository>().getOnboardingState();
  //
  //   final entity = entityResult.fold(
  //     (failure) => null,
  //     (entity) => entity,
  //   );
  //
  //   if (entity?.isOnboardingComplete == true) {
  //     final currency = entity?.selectedCurrency;
  //
  //     if (currency != null) {
  //       // Setup default group and wallet with selected currency
  //
  //       if (mounted) {
  //         await setupDefaultGroupAndWallet(
  //           context: context,
  //           currencyCode: currency.code,
  //         );
  //       }
  //     }
  //   }
  // }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {});

    return GlobalLoaderOverlay(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
      // overlayColor: Colors.grey(0.8),
      overlayWidgetBuilder: (_) {
        //ignored progress for the moment
        return Center(
          child: SpinKitFadingCircle(
            color: appPrimaryColor,
            // size: 30.sp,
          ),
        );
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Trakli',
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: lightTheme,
        builder: (context, child) {
          return Stack(
            children: [
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    authenticated: (user) async {
                      getIt<SynchAppDatabase>().doSync();

                      final langCode = await getIt<ConfigRepository>()
                          .getConfigByKey(ConfigConstants.defaultLang);

                      final entityLang = langCode.fold(
                        (failure) => null,
                        (entity) => entity,
                      );

                      if (entityLang?.value != null) {
                        if (context.mounted) {
                          updateLanguage(context, Locale(entityLang?.value));
                        }
                      }

                      final entityResult = await getIt<ConfigRepository>()
                          .getConfigByKey(ConfigConstants.onboardingComplete);

                      final entityOnboard = entityResult.fold(
                        (failure) => null,
                        (entity) => entity,
                      );

                      if (entityOnboard?.value == true) {
                        setOnboardingMode(false);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainNavigationScreen(),
                          ),
                          (route) => false,
                        );
                      } else {
                        setOnboardingMode(true);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const OnboardSettingsScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    unauthenticated: () async {
                      getIt<SynchAppDatabase>().stopAllSync();
                      context.read<TransactionCubit>().setCurrentGroup(null);

                      final entityResult = await getIt<OnboardingRepository>()
                          .getOnboardingState();

                      final entity = entityResult.fold(
                        (failure) => null,
                        (entity) => entity,
                      );

                      if (entity?.isOnboardingComplete == true) {
                        setOnboardingMode(false);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainNavigationScreen(),
                          ),
                          (route) => false,
                        );
                      } else {
                        setOnboardingMode(true);
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    orElse: () {},
                  );
                },
                child: child,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BlocBuilder<SyncCubit, bool>(
                  builder: (context, isSyncing) {
                    if (!isSyncing) return const SizedBox.shrink();

                    // Don't show sync indicator on onboarding screens
                    if (isInOnboardingMode) {
                      return const SizedBox.shrink();
                    }

                    return const SyncIndicatorOverlay();
                  },
                ),
              ),
            ],
          );
        },
        onGenerateRoute: (_) => SplashScreen.route(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(LocaleKeys.appName.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(Assets.images.appLogo),
            Text(
              LocaleKeys.welcomeText.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
