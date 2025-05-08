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
