import 'package:easy_localization/easy_localization.dart';

DateTime formatServerIsoDateTime(DateTime now) {
  final formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'").format(now);
  final dateTime = DateTime.parse(formatted);
  return dateTime;
}
