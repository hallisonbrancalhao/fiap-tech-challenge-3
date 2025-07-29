import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tech_challenge_3/data/models/transaction.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/source/transactions_service.dart';

class TransactionsApiServiceImpl implements TransactionsService {
  @override
  Future<Either<Exception, List<TransactionModel>>> getTransactions(
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
      return Right(transactions);
    } on Exception catch (e) {
      return Left(e);
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

      return Right(docRef.id);
    } catch (e) {
      return Left('Failed to add transaction: $e');
    }
  }

  @override
  Future<Either<String, void>> updateTransaction(
    String id,
    TransactionUpdateDto transaction,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(id)
          .update(transaction.toJson());

      return Right(null);
    } catch (e) {
      return Left('Failed to update transaction: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteTransaction(String id) async {
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

  @override
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  ) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Left('User not authenticated');
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

      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left('Erro de Storage: ${e.code} - ${e.message}');
    } catch (e) {
      return Left('Falha ao enviar anexo: $e');
    }
  }
}
