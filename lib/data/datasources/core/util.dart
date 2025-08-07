DateTime dateTimeFromString(String isoString) {
  return DateTime.parse(isoString);
}

DateTime dateTimeFromSecondSinceEpoch(num timestamp) {
  final millisecondsSinceEpoch = timestamp * 1000;
  return DateTime.fromMillisecondsSinceEpoch(
    millisecondsSinceEpoch.toInt(),
    isUtc: true,
  );
}

num dateTimetoNum(DateTime datetime) {
  return datetime.millisecondsSinceEpoch;
}

DateTime? dateTimeFromStringNull(String? isoString) {
  if (isoString == null) return null;
  return DateTime.parse(isoString);
}

DateTime dateTimeFromUnixSeconds(num timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(
    timestamp.toInt() * 1000,
    isUtc: true,
  );
}

num dateTimeToUnixSeconds(DateTime datetime) {
  return datetime.millisecondsSinceEpoch / 1000;
}

DateTime? safeParseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
