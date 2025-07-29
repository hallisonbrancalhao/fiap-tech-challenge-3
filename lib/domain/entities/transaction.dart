import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionEntity {
  final String? id;
  final String userUid;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  TransactionEntity({
    this.id,
    required this.userUid,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.attachmentUrl,
  });
}
