import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class DeleteTransactionUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? param}) async {
    return sl<TransactionsRepository>().deleteTransaction(param!);
  }
}
