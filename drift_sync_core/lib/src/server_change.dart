// Defines the structure for representing a change received from the server.

class ServerChange {
  final String id;
  final DateTime moment; // Timestamp of the change.
  final String
      entityType; //Type of the entity affected (e.g., "Transaction," "User").
  final String changedId;
  final bool deleted;
  final Map<String, dynamic> entity; // Changed from  Uint8List to json

  const ServerChange({
    required this.id,
    required this.moment,
    required this.entityType,
    required this.changedId,
    required this.deleted,
    required this.entity,
  });
}
