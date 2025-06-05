import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

extension LoggerExtension on Logger {
  void info(String message) {
    d(message);
  }

  void warning(String message) {
    w(message);
  }

  void e(String message) {
    e(message);
  }
}
