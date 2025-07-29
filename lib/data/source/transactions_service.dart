import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tech_challenge_3/data/models/transaction.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/source/transactions_service.dart';

class TransactionsServiceImpl implements TransactionsService {
  @override
  Future<Either<List<TransactionModel>, Exception>> getTransactions(
    userId,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('transactions')
              .where('userUid', isEqualTo: userId)
              .get();

      final List<TransactionModel> transactions =
          snapshot.docs
              .map(
                (doc) =>
                    TransactionModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList();
      return Left(transactions);
    } on Exception catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<String, String>> addTransaction(
    TransactionCreateDto transaction,
  ) async {
    try {
      final transactionModel = TransactionModel(
        userUid: transaction.userUid ?? '',
        type: transaction.type,
        description: transaction.description,
        amount: transaction.amount,
        date: transaction.date,
      );

      final docRef = await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionModel.toJson());

      return Left(docRef.id);
    } catch (e) {
      return Right('Failed to add transaction: $e');
    }
  }

  @override
  Future<Either<void, String>> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(id)
          .update(transaction.toJson());

      return Left(null);
    } catch (e) {
      return Right('Failed to update transaction: $e');
    }
  }

  @override
  Future<Either<void, String>> deleteTransaction(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(id)
          .delete();
      return Left(null);
    } catch (e) {
      return Right('Failed to delete transaction: $e');
    }
  }

  @override
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  ) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Right('User not authenticated');
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName =
          'attachment_${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
      final attachmentRef = storageRef.child(
        'transaction_attachments/${user.uid}/$transactionId/$fileName',
      );

      UploadTask uploadTask = attachmentRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .update({'attachmentUrl': downloadUrl});

      return Left(downloadUrl);
    } on FirebaseException catch (e) {
      return Right('Erro de Storage: ${e.code} - ${e.message}');
    } catch (e) {
      return Right('Falha ao enviar anexo: $e');
    }
  }
}
