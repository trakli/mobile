import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static Future<dynamic> push(
    BuildContext context,
    Widget screen,
  ) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  static Future<dynamic> pushReplacement(BuildContext context, Widget screen) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  static void pop(BuildContext context, [dynamic data]) {
    return Navigator.of(context).pop(data);
  }

  static void popUntilFirst(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static Future<dynamic> removeAllPreviousAndPush(
    BuildContext context,
    Widget screen,
  ) {
    return Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  static void removeAllPreviousAndPushThenPush(
    BuildContext context,
    Widget screenOne,
    Widget screenTwo,
  ) {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(builder: (_) => screenOne),
    );
    Future.delayed(Duration.zero, () {
      navigator.push(
        MaterialPageRoute(builder: (_) => screenTwo),
      );
    });
  }
}
