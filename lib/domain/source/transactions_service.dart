import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';

abstract class TransactionsService {
  Future<Either<List<TransactionModel>, Exception>> getTransactions(
    String userId,
  );
  Future<Either<String, String>> addTransaction(
    TransactionCreateDto transaction,
  );
  Future<Either> updateTransaction(String id, TransactionUpdateDto transaction);
  Future<Either> deleteTransaction(String id);
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  );
}
