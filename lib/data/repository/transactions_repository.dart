import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/domain/source/transactions_service.dart';
import 'package:tech_challenge_3/service_locator.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  @override
  Future<Either<String, String>> addTransaction(
    TransactionCreateDto transaction,
  ) async {
    Either<String, String> result = await sl<TransactionsService>()
        .addTransaction(transaction);
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
  Future<Either<String, void>> deleteTransaction(String id) async {
    Either result = await sl<TransactionsService>().deleteTransaction(id);
    return result.fold((data) => Right(null), (error) => Left(error));
  }

  @override
  Future<Either<Exception, List<TransactionEntity>>> getTransactions(
    String userId,
  ) async {
    Either<Exception, List<TransactionModel>> result =
        await sl<TransactionsService>().getTransactions(userId);

    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final List<TransactionEntity> transactions =
            data.map((model) => model.toEntity()).toList();
        return Right(transactions);
      },
    );
  }

  @override
  Future<Either<String, String>> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  ) async {
    Either result = await sl<TransactionsService>().updateTransaction(
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

  @override
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  ) async {
    final result = await sl<TransactionsService>().uploadAttachment(
      transactionId,
      imageFile,
    );
    return result.fold((error) => Left(error), (url) => Right(url));
  }
}
