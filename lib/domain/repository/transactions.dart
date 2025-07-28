import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart'; // ADICIONAR ESTE IMPORT


abstract class TransactionsRepository {
  Future<Either<String, String>> addTransaction(TransactionEntity transaction);
  Future<Either<String, List<TransactionEntity>>> getTransactions();
  Future<Either<String, void>> updateTransaction(
    String id,
    TransactionEntity transaction,
  );
  Future<Either<String, void>> deleteTransaction(String id);
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  );
}