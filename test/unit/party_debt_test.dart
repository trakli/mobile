import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/parties/party_debt.dart';
import 'package:trakli/presentation/utils/enums.dart';

final _t0 = DateTime(2025, 11, 1);

WalletEntity _wallet(String currency) => WalletEntity(
      clientId: 'w-$currency',
      type: WalletType.cash,
      name: currency,
      balance: 0,
      currencyCode: currency,
      createdAt: _t0,
      updatedAt: _t0,
    );

final _tomas = PartyEntity(
  clientId: 'p-tomas',
  name: 'Tomás Reyes',
  createdAt: _t0,
  updatedAt: _t0,
);

var _seq = 0;
TransactionCompleteEntity _tx(
  double amount,
  TransactionIntent intent, {
  String currency = 'EUR',
  PartyEntity? party,
}) {
  _seq++;
  final type = intent.side == TransactionIntentSide.expense
      ? TransactionType.expense
      : TransactionType.income;
  return TransactionCompleteEntity(
    transaction: TransactionEntity(
      clientId: 't$_seq',
      amount: amount,
      description: '',
      createdAt: _t0,
      updatedAt: _t0,
      datetime: _t0,
      type: type,
      intent: intent,
      walletClientId: 'w-$currency',
      partyClientId: (party ?? _tomas).clientId,
    ),
    categories: const [],
    wallet: _wallet(currency),
    party: party ?? _tomas,
  );
}

void main() {
  group('computePartyDebt mirrors loans_debt_net per party', () {
    test('money lent out then partly paid back means they owe you', () {
      final debt = computePartyDebt([
        _tx(120, TransactionIntent.debtSettled),
        _tx(40, TransactionIntent.debtOwed),
      ], 'p-tomas');

      expect(debt.inflow, 40);
      expect(debt.outflow, 120);
      expect(debt.net, -80);
      expect(debt.direction, PartyDebtDirection.theyOweYou);
      expect(debt.outstanding, 80);
      expect(debt.total, 120);
      expect(debt.repaid, 40);
      expect(debt.progress, closeTo(1 / 3, 1e-9));
    });

    test('a loan received and partly repaid means you owe them', () {
      final debt = computePartyDebt([
        _tx(500, TransactionIntent.loanReceived),
        _tx(200, TransactionIntent.loanRepayment),
      ], 'p-tomas');

      expect(debt.net, 300);
      expect(debt.direction, PartyDebtDirection.youOweThem);
      expect(debt.total, 500);
      expect(debt.repaid, 200);
    });

    test('loan and debt intents are summed into one ledger', () {
      final debt = computePartyDebt([
        _tx(100, TransactionIntent.loanReceived),
        _tx(50, TransactionIntent.debtOwed),
        _tx(30, TransactionIntent.loanRepayment),
        _tx(20, TransactionIntent.debtSettled),
      ], 'p-tomas');

      expect(debt.net, (100 + 50) - (30 + 20));
    });

    test('regular and other intents and other parties are ignored', () {
      final other = PartyEntity(
        clientId: 'p-other',
        name: 'Other',
        createdAt: _t0,
        updatedAt: _t0,
      );
      final debt = computePartyDebt([
        _tx(10, TransactionIntent.regular),
        _tx(10, TransactionIntent.gift),
        _tx(10, TransactionIntent.investmentBuy),
        _tx(999, TransactionIntent.debtSettled, party: other),
      ], 'p-tomas');

      expect(debt.hasHistory, isFalse);
      expect(debt.direction, PartyDebtDirection.settled);
    });

    test('fully repaid balance is settled', () {
      final debt = computePartyDebt([
        _tx(80, TransactionIntent.debtSettled),
        _tx(80, TransactionIntent.debtOwed),
      ], 'p-tomas');

      expect(debt.direction, PartyDebtDirection.settled);
      expect(debt.outstanding, 0);
      expect(debt.progress, 1);
    });

    test('amounts in other currencies are converted to the base first', () {
      final rates = ExchangeRateEntity(
        provider: 'test',
        baseCode: 'EUR',
        rates: const {'EUR': 1, 'XAF': 655.957},
        timeLastUpdated: _t0,
        timeNextUpdated: _t0,
      );
      final debt = computePartyDebt([
        _tx(120, TransactionIntent.debtSettled),
        _tx(26238.28, TransactionIntent.debtOwed, currency: 'XAF'),
      ], 'p-tomas', rates: rates);

      expect(debt.inflow, closeTo(40, 0.01));
      expect(debt.net, closeTo(-80, 0.01));
      expect(debt.direction, PartyDebtDirection.theyOweYou);
    });
  });
}
