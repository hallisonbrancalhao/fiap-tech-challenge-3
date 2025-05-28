import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';

abstract class TransactionsApiService {
  Future<Either> getTransactions();
  Future<Either> addTransaction(TransactionCreateDto transaction);
  Future<Either> updateTransaction(String id, TransactionUpdateDto transaction);
  Future<Either> deleteTransaction(String id);
  Future<Either<String, String>> uploadAttachment(
    String transactionId,
    File imageFile,
  );
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
        userUid: user.uid,
        type: transaction.type,
        description: transaction.description,
        amount: transaction.amount,
        date: transaction.date,
      );

      final docRef = await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionEntity.toJson());

      await docRef.update({'id': docRef.id});

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
