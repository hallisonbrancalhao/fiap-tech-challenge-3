import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';

abstract class TransactionsRepository {
  Future<Either<List<TransactionEntity>, Exception>> getTransactions(
    String userId,
  );
  Future<Either<String, String>> addTransaction(
    TransactionCreateDto transaction,
  );
  Future<Either<String, String>> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  );
  Future<Either<void, String>> deleteTransaction(String id);
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  );
}
