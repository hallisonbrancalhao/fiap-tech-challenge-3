import 'package:tech_challenge_3/domain/entities/transaction_type.dart';

class Transaction {
  final String? id;
  final String userId;
  final TransactionType transactionType;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  Transaction({
    this.id,
    required this.userId,
    required this.transactionType,
    required this.amount,
    required this.date,
    this.attachmentUrl,
  });
}
