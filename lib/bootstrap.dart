import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/utils/globals.dart';

/// Adds a global error handler to the Flutter app.
///
/// The error handler logs the error and its stack trace to the console.
///
/// The error handler also initializes the Flutter app by calling [WidgetsFlutterBinding.ensureInitialized] and running the app in a zone guarded against errors
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      configureDependencies(Environment.dev);

      // Initialize sync database
      // getIt<SynchAppDatabase>().init();

      await EasyLocalization.ensureInitialized();

      runApp(
        EasyLocalization(
          supportedLocales: supportedLanguages,
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            ensureScreenSize: true,
            child: await builder(),
          ),
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
