import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this.crashReportingService);
  final CrashReportingService? crashReportingService;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('error-in-bloc(${bloc.runtimeType}, $error, $stackTrace)');
    crashReportingService?.recordError(
      error,
      stackTrace: stackTrace,
      reason: 'error-in-bloc',
    );

    super.onError(bloc, error, stackTrace);
  }
}
