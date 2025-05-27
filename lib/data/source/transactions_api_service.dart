import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';

abstract class TransactionsApiService {
  Future<Either> getTransactions();
  Future<Either> addTransaction(TransactionCreateDto transaction);
  Future<Either> updateTransaction(String id, TransactionUpdateDto transaction);
  Future<Either> deleteTransaction(String id);
}

class TransactionsApiServiceImpl extends TransactionsApiService {
  @override
  Future<Either> getTransactions() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Left('User not authenticated');
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('transactions')
              .where('userUid', isEqualTo: user.uid)
              .get();

      final List<TransactionEntity> transactions =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return TransactionEntity.fromJson(data);
          }).toList();
      return Right(transactions);
    } catch (e) {
      return Left('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<Either> addTransaction(TransactionCreateDto transaction) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Left('User not authenticated');
    }

    try {
      final transactionEntity = TransactionEntity(
        uid: '',
        userUid: user.uid,
        type: transaction.type,
        description: transaction.description,
        amount: transaction.amount,
        date: DateTime.now(),
      );

      final docRef = await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionEntity.toJson());

      return Right(docRef.id);
    } catch (e) {
      return Left('Failed to add transaction: $e');
    }
  }

  @override
  Future<Either> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  ) async {
    try {
      final transactionToUpdate = TransactionUpdateDto(
        uid: id,
        type: transaction.type,
        description: transaction.description,
        amount: transaction.amount,
        date: transaction.date,
      );

      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(id)
          .update(transactionToUpdate.toJson());

      return Right(null);
    } catch (e) {
      return Left('Failed to update transaction: $e');
    }
  }

  @override
  Future<Either> deleteTransaction(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(id)
          .delete();
      return Right(null);
    } catch (e) {
      return Left('Failed to delete transaction: $e');
    }
  }
}
