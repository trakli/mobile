import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting.dart';
import 'package:trakli/core/error/crash_reporting/user_context_service.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/sync/drift_sync_crash_reporting_service.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/firebase_options.dart';
import 'package:trakli/presentation/utils/globals.dart';

/// Adds a global error handler to the Flutter app.
///
/// The error handler logs the error and its stack trace to the console.
///
/// The error handler also initializes the Flutter app by calling [WidgetsFlutterBinding.ensureInitialized] and running the app in a zone guarded against errors
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      configureDependencies(Environment.dev);

      // Initialize crash reporting
      final crashReportingService = getIt<CrashReportingService>();
      await crashReportingService.initialize();

      // Initialize user context service
      final userContextService = getIt<UserContextService>();
      await userContextService.initialize();

      // Initialize drift sync crash reporting
      final driftSyncCrashReportingService =
          getIt<DriftSyncCrashReportingService>();

      await driftSyncCrashReportingService.initialize();

      // Set up error handler with crash reporting
      ErrorHandler.setCrashReportingService(crashReportingService);

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
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      // Record unhandled errors in crash reporting
      final crashReportingService = getIt<CrashReportingService>();
      crashReportingService.recordFatalError(
        error,
        stackTrace: stackTrace,
        reason: 'Unhandled Error',
      );
    },
  );
}
