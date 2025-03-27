class TransactionModel {
  final String id;
  final double amount;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncedAt;

  TransactionModel({
    required this.id,
    required this.amount,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.lastSyncedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      lastSyncedAt: map['lastSyncedAt'] != null
          ? DateTime.parse(map['lastSyncedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel.fromMap(json);
}
