// import 'package:device_uuid/device_uuid.dart';
import 'package:flutter_device_uuid/flutter_device_uuid.dart';
import 'package:uuid/uuid.dart';

/// Generates a unique ID by combining the device UUID and a random UUID.
/// If device UUID is unavailable, returns only the random UUID.
Future<String> generateDeviceScopedId() async {
  final randomId = const Uuid().v4();
  String? deviceId = await DeviceUuid.uuid() ?? randomId;
  var identifier = const Uuid().v4();

  final id = '$deviceId:$identifier';
  return id;
}
