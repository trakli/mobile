import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

enum PartyDebtDirection { theyOweYou, youOweThem, settled }

class PartyDebtBalance {
  /// Sum of `loan_received` and `debt_owed` movements (money in).
  final double inflow;

  /// Sum of `loan_repayment` and `debt_settled` movements (money out).
  final double outflow;

  /// The financial position formula: inflow minus outflow. Positive means
  /// you owe the party, negative means the party owes you.
  final double net;

  const PartyDebtBalance({
    required this.inflow,
    required this.outflow,
    required this.net,
  });

  static const double _epsilon = 0.005;

  PartyDebtDirection get direction {
    if (net > _epsilon) return PartyDebtDirection.youOweThem;
    if (net < -_epsilon) return PartyDebtDirection.theyOweYou;
    return PartyDebtDirection.settled;
  }

  double get outstanding => net.abs();

  /// What started the debt: the money lent out when they owe you, or the
  /// money received when you owe them.
  double get total => switch (direction) {
        PartyDebtDirection.theyOweYou => outflow,
        PartyDebtDirection.youOweThem => inflow,
        PartyDebtDirection.settled => outflow > inflow ? outflow : inflow,
      };

  /// What has come back against [total].
  double get repaid => switch (direction) {
        PartyDebtDirection.theyOweYou => inflow,
        PartyDebtDirection.youOweThem => outflow,
        PartyDebtDirection.settled => total,
      };

  double get progress => total <= 0 ? 0 : (repaid / total).clamp(0.0, 1.0);

  bool get hasHistory => inflow > 0 || outflow > 0;
}

bool isLoanOrDebtIntent(TransactionIntent intent) => switch (intent) {
      TransactionIntent.loanReceived ||
      TransactionIntent.debtOwed ||
      TransactionIntent.loanRepayment ||
      TransactionIntent.debtSettled =>
        true,
      _ => false,
    };

/// Per-party version of the server's `loans_debt_net`
/// (`(loan_received + debt_owed) - (loan_repayment + debt_settled)`), over
/// the transactions linked to [partyClientId]. Amounts are converted from
/// each wallet's currency into the rates' base currency when [rates] is
/// given.
PartyDebtBalance computePartyDebt(
  List<TransactionCompleteEntity> transactions,
  String partyClientId, {
  ExchangeRateEntity? rates,
}) {
  double inflow = 0;
  double outflow = 0;
  for (final t in transactions) {
    if (t.party?.clientId != partyClientId &&
        t.transaction.partyClientId != partyClientId) {
      continue;
    }
    final amount = _toBase(t, rates);
    switch (t.transaction.intent) {
      case TransactionIntent.loanReceived:
      case TransactionIntent.debtOwed:
        inflow += amount;
      case TransactionIntent.loanRepayment:
      case TransactionIntent.debtSettled:
        outflow += amount;
      default:
        break;
    }
  }
  return PartyDebtBalance(
    inflow: inflow,
    outflow: outflow,
    net: inflow - outflow,
  );
}

double _toBase(TransactionCompleteEntity t, ExchangeRateEntity? rates) {
  final amount = t.transaction.amount;
  if (rates == null) return amount;
  final code = t.wallet.currencyCode;
  if (code == rates.baseCode) return amount;
  return amount / (rates.rates[code] ?? 1);
}
