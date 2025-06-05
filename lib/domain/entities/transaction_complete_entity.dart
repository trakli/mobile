import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';

part 'transaction_complete_entity.freezed.dart';

@freezed
class TransactionCompleteEntity with _$TransactionCompleteEntity {
  factory TransactionCompleteEntity({
    required TransactionEntity transaction,
    required List<CategoryEntity> categories,
    required WalletEntity wallet,
  }) = _TransactionCompleteEntity;
}
