import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/data/source/transactions_api_service.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/repository/transactions.dart';
import 'package:tech_challenge_3/service_locator.dart';

class TransactionsRepositoryImpl extends TransactionsRepository {
  
  @override
  Future<Either<String, String>> addTransaction(TransactionEntity transaction) async {
    final dto = TransactionCreateDto(
      type: transaction.type,
      description: transaction.description,
      amount: transaction.amount,
      date: transaction.date,
    );

    final result = await sl<TransactionsApiService>().addTransaction(dto);
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<String, void>> deleteTransaction(String id) async {
    final result = await sl<TransactionsApiService>().deleteTransaction(id);
    return result.fold(
      (error) => Left(error),
      (data) => const Right(null),
    );
  }

  @override
  Future<Either<String, List<TransactionEntity>>> getTransactions() async {
    final result = await sl<TransactionsApiService>().getTransactions();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data as List<TransactionEntity>),
    );
  }

  @override
  Future<Either<String, void>> updateTransaction(
    String id,
    TransactionEntity transaction,
  ) async {
    final dto = TransactionUpdateDto(
      type: transaction.type,
      description: transaction.description,
      amount: transaction.amount,
      date: transaction.date,
    );

    final result = await sl<TransactionsApiService>().updateTransaction(id, dto);
    return result.fold(
      (error) => Left(error),
      (data) => const Right(null),
    );
  }

  @override
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  ) async {
    final result = await sl<TransactionsApiService>().uploadAttachment(
      transactionId,
      imageFile,
    );
    return result.fold((error) => Left(error), (url) => Right(url));
  }
}
