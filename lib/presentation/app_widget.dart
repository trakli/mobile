import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/onboarding/onboarding_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/splash/splash_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

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
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  // final _navigatorKey = GlobalKey<NavigatorState>();

  // NavigatorState get _navigator => _navigatorKey.currentState!;

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
        theme: ThemeData(
          primaryColor: const Color(0xFF047844),
          primaryColorLight: const Color(0xFFDFE1E4),
          primaryColorDark: const Color(0xFF1E2448),
          hintColor: const Color(0xFFF7B600),
          scaffoldBackgroundColor: const Color(0xFFEBEDEC),
          brightness: Theme.of(context).brightness,
          useMaterial3: true,
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            headerBackgroundColor: const Color(0xFF047844),
            headerForegroundColor: Colors.white,
            todayBackgroundColor: WidgetStatePropertyAll(appPrimaryColor),
            todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
            cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
            ),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
            ),
          ),
          timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            backgroundColor: Colors.white,
            cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
            ),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
            ),
            dayPeriodColor: appPrimaryColor.withAlpha(50),
            dayPeriodBorderSide: BorderSide(
              color: Colors.grey.shade500,
            ),
            dayPeriodShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            dialHandColor: appPrimaryColor,
          ),
          textTheme: TextTheme(
            headlineMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            headlineSmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            labelSmall: TextStyle(
              fontSize: 12.sp,
              color: textColor,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(
                TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              backgroundColor: const WidgetStatePropertyAll(
                Color(0xFF047844),
              ),
              foregroundColor: const WidgetStatePropertyAll(
                Colors.white,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: 32.0.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF5F6F7),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFF047844),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            floatingLabelStyle: TextStyle(
              color: appPrimaryColor,
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: const BorderSide(
                color: Color(0xFFE6E8E9),
              ),
            ),
            menuPadding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 0,
            ),
            position: PopupMenuPosition.under,
            labelTextStyle: WidgetStatePropertyAll(
              TextStyle(
                fontSize: 14.sp,
                color: const Color(0XFF00171F),
              ),
            ),
          ),
        ),
        builder: (context, child) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (user) async {
                  getIt<SynchAppDatabase>().init();

                  final entityResult =
                      await getIt<OnboardingRepository>().getOnboardingState();

                  final entity = entityResult.fold(
                    (failure) => null,
                    (entity) => entity,
                  );

                  if (entity?.isOnboardingComplete == true) {
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainNavigationScreen(),
                      ),
                      (route) => false,
                    );
                  } else {
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const OnboardSettingsScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                unauthenticated: () async {
                  final entityResult =
                      await getIt<OnboardingRepository>().getOnboardingState();

                  final entity = entityResult.fold(
                    (failure) => null,
                    (entity) => entity,
                  );

                  if (entity?.isOnboardingComplete == true) {
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainNavigationScreen(),
                      ),
                      (route) => false,
                    );
                  } else {
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
          );
        },
        onGenerateRoute: (_) => SplashScreen.route(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // getIt<SynchAppDatabase>().sync();
    // getIt<SynchAppDatabase>().init();
  }

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
