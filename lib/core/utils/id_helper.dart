// import 'package:device_uuid/device_uuid.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Returns a SHA256 hash of the result.
String hashConcatenatedStrings(String id) {
  final bytes = utf8.encode(id);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// Generates a unique ID by combining the device UUID and a random UUID.
/// If device UUID is unavailable, returns only the random UUID.
Future<String> generateDeviceScopedId() async {
  final deviceId = await DeviceUuid().getUUID();
  final randomId = const Uuid().v4();

  // return randomId;
  final random = deviceId != null ? '$deviceId-$randomId' : randomId;
  return hashConcatenatedStrings(random);
}
