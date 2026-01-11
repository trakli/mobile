import 'package:easy_localization/easy_localization.dart';

DateTime _formatServerIsoDateTime(DateTime now) {
  final formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'").format(now);
  final dateTime = DateTime.parse(formatted);
  return dateTime;
}

String formatServerIsoDateTimeString(DateTime utcDateTime) {
  return _formatServerIsoDateTime(utcDateTime).toIso8601String();
}

DateTime getNewFormattedUtcDateTime() {
  final now = DateTime.now().toUtc();
  return DateTime.parse(now.toIso8601String());
}

DateTime getFormattedUtcDateTimeFromUtc(DateTime utcDateTime) {
  return DateTime.parse(utcDateTime.toUtc().toIso8601String());
}
