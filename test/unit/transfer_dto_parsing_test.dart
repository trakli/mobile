import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/transfer/dto/transfer_dto.dart';

/// Server shape for `GET /transfers`, trimmed to the fields the DTO reads.
Map<String, dynamic> _payload({
  Object? datetime = '2026-07-09T22:56:21.000000Z',
  Object? createdAt = '2026-07-09T22:56:20.000000Z',
  Object? updatedAt = '2026-07-09T22:56:20.000000Z',
}) =>
    <String, dynamic>{
      'id': 12,
      'user_id': 2,
      'client_generated_id': 'device:transfer-1',
      'rev': '1',
      'amount': '7500.0000',
      'exchange_rate': '1.000000',
      'from_wallet_id': 6,
      'to_wallet_id': 7,
      'datetime': datetime,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': null,
      'last_synced_at': null,
      'source_wallet': null,
      'destination_wallet': null,
      'expense_transaction_client_id': null,
      'income_transaction_client_id': null,
    };

void main() {
  group('TransferDto.fromJson', () {
    test('parses a fully populated transfer', () {
      final transfer = TransferDto.fromJson(_payload()).toTransfer();

      expect(transfer.datetime, DateTime.parse('2026-07-09T22:56:21.000000Z'));
      expect(transfer.createdAt, DateTime.parse('2026-07-09T22:56:20.000000Z'));
      expect(transfer.amount, 7500.0);
    });

    // `transfers.datetime` is nullable server-side and was only populated from
    // the 2026-02-23 backend change onwards. One such row used to throw
    // "type 'Null' is not a subtype of type 'String'" out of the page parse,
    // which failed the whole transfer down-sync on every cycle.
    test('falls back to created_at when datetime is null', () {
      final transfer =
          TransferDto.fromJson(_payload(datetime: null)).toTransfer();

      expect(transfer.datetime, DateTime.parse('2026-07-09T22:56:20.000000Z'));
    });

    test('survives null timestamps', () {
      final transfer = TransferDto.fromJson(
        _payload(datetime: null, createdAt: null, updatedAt: null),
      ).toTransfer();

      expect(transfer.datetime, transfer.createdAt);
      expect(transfer.updatedAt, transfer.createdAt);
    });

    test('a missing datetime key is treated like a null one', () {
      final json = _payload()..remove('datetime');

      expect(
        TransferDto.fromJson(json).toTransfer().datetime,
        DateTime.parse('2026-07-09T22:56:20.000000Z'),
      );
    });
  });
}
