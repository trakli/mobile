// import 'package:device_uuid/device_uuid.dart';
import 'package:uuid/uuid.dart';

/// Generates a unique ID by combining the device UUID and a random UUID.
/// If device UUID is unavailable, returns only the random UUID.
Future<String> generateDeviceScopedId() async {
  // final deviceId = await DeviceUuid().getUUID();
  final randomId = const Uuid().v4();

  return randomId;
  // return deviceId != null ? '$deviceId-$randomId' : randomId;
}
