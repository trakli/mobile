import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/statistics/overview/overview_data.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  final t0 = DateTime(2026, 1, 1);
  final eur = WalletEntity(
    clientId: 'w',
    type: WalletType.bank,
    name: 'Main',
    balance: 0,
    currencyCode: 'EUR',
    createdAt: t0,
    updatedAt: t0,
  );
  CategoryEntity cat(String name, TransactionType type) => CategoryEntity(
        clientId: 'c-$name',
        type: type,
        name: name,
        createdAt: t0,
      );
  final food = cat('Food', TransactionType.expense);
  final rent = cat('Rent', TransactionType.expense);
  final salary = cat('Salary', TransactionType.income);
  final lou = PartyEntity(
    clientId: 'p',
    name: 'Chez Lou',
    createdAt: t0,
    updatedAt: t0,
  );

  var seq = 0;
  TransactionCompleteEntity tx(
    DateTime when,
    double amount,
    TransactionType type, {
    List<CategoryEntity> categories = const [],
    PartyEntity? party,
  }) =>
      TransactionCompleteEntity(
        transaction: TransactionEntity(
          clientId: 'tx${seq++}',
          amount: amount,
          description: '',
          createdAt: when,
          updatedAt: when,
          datetime: when,
          type: type,
          walletClientId: eur.clientId,
        ),
        categories: categories,
        wallet: eur,
        party: party,
      );

  const inc = TransactionType.income;
  const exp = TransactionType.expense;

  final list = [
    tx(DateTime(2026, 11, 3, 9), 3600, inc, categories: [salary]),
    tx(DateTime(2026, 11, 3, 18), 900, exp, categories: [rent]),
    tx(DateTime(2026, 11, 5, 13), 12.5, exp, categories: [food], party: lou),
    tx(DateTime(2026, 11, 6, 13), 20, exp, categories: [food], party: lou),
    tx(DateTime(2026, 11, 6, 19), 8, exp),
  ];

  test('totals and net', () {
    final o = buildStatsOverview(list, (t) => t.transaction.amount);
    expect(o.income, 3600);
    expect(o.expense, 940.5);
    expect(o.net, 2659.5);
  });

  test('amounts go through the converter', () {
    final o = buildStatsOverview(list, (t) => t.transaction.amount * 2);
    expect(o.income, 7200);
    expect(o.expense, 1881);
  });

  test('one bar per calendar day, oldest first', () {
    final o = buildStatsOverview(list, (t) => t.transaction.amount);
    expect(o.days.map((d) => d.day.day), [3, 5, 6]);
    expect(o.days.first.income, 3600);
    expect(o.days.first.expense, 900);
    expect(o.days.last.expense, 28);
  });

  test('categories ranked by amount, uncategorized kept as null', () {
    final o = buildStatsOverview(list, (t) => t.transaction.amount);
    expect(o.expenseCategories.map((c) => c.category?.name),
        ['Rent', 'Food', null]);
    final foodRow = o.expenseCategories[1];
    expect(foodRow.amount, 32.5);
    expect(foodRow.count, 2);
    expect(o.incomeCategories.single.category, salary);
  });

  test('parties carry a signed net and an entry count', () {
    final o = buildStatsOverview(list, (t) => t.transaction.amount);
    expect(o.people.single.party, lou);
    expect(o.people.single.net, -32.5);
    expect(o.people.single.count, 2);
  });
}
