import 'package:trakli/data/database/tables/sync_table.dart';

/// Helper class to add default values to JSON data
class JsonDefaultsHelper {
  static const String clientGeneratedIdField = 'client_generated_id';

  /// Adds default values to JSON data before deserialization
  static Map<String, dynamic> addDefaults(Map<String, dynamic> json) {
    final Map<String, dynamic> result = Map.from(json);

    // Add client_generated_id if missing
    if (!result.containsKey(clientGeneratedIdField) ||
        result[clientGeneratedIdField] == null) {
      result[clientGeneratedIdField] = defaultClientId;
    }

    return result;
  }

  /// Adds defaults to a list of JSON objects
  static List<Map<String, dynamic>> addDefaultsToList(List<dynamic> jsonList) {
    return jsonList.whereType<Map<String, dynamic>>().map(addDefaults).toList();
  }
}
