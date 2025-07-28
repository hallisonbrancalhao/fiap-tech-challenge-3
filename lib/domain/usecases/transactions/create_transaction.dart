import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/service_locator.dart';

class CreateTransactionUseCase
    implements UseCase<Either, TransactionCreateDto> {
  @override
  Future<Either> call({TransactionCreateDto? param}) async {
    final user = sl<AuthRepository>().getUser();

    return sl<TransactionsRepository>().addTransaction(param!);
  }
}
