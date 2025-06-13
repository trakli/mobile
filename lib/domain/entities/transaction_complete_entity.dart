import 'package:equatable/equatable.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';

class TransactionCompleteEntity extends Equatable {
  final TransactionEntity transaction;
  final List<CategoryEntity> categories;
  final WalletEntity wallet;
  final PartyEntity? party;
  final GroupEntity? group;

  const TransactionCompleteEntity({
    required this.transaction,
    required this.categories,
    required this.wallet,
    this.party,
    this.group,
  });

  @override
  List<Object?> get props => [transaction, categories, wallet, party, group];
}
