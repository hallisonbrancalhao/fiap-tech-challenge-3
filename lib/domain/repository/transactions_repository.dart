import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';

abstract class TransactionsRepository {
  Future<Either<dynamic, dynamic>> getTransactions(String userId);
  Future<Either<String, String>> addTransaction(
    TransactionCreateDto transaction,
  );
  Future<Either<dynamic, dynamic>> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  );
  Future<Either<dynamic, dynamic>> deleteTransaction(String id);
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  );
}
