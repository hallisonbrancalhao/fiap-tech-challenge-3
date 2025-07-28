import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/service_locator.dart';

class CreateTransactionUseCase
    implements UseCase<Either<String, String>, TransactionCreateDto> {

  @override
  Future<Either<String, String>> call({TransactionCreateDto? param}) async {
    if (param == null) {
      return const Left('Parâmetro de transação não pode ser nulo.');
    }

    final String currentUserUid = 'some_hardcoded_user_uid'; // <<< ATENÇÃO: SUBSTITUA ISSO!

    final TransactionEntity transactionEntity = TransactionEntity.fromCreateDto(
      param,
      userUid: currentUserUid,
    );
    return sl<TransactionsRepository>().addTransaction(transactionEntity);
  }
}