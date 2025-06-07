import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/mappers/category_mapper.dart';
import 'package:trakli/data/mappers/party_mapper.dart';
import 'package:trakli/data/mappers/wallet_mapper.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';

class _TransactionMapper {
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
      walletClientId: row.walletClientId,
    );
  }
}

class TransactionCompleteModelMapper {
  static TransactionCompleteEntity toDomain(TransactionCompleteDto data) {
    return TransactionCompleteEntity(
      transaction: _TransactionMapper.toDomain(data.transaction),
      categories:
          data.categories.map((c) => CategoryMapper.toDomain(c)).toList(),
      wallet: WalletMapper.toDomain(data.wallet),
      party: data.party != null ? PartyMapper.toDomain(data.party!) : null,
    );
  }

  static List<TransactionCompleteEntity> toDomainList(
      List<TransactionCompleteDto> dataList) {
    return dataList.map((data) => toDomain(data)).toList();
  }
}
