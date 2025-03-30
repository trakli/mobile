import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';

class TransactionMapper {
  static TransactionEntity toDomain(Transaction row) {
    return TransactionEntity(
      id: row.id,
      amount: row.amount,
      description: row.description ?? '',
      createdAtLocal: row.createdAtLocal,
      updatedAtLocal: row.updatedAtLocal,
      updatedAtServer: row.updatedAtServer,
      deletedAtServer: row.deletedAtLocal,
      lastSyncedAt: row.lastSyncedAt,
      rev: row.rev,
      category: row.category,
    );
  }

  static List<TransactionEntity> toDomainList(List<Transaction> dataList) {
    return dataList.map((data) => toDomain(data)).toList();
  }

  static Transaction toData(TransactionEntity entity) {
    return Transaction(
      id: entity.id,
      amount: entity.amount,
      description: entity.description,
      category: entity.category,
      createdAtLocal: entity.createdAtLocal,
      updatedAtLocal: entity.updatedAtLocal,
      updatedAtServer: entity.updatedAtServer,
      deletedAtLocal: entity.deletedAtServer,
      lastSyncedAt: entity.lastSyncedAt,
      rev: entity.rev,
    );
  }
}
