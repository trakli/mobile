import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/transactions/quick_add/quick_add_parser.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  final t0 = DateTime(2025, 1, 1);
  CategoryEntity cat(String id, String name, TransactionType type) =>
      CategoryEntity(clientId: id, type: type, name: name, createdAt: t0);
  WalletEntity wallet(String id, String name, WalletType type) => WalletEntity(
        clientId: id,
        type: type,
        name: name,
        balance: 0,
        currencyCode: 'EUR',
        createdAt: t0,
        updatedAt: t0,
      );
  PartyEntity party(String id, String name) =>
      PartyEntity(clientId: id, name: name, createdAt: t0, updatedAt: t0);

  final eating = cat('c-eat', 'Eating out', TransactionType.expense);
  final groceries = cat('c-groc', 'Groceries', TransactionType.expense);
  final salary = cat('c-sal', 'Salary', TransactionType.income);
  final main = wallet('w-main', 'Main account', WalletType.bank);
  final cash = wallet('w-cash', 'Cash', WalletType.cash);
  final momo = wallet('w-momo', 'MTN MoMo', WalletType.mobile);
  final chezLou = party('p-chez', 'Chez Lou');
  final tomas = party('p-tomas', 'Tomás Reyes');

  TransactionCompleteEntity past(String desc, CategoryEntity c,
          {PartyEntity? p}) =>
      TransactionCompleteEntity(
        transaction: TransactionEntity(
          clientId: desc,
          amount: 10,
          description: desc,
          createdAt: t0,
          updatedAt: t0,
          datetime: t0,
          type: c.type,
          walletClientId: main.clientId,
          partyClientId: p?.clientId,
        ),
        categories: [c],
        wallet: main,
        party: p,
      );

  final parser = QuickAddParser(
    categories: [eating, groceries, salary],
    wallets: [main, cash, momo],
    parties: [chezLou, tomas],
    history: [
      past('Dinner at Chez Lou', eating, p: chezLou),
      past('Carrefour market', groceries),
      past('Carrefour market', groceries),
    ],
  );
  final now = DateTime(2025, 11, 24, 15, 30);

  test('reads amount, person, wallet and suggests category from history', () {
    final r = parser.parse('12.50 lunch at Chez Lou, cash', now: now);
    expect(r.amount, 12.50);
    expect(r.party, chezLou);
    expect(r.wallet, cash);
    expect(r.category, eating);
    expect(r.categoryFromHistory, isTrue);
    expect(r.description, 'Lunch at Chez Lou');
    expect(r.typeHint, TransactionType.expense);
  });

  test('a category named in the sentence wins over history', () {
    final r = parser.parse('groceries 64,30 main account', now: now);
    expect(r.amount, 64.30);
    expect(r.category, groceries);
    expect(r.categoryFromHistory, isFalse);
    expect(r.wallet, main);
  });

  test('history words suggest a category without a person', () {
    final r = parser.parse('carrefour 52.10', now: now);
    expect(r.category, groceries);
  });

  test('income category gives an income hint', () {
    final r = parser.parse('salary 3,600', now: now);
    expect(r.amount, 3600);
    expect(r.typeHint, TransactionType.income);
  });

  test('today and yesterday in several languages', () {
    expect(parser.parse('5 coffee yesterday', now: now).date,
        DateTime(2025, 11, 23));
    expect(parser.parse('5 café hier', now: now).date, DateTime(2025, 11, 23));
    expect(parser.parse('5 Kaffee heute', now: now).date,
        DateTime(2025, 11, 24));
    expect(parser.parse('5 coffee', now: now).date, isNull);
  });

  test('accent-insensitive person match and k suffix', () {
    final r = parser.parse('lent tomas 1.5k from momo', now: now);
    expect(r.party, tomas);
    expect(r.amount, 1500);
    expect(r.wallet, momo);
    expect(r.description, 'Lent tomas');
  });

  test('wallet matched by its type when the name is not in the sentence', () {
    final onlyCash = QuickAddParser(
      categories: const [],
      wallets: [main, wallet('w-pocket', 'Pocket', WalletType.cash)],
      parties: const [],
    );
    expect(onlyCash.parse('3 bread cash', now: now).wallet?.clientId,
        'w-pocket');
  });

  test('thousand separators and comma decimals', () {
    expect(QuickAddParser.parseAmount('1,050'), 1050);
    expect(QuickAddParser.parseAmount('1 050,75'), 1050.75);
    expect(QuickAddParser.parseAmount('12,5'), 12.5);
    expect(QuickAddParser.parseAmount('184,500'), 184500);
  });

  test('no amount leaves amount null and keeps the text', () {
    final r = parser.parse('coffee', now: now);
    expect(r.amount, isNull);
    expect(r.description, 'Coffee');
  });
}
