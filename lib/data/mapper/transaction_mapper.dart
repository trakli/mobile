import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';

class TransactionMapper {
  static TransactionEntity toDomain(Transaction row) {
    return TransactionEntity(
      clientId: row.clientId,
      amount: row.amount,
      description: row.description ?? '',
      lastSyncedAt: row.lastSyncedAt,
      createdAt: row.createdAt,
      datetime: row.datetime,
      type: row.type, 
      updatedAt: row.updatedAt,
    );
  }

  static List<TransactionEntity> toDomainList(List<Transaction> dataList) {
    return dataList.map((data) => toDomain(data)).toList();
  }

  static Transaction toData(TransactionEntity entity) {
    return Transaction(
      clientId: entity.clientId,
      amount: entity.amount,
      description: entity.description,
      // rev: entity.rev,
      type: entity.type,
      datetime: entity.datetime,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
