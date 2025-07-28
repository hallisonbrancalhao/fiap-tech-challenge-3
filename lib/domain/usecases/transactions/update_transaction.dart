import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart'; // Import TransactionEntity
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/service_locator.dart';

class UpdateTransactionUseCase
    implements UseCase<Either<String, void>, TransactionUpdateDto> {

  @override
  Future<Either<String, void>> call({String? id, TransactionUpdateDto? param}) async {
    if (id == null || param == null) {
      return const Left('ID and transaction parameters cannot be null.');
    }

    final String currentUserUid = 'some_authenticated_user_id'; // <<-- REPLACE THIS!

    final transactionEntity = TransactionEntity.fromUpdateDto(
      param,
      id: id,
      userUid: currentUserUid, // <--- THIS IS THE MISSING ARGUMENT!
    );
    return sl<TransactionsRepository>().updateTransaction(id, transactionEntity);
  }
}