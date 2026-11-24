import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/usecases/transaction/add_media_to_transaction_usecase.dart';
import 'package:trakli/domain/usecases/transaction/delete_media_usecase.dart';
import 'package:trakli/domain/usecases/transaction/get_file_content_usecase.dart';
import 'package:trakli/domain/usecases/transaction/get_media_for_transaction_usecase.dart';
import 'package:trakli/domain/usecases/transaction/usecase.dart';
import 'package:trakli/domain/usecases/wallet/get_wallets_usecase.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockGetAll extends Mock implements GetAllTransactionsUseCase {}

class _MockCreate extends Mock implements CreateTransactionUseCase {}

class _MockAddMedia extends Mock implements AddMediaToTransactionUseCase {}

class _MockDeleteMedia extends Mock implements DeleteMediaUseCase {}

class _MockGetMedia extends Mock implements GetMediaForTransactionUseCase {}

class _MockGetFile extends Mock implements GetFileContentUseCase {}

class _MockUpdate extends Mock implements UpdateTransactionUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

class _MockMarkRefund extends Mock implements MarkTransactionRefundUseCase {}

class _MockUnmarkRefund extends Mock
    implements UnmarkTransactionRefundUseCase {}

class _MockGetWallets extends Mock implements GetWalletsUseCase {}

class _MockListen extends Mock implements ListenToTransactionsUseCase {}

void main() {
  late _MockCreate create;
  late _MockUpdate update;
  late TransactionCubit cubit;

  final now = DateTime(2026, 1, 1);
  final activeGroup = GroupEntity(
    clientId: 'group-active',
    name: 'Household',
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(CreateTransactionParams(
      amount: 0,
      description: '',
      categoryIds: const [],
      type: TransactionType.expense,
      datetime: now,
      walletClientId: '',
    ));
    registerFallbackValue(UpdateTransactionParams(id: ''));
  });

  setUp(() {
    create = _MockCreate();
    update = _MockUpdate();
    final listen = _MockListen();
    when(() => listen(any())).thenAnswer((_) =>
        const Stream<Either<Failure, List<TransactionCompleteEntity>>>.empty());
    when(() => create(any())).thenAnswer((_) async => const Right(unit));
    when(() => update(any())).thenAnswer((_) async => const Right(unit));

    cubit = TransactionCubit(
      getAllTransactionsUseCase: _MockGetAll(),
      createTransactionUseCase: create,
      addMediaToTransactionUseCase: _MockAddMedia(),
      deleteMediaUseCase: _MockDeleteMedia(),
      getMediaForTransactionUseCase: _MockGetMedia(),
      getFileContentUseCase: _MockGetFile(),
      updateTransactionUseCase: update,
      deleteTransactionUseCase: _MockDelete(),
      markTransactionRefundUseCase: _MockMarkRefund(),
      unmarkTransactionRefundUseCase: _MockUnmarkRefund(),
      listenToTransactionsUseCase: listen,
      getWalletsUseCase: _MockGetWallets(),
    );
  });

  tearDown(() => cubit.close());

  Future<CreateTransactionParams> addWith({String? groupClientId}) async {
    await cubit.addTransaction(
      amount: 12,
      description: 'Lunch',
      type: TransactionType.expense,
      datetime: now,
      walletClientId: 'wallet-1',
      groupClientId: groupClientId,
    );
    return verify(() => create(captureAny())).captured.single
        as CreateTransactionParams;
  }

  test('a group picked on the form is used for a new transaction', () async {
    await cubit.setCurrentGroup(activeGroup);

    final params = await addWith(groupClientId: 'group-picked');

    expect(params.groupClientId, 'group-picked');
  });

  test('a new transaction falls back to the active group', () async {
    await cubit.setCurrentGroup(activeGroup);

    final params = await addWith();

    expect(params.groupClientId, 'group-active');
  });

  test('an edit forwards the picked group', () async {
    await cubit.updateTransaction(id: 'tx-1', groupClientId: 'group-picked');

    final params = verify(() => update(captureAny())).captured.single
        as UpdateTransactionParams;
    expect(params.groupClientId, 'group-picked');
  });
}
