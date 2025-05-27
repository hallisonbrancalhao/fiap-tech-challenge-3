import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/data/source/transactions_api_service.dart';
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/service_locator.dart';

class TransactionsRepositoryImpl extends TransactionsRepository {
  @override
  Future<Either> addTransaction(TransactionCreateDto transaction) async {
    Either result = await sl<TransactionsApiService>().addTransaction(
      transaction,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> deleteTransaction(String id) async {
    Either result = await sl<TransactionsApiService>().deleteTransaction(id);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> getTransactions() async {
    Either result = await sl<TransactionsApiService>().getTransactions();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  ) async {
    Either result = await sl<TransactionsApiService>().updateTransaction(
      id,
      transaction,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
