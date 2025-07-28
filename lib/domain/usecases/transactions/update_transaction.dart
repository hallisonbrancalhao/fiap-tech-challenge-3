import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class UpdateTransactionUseCase
    implements UseCase<Either, TransactionUpdateDto> {
  @override
  Future<Either> call({String? id, TransactionUpdateDto? param}) async {
    return sl<TransactionsRepository>().updateTransaction(id!, param!);
  }
}
